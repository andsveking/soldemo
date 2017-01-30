module demo

require io
require math
require rnd
require C

require glfw
require gl
require fmod

require matrix
require vector

let rng: rnd.MT19937 = rnd.MT19937{}

!main
fn main(args:[String]): int
    rng.seed(0u32)
    create_lut()

    if glfw.init() == 0 then
        return -1
    end

    -- get a ogl >= 3.2 context on OSX
    -- lets us use layout(location = x)
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 2)
    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, 1)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    window = glfw.create_window(800, 600, "sol")
    window.make_context_current()

    if window.is_valid() then
        window.show()
        -- init audio and load sound
        let sound_system = init_audio()
        let drum_sound = load_sound(sound_system, "data/music/skadad.mp3")
        music_channel = play_sound(sound_system, drum_sound)

        run_floor()
    else
        panic("could not create window!")
    end

    -- release scenes
    glfw.terminate()
    io.println("glfw terminated!")

    return 0
end


------------------------------------------------------------------
-- QuadBatch

struct QuadBatch
    vert_buf: [float]
    uv_buf: [float]
    capacity: int
    cursor: int

    -- gl stuff
    vert_gl: gl.Buffer
    uv_gl: gl.Buffer
    vao: gl.VertexArrayObject

    fn start()
        self.cursor = 0
    end

    fn finish()
        let i = self.cursor*3*6

        gl.bind_vertex_array(self.vao)

        gl.enable_vertex_attrib_array(0)
        gl.bind_buffer(gl.ARRAY_BUFFER, self.vert_gl)
        check_error("qb_render: binding vert buffer", false)
        gl.buffer_data(gl.ARRAY_BUFFER, C.uintptr((i*4) as uint32), self.vert_buf as handle, gl.STATIC_DRAW)
        check_error("qb_render: upload vert buffer", false)
        gl.vertex_attrib_pointer(0u32, 3u32, gl.FLOAT, false, 0, C.uintptr(0u32))

        gl.enable_vertex_attrib_array(1)
        gl.bind_buffer(gl.ARRAY_BUFFER, self.uv_gl)
        check_error("qb_render: binding uv buffer", false)
        gl.buffer_data(gl.ARRAY_BUFFER, C.uintptr((i*4) as uint32), self.uv_buf as handle, gl.STATIC_DRAW)
        check_error("qb_render: upload uv buffer", false)
        gl.vertex_attrib_pointer(1u32, 2u32, gl.FLOAT, false, 0, C.uintptr(0u32))

        gl.bind_vertex_array(gl.NULL_VAO)
    end

    fn render()
        gl.bind_vertex_array(self.vao)
        gl.draw_arrays(gl.TRIANGLES, 0u32, self.cursor*6);
    end
end


------------------------------------------------------------------
-- External APIs

-- C Std funcs
!nogc extern fopen(filename: String, mode: String): uint64
!nogc extern fseek(stream: uint64, offset: int64, whence: int): int
!nogc extern ftell(stream: uint64): int
!nogc extern fclose(stream: uint64): int
!nogc extern fread(ptr: [byte], size: int, count: int, stream: uint64): int64
!nogc extern chdir(path: String): int


-----------------------------------------------------------------------
-- Defines/enums

let SEEK_SET: int = 0
let SEEK_CUR: int = 1
let SEEK_END: int = 2

--
local window: glfw.Window


------------------------------------------------------------------------
-- Helpers
fn error_lut(id: uint32): String
    if id == 0u32 then
        return "GL_NO_ERROR"
    elseif id == 0x0500u32 then
        return "GL_INVALID_ENUM"                   -- 0x0500
    elseif id == 0x0501u32 then
        return "GL_INVALID_VALUE"                  -- 0x0501
    elseif id == 0x0502u32 then
        return "GL_INVALID_OPERATION"              -- 0x0502
    end

    return "unknown"
end

fn log_error(id: String)
    io.println("[ \x1B[31m!!\x1B[0m ] " .. id)
end

fn log_ok(id: String)
    io.println("[ \x1B[32mok\x1B[0m ] " .. id)
end

fn random(): float
    return rng.next_float()
end

fn check_error(id: String, print_on_ok: bool): bool
    local err = gl.get_error()
    if err ~= 0u32 then
        log_error(id .. " - Error: " .. error_lut(err))
        return false
    end

    if print_on_ok then
        log_ok(id)
    end
    return true
end


fn shader_log(obj: gl.Shader)
    let size = gl.get_shaderiv(obj, gl.SP_INFO_LOG_LENGTH)
    if size == 0 then
        return
    end
    let log = gl.get_shader_info_log(obj, size as uint32)
    io.println("Shader log:\n" .. log)
end


fn program_log(obj: gl.Program)
    let size = gl.get_programiv(obj, gl.PP_INFO_LOG_LENGTH)
    if size == 0 then
        return
    end
    let log = gl.get_program_info_log(obj, size as uint32)
    io.println("Shader log:\n" .. log)
end


fn read_file(file_path: String): [byte]
    let f = fopen(file_path, "r")

    if f ~= 0u64 then
        fseek(f, 0i64, SEEK_END)
        local len: int = ftell(f) + 1
        local ret: [byte] = [len:byte]
        fseek(f, 0i64, SEEK_SET)
        -- FIXME make sure we read the whole file...
        fread(ret, 1, len, f)
        fclose(f);

        -- make sure we null term
        ret[len-1] = 0u8

        log_ok("read " .. file_path)

        return ret
    else
        panic("could not open " .. file_path)
    end
end


fn read_file_as_string(file_path: String): String
    return string(read_file(file_path))
end


------------------------------------------------------------------------
-- "Resources"
fn create_texture(width: int, height: int, data: [byte]): uint32
    let texture = gl.gen_texture()
    check_error("creating texture", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, texture)
    check_error("bound texture", false)

    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)

    gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.UNSIGNED_BYTE, data)
    check_error("uploaded texture data", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, 0u32)
    check_error("unbound texture", false)

    return texture
end


fn create_empty_texture(width: int, height: int): uint32
    let texture = gl.gen_texture()
    check_error("creating empty texture", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, texture)
    check_error("bind texture", true)

    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)

    gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.UNSIGNED_BYTE, 0u32)
    check_error("upload empty texture", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, 0u32)
    check_error("unbound texture", true)

    return texture
end


fn create_fbo(width: int, height: int, attach_depth: bool): uint32, uint32
    io.print(width)
    io.print(height)

    local framebuffers: [uint32] = [1:uint32]
    gl.gen_framebuffers(1, framebuffers)
    check_error("creating fbo", true)

    local fbo: uint32 = framebuffers[0]
    gl.bind_framebuffer(gl.GL_FRAMEBUFFER, fbo)

    -- gen empty texture
    let texture = create_empty_texture(width, height)

    let depthbuffer = gl.gen_renderbuffer()
    check_error("creating depth buffer", true)
    gl.bind_renderbuffer(gl.GL_RENDERBUFFER, depthbuffer)
    gl.renderbuffer_storage(gl.GL_RENDERBUFFER, gl.GL_DEPTH_COMPONENT, width, height)
    check_error("binding depth buffer", true)
    gl.framebuffer_renderbuffer(gl.GL_FRAMEBUFFER, gl.GL_DEPTH_ATTACHMENT, gl.GL_RENDERBUFFER, depthbuffer)
    check_error("binding texture", true)
    gl.framebuffer_texture(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, texture, 0)

    let fbo_status = gl.check_framebuffer_status(gl.GL_FRAMEBUFFER)
    if fbo_status ~= gl.GL_FRAMEBUFFER_COMPLETE then
        log_error("fbo is not complete!")
    else
        log_ok("fbo is complete")
    end
    gl.bind_framebuffer(gl.GL_FRAMEBUFFER, 0u32)

    return fbo, texture
end


fn render_to_fbo(fbo: uint32)
    gl.bind_framebuffer(gl.GL_FRAMEBUFFER, fbo)
    check_error("binding fbo", false)

    if (fbo ~= 0u32) then
        gl.draw_buffer(gl.GL_COLOR_ATTACHMENT0)
        check_error("drawing to fbo", false)
    end
end


fn create_quad_batch(capacity: int): QuadBatch
    let qb = QuadBatch {
        vert_buf = [capacity*3*6: float],
        uv_buf   = [capacity*2*6: float],
        capacity = capacity,
        cursor   = 0
    }

    -- generate gl buffers
    qb.vert_gl = gl.gen_buffer()
    qb.uv_gl = gl.gen_buffer()

    qb.vao = gl.gen_vertex_array()

    gl.bind_vertex_array(qb.vao)
    gl.enable_vertex_attrib_array(0)
    gl.bind_buffer(gl.ARRAY_BUFFER, qb.vert_gl)
    gl.vertex_attrib_pointer(0u32, 3u32, gl.FLOAT, false, 0, C.uintptr(0u32))
    gl.bind_vertex_array(gl.NULL_VAO)

    return qb
end


fn qb_add(qb: QuadBatch, x0: float, y0: float, x1: float, y1: float, u0: float, v0: float, u1: float, v1: float)
--    d - c
--    | / |
--    a - b

    let i = qb.cursor*3*6 -- (x,y) * vert_count * triangle_count_per_quad

    -- vertices
    -- tri A: a,b,c
    qb.vert_buf[i+ 0] = x0
    qb.vert_buf[i+ 1] = y0
    qb.vert_buf[i+ 2] = 0f

    qb.vert_buf[i+ 3] = x1
    qb.vert_buf[i+ 4] = y0
    qb.vert_buf[i+ 5] = 0f

    qb.vert_buf[i+ 6] = x1
    qb.vert_buf[i+ 7] = y1
    qb.vert_buf[i+ 8] = 0f

    -- tri B: a,c,d
    qb.vert_buf[i+ 9] = x0
    qb.vert_buf[i+10] = y0
    qb.vert_buf[i+11] = 0f

    qb.vert_buf[i+12] = x1
    qb.vert_buf[i+13] = y1
    qb.vert_buf[i+14] = 0f

    qb.vert_buf[i+15] = x0
    qb.vert_buf[i+16] = y1
    qb.vert_buf[i+17] = 0f

    let i = qb.cursor * 2 * 6
    -- uv0
    -- tri A: a,b,c
    qb.uv_buf[i+ 0] = u0
    qb.uv_buf[i+ 1] = v0

    qb.uv_buf[i+ 2] = u1
    qb.uv_buf[i+ 3] = v0

    qb.uv_buf[i+ 4] = u1
    qb.uv_buf[i+ 5] = v1

    -- tri B: a,c,d
    qb.uv_buf[i+ 6] = u0
    qb.uv_buf[i+ 7] = v0

    qb.uv_buf[i+ 8] = u1
    qb.uv_buf[i+ 9] = v1

    qb.uv_buf[i+10] = u0
    qb.uv_buf[i+11] = v1

    qb.cursor = qb.cursor + 1
end


fn qb_write(qb: QuadBatch, where_pos:int, x: float, y: float, z: float)
    qb.vert_buf[where_pos + 0] = x
    qb.vert_buf[where_pos + 1] = y
    qb.vert_buf[where_pos + 2] = z
end


fn qb_write_cube_side(qb: QuadBatch, where_pos:int, where_uv:int, x:float, y:float, z:float, ux:float, uy:float, uz:float, vx:float, vy:float, vz:float, u:float, v:float)
    qb_write(qb, where_pos + 0, x - ux - vx, y - uy - vy, z - uz - vz)
    qb_write(qb, where_pos + 3, x + ux - vx, y + uy - vy, z + uz - vz)
    qb_write(qb, where_pos + 6, x + ux + vx, y + uy + vy, z + uz + vz)
    qb_write(qb, where_pos + 9, x - ux - vx, y - uy - vy, z - uz - vz)
    qb_write(qb, where_pos + 12, x + ux + vx, y + uy + vy, z + uz + vz)
    qb_write(qb, where_pos + 15, x - ux + vx, y - uy + vy, z - uz + vz)
    for col=0, 6 do
        qb.uv_buf[where_uv + 2*col + 0] = u
        qb.uv_buf[where_uv + 2*col + 1] = v
    end
end

fn qb_write_cube(qb: QuadBatch, x:float, y:float, z:float)
    local szf = 0.50f
    qb_write_cube_side(qb, 3*6*(qb.cursor+0), 2*6*(qb.cursor+0), x + 0.0f, y + 0.0f, z - szf, szf, 0.0f, 0.0f, 0.0f, szf, 0.0f, 1f, 0f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+1), 2*6*(qb.cursor+1), x + 0.0f, y + 0.0f, z + szf,-szf, 0.0f, 0.0f, 0.0f,-szf, 0.0f, 1f, 0f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+2), 2*6*(qb.cursor+2), x + szf, y + 0.0f, z + 0.0f, 0.0f, 0.0f, szf, 0.0f, szf, 0.0f, 0f, 1f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+3), 2*6*(qb.cursor+3), x - szf, y + 0.0f, z + 0.0f, 0.0f, 0.0f,-szf, 0.0f, szf, 0.0f, 0f, 1f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+4), 2*6*(qb.cursor+4), x + 0.0f, y + szf, z + 0.0f, szf, 0.0f, 0.0f, 0.0f, 0.0f, szf, 0f, 0f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+5), 2*6*(qb.cursor+5), x + 0.0f, y - szf, z + 0.0f,-szf, 0.0f, 0.0f, 0.0f, 0.0f,-szf, 0f, 0f)
    qb.cursor = qb.cursor + 6;
end


fn qb_write_plusbox(qb:QuadBatch, t:float)
    local s = 100f - 100f*t*t
    if t <= 0f then
        return
    end
    if s < 0f then
        s = 0f
    end

    for x=-1,2 do
        for y=-1,2 do
            for z=-1,2 do
                if (x*x + y*y + z*z) ~= 3 and (x*x+y*y+z*z) ~= 0 then
                    for a=0,5 do
                        for b=0,5 do
                            for c=0,5 do
                                local kx = (5*x+a) as float - 2f
                                local ky = (5*y+b) as float - 2f
                                local kz = (5*z+c) as float - 2f
                                qb_write_cube(qb, kx + s*kx, ky + s*ky, kz + s*kz)
                            end
                        end
                    end
                end
            end
        end
    end
end


fn qb_add_3d(qb: QuadBatch, x0: float, y0: float, x1: float, y1: float, u0: float, v0: float, u1: float, v1: float, z: vector.Vector4)
--   d - c
--   | / |
--   a - b

    let i: int = qb.cursor*3*6 -- (x,y) * vert_count * triangle_count_per_quad

    -- vertices
    -- tri A: a,b,c
    qb.vert_buf[i+ 1] = y0
    qb.vert_buf[i+ 2] = z.x
    qb.vert_buf[i+ 0] = x0

    qb.vert_buf[i+ 4] = y0
    qb.vert_buf[i+ 5] = z.y
    qb.vert_buf[i+ 3] = x1

    qb.vert_buf[i+ 7] = y1
    qb.vert_buf[i+ 8] = z.w
    qb.vert_buf[i+ 6] = x1

    -- tri B: a,c,d
    qb.vert_buf[i+10] = y0
    qb.vert_buf[i+11] = z.x
    qb.vert_buf[i+9] = x0

    qb.vert_buf[i+13] = y1
    qb.vert_buf[i+14] = z.w
    qb.vert_buf[i+12] = x1

    qb.vert_buf[i+16] = y1
    qb.vert_buf[i+17] = z.z
    qb.vert_buf[i+15] = x0

    let i = qb.cursor * 2 * 6
    -- uv0
    -- tri A: a,b,c
    qb.uv_buf[i+ 0] = u0
    qb.uv_buf[i+ 1] = v0

    qb.uv_buf[i+ 2] = u1
    qb.uv_buf[i+ 3] = v0

    qb.uv_buf[i+ 4] = u1
    qb.uv_buf[i+ 5] = v1

    -- tri B: a,c,d
    qb.uv_buf[i+ 6] = u0
    qb.uv_buf[i+ 7] = v0

    qb.uv_buf[i+ 8] = u1
    qb.uv_buf[i+ 9] = v1

    qb.uv_buf[i+10] = u0
    qb.uv_buf[i+11] = v1

    qb.cursor = qb.cursor + 1

end


fn qb_add_centered(qb: QuadBatch, x: float, y: float, w: float, h: float, u0: float, v0: float, u1: float, v1: float)
    local wh = w / 2.0f
    local hh = h / 2.0f
    qb_add(qb, x - wh, y - hh, x + wh, y + hh, u0, v0, u1, v1)
end


fn create_shader(vert_src: String, frag_src: String): gl.Program
    let vert = gl.create_shader(gl.VERTEX_SHADER)
    let frag = gl.create_shader(gl.FRAGMENT_SHADER)
    let shader = gl.create_program()
    check_error("create programs", true)

    gl.shader_source(vert, vert_src)
    check_error("shader vert source", true)
    gl.compile_shader(vert)
    check_error("shader vert compile", true)
    shader_log(vert)

    gl.shader_source(frag, frag_src)
    check_error("shader frag source", true)
    gl.compile_shader(frag)
    check_error("shader frag compile", true)
    shader_log(frag)

    gl.attach_shader(shader, vert)
    check_error("shader attach vert", true)
    gl.attach_shader(shader, frag)
    check_error("shader attach frag", true)

    gl.link_program(shader)
    check_error("shader link", true)
    program_log(shader)

    return shader
end


-- ugly LUT
local lut_u: [float] = [16*16:float]
local lut_v: [float] = [16*16:float]
fn create_lut()
    local delta = 16.0f / 256.0f

    local u = 0.0f
    local v = 0.0f

    for y=0, 16 do
        for x=0, 16 do
            lut_u[y*16+x] = u
            lut_v[y*16+x] = v
            u = u + delta
        end

        u = 0.0f
        v = v + delta
    end
end


fn qb_text(qb: QuadBatch, start_x: float, start_y: float, txt: String, char_w: float, spacing: float)
    local delta = 16.0f / 256.0f
    local i = 0
    local x = start_x
    while txt.byte_at(i) ~= 0u8 do
        local u0 = lut_u[txt.byte_at(i)]
        local v0 = lut_v[txt.byte_at(i)]
        local u1 = u0 + delta
        local v1 = v0 + delta

        qb_add_centered(qb, x, start_y, char_w, char_w, u0, v1, u1, v0)

        i = i + 1
        x = x + spacing
    end
end


fn qb_text_slam(qb: QuadBatch, start_x: float, start_y: float, txt: String, char_w: float, spacing: float, where2: float)
    local delta = 16.0f / 256.0f
    local i = 0
    local x = start_x
    while txt.byte_at(i) ~= 0u8 do
        local u0 = lut_u[txt.byte_at(i)]
        local v0 = lut_v[txt.byte_at(i)]
        local u1 = u0 + delta
        local v1 = v0 + delta

        local p = where2 - i as float;
        local size = 1.0f
        if (p < -1.0f) then
            size = 0.0f
        else
            size = 4.0f - 6.0f*p*p;
            if p < 0.0f and size < 0.0f then
                size = 0.0f
            end
            if p > 0.0f and (size < 1.0f) then
                size = 1.0f
            end
        end

        qb_add_centered(qb, x, start_y, char_w*size, char_w*size, u0, v1, u1, v0)

        i = i + 1
        x = x + spacing
    end

end

--------------------------------------------------------------
-- particle meshes????
local MAX_PARTICLE_COUNT: int = 1024 * 2
struct Particle
    local pos: @vector.Vector3
    local vel: @vector.Vector3
    local target: @vector.Vector3
    local speed: float
end

local PARTICLE_MODE_STATIC: int = 0
local PARTICLE_MODE_FOLLOW: int = 1
local PARTICLE_MODE_EXPLODE: int = 2

local PARTICLE_FIGURE_CUBE: int = 0
local PARTICLE_FIGURE_SPHERE: int = 1
local PARTICLE_FIGURE_PLUSBOX: int = 2
local PARTICLE_FIGURE_PYRAMID: int = 3

struct ParticleSystem
    mode: int
    next_mode: int
    figure: int
    particle_buf: [@Particle]
    cool_down: float
end


local test_psys: ParticleSystem = ParticleSystem {
    next_mode = PARTICLE_MODE_STATIC,
    mode = PARTICLE_MODE_STATIC,
    figure = PARTICLE_FIGURE_CUBE,
    cool_down = 0.0f }


fn init_meshy_cube()
    test_psys.particle_buf = [MAX_PARTICLE_COUNT: @Particle]

    for particle in test_psys.particle_buf do
        let a = random() * 3.14f * 2.0f
        particle.pos.x = math.cos(a) * 2048.0f
        particle.pos.y = math.sin(a) * 1048.0f + 1100.0f
        particle.pos.z = 2000.0f
        particle.speed = (random() * 0.6f + 0.4f) * 0.6f
    end
end


fn gen_points_from_line(v0: vector.Vector3, v1: vector.Vector3, points_per_line: int, ps: ParticleSystem, fill_start: int)
    let vec = vector.vec3(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z)  -- TODO vector subtraction
    let step = vector.vec3(vec.x / points_per_line as float,
                             vec.y / points_per_line as float,
                             vec.z / points_per_line as float)

    local d = 0.0f
    for i=fill_start, fill_start + points_per_line do
        ps.particle_buf[i].target = vector.vec3(v0.x + step.x * d,
                                                v0.y + step.y * d,
                                                v0.z + step.z * d)
        d = d + 1.0f
    end
end


fn gen_square_points(x: float, y: float, w: float, h: float, ps: ParticleSystem, point_count: int)
    let wh = w / 2.0f
    let hh = h / 2.0f

    -- calc number of lines
    let lines = 4
    let points_per_line = point_count as float / lines as float

    -- verts
    let v0 = vector.vec3(x - wh, y - hh, y - hh)
    let v1 = vector.vec3(y - hh, y - hh, y - hh)
    let v2 = vector.vec3(x + wh, y + hh, 0.0f)
    let v3 = vector.vec3(x - wh, y + hh, 0.0f)

    -- vectors
    local ppl_i = points_per_line as int
    gen_points_from_line(v0, v1, ppl_i, ps, ppl_i*0)
    gen_points_from_line(v1, v2, ppl_i, ps, ppl_i*1)
    gen_points_from_line(v2, v3, ppl_i, ps, ppl_i*2)
    gen_points_from_line(v3, v0, ppl_i, ps, ppl_i*3)
end


fn gen_pyramid_particles(x: float, y: float, z: float, w: float, h: float, d: float, ps: ParticleSystem, mtx: matrix.Matrix)
    let wh = w / 2.0f
    let hh = h / 2.0f
    let dh = d / 2.0f

    -- verts
    let v0 = matrix.multiply(mtx, vector.vec4(-wh, -hh, dh, 1.0f))
    let v1 = matrix.multiply(mtx, vector.vec4(wh, -hh, dh, 1.0f))
    let v2 = matrix.multiply(mtx, vector.vec4(wh, -hh, -dh, 1.0f))
    let v3 = matrix.multiply(mtx, vector.vec4(-wh, -hh, -dh, 1.0f))
    let v4 = matrix.multiply(mtx, vector.vec4(0.0f, hh, 0.0f, 1.0f))

    let v0 = vector.vec3(v0.x + x, v0.y + y, v0.z + z)
    let v1 = vector.vec3(v1.x + x, v1.y + y, v1.z + z)
    let v2 = vector.vec3(v2.x + x, v2.y + y, v2.z + z)
    let v3 = vector.vec3(v3.x + x, v3.y + y, v3.z + z)
    let v4 = vector.vec3(v4.x + x, v4.y + y, v4.z + z)

    let lines = 8
    let points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    let ppl_i = points_per_line as int
    gen_points_from_line(v0, v1, ppl_i, ps, ppl_i*0)
    gen_points_from_line(v1, v2, ppl_i, ps, ppl_i*1)
    gen_points_from_line(v2, v3, ppl_i, ps, ppl_i*2)
    gen_points_from_line(v3, v0, ppl_i, ps, ppl_i*3)

    gen_points_from_line(v0, v4, ppl_i, ps, ppl_i*4)
    gen_points_from_line(v1, v4, ppl_i, ps, ppl_i*5)
    gen_points_from_line(v2, v4, ppl_i, ps, ppl_i*6)
    gen_points_from_line(v3, v4, MAX_PARTICLE_COUNT - ppl_i*7, ps, ppl_i*7)
end


fn gen_cube_particles(x: float, y: float, z: float, w: float, h: float, d: float, ps: ParticleSystem, mtx: matrix.Matrix)
    let wh = w / 2.0f
    let hh = h / 2.0f
    let dh = d / 2.0f

    -- verts
    let v0 = matrix.multiply(mtx, vector.vec4(-wh, -hh, dh, 1.0f))
    let v1 = matrix.multiply(mtx, vector.vec4(wh, -hh, dh, 1.0f))
    let v2 = matrix.multiply(mtx, vector.vec4(wh, hh, dh, 1.0f))
    let v3 = matrix.multiply(mtx, vector.vec4(-wh, hh, dh, 1.0f))
    let v4 = matrix.multiply(mtx, vector.vec4(-wh, -hh, -dh, 1.0f))
    let v5 = matrix.multiply(mtx, vector.vec4(wh, -hh, -dh, 1.0f))
    let v6 = matrix.multiply(mtx, vector.vec4(wh, hh, -dh, 1.0f))
    let v7 = matrix.multiply(mtx, vector.vec4(-wh, hh, -dh, 1.0f))

    let v0 = vector.vec3(v0.x + x, v0.y + y, v0.z + z)
    let v1 = vector.vec3(v1.x + x, v1.y + y, v1.z + z)
    let v2 = vector.vec3(v2.x + x, v2.y + y, v2.z + z)
    let v3 = vector.vec3(v3.x + x, v3.y + y, v3.z + z)
    let v4 = vector.vec3(v4.x + x, v4.y + y, v4.z + z)
    let v5 = vector.vec3(v5.x + x, v5.y + y, v5.z + z)
    let v6 = vector.vec3(v6.x + x, v6.y + y, v6.z + z)
    let v7 = vector.vec3(v7.x + x, v7.y + y, v7.z + z)

    let lines = 12
    let points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    let ppl_i = points_per_line as int
    gen_points_from_line(v0, v1, ppl_i, ps, ppl_i*0)
    gen_points_from_line(v1, v2, ppl_i, ps, ppl_i*1)
    gen_points_from_line(v2, v3, ppl_i, ps, ppl_i*2)
    gen_points_from_line(v3, v0, ppl_i, ps, ppl_i*3)

    gen_points_from_line(v4, v5, ppl_i, ps, ppl_i*4)
    gen_points_from_line(v5, v6, ppl_i, ps, ppl_i*5)
    gen_points_from_line(v6, v7, ppl_i, ps, ppl_i*6)
    gen_points_from_line(v7, v4, ppl_i, ps, ppl_i*7)

    gen_points_from_line(v0, v4, ppl_i, ps, ppl_i*8)
    gen_points_from_line(v1, v5, ppl_i, ps, ppl_i*9)

    gen_points_from_line(v3, v7, ppl_i, ps, ppl_i*10)
    gen_points_from_line(v2, v6, MAX_PARTICLE_COUNT - ppl_i*11, ps, ppl_i*11)
end


fn gen_sphere_particles(x: float, y: float, z: float, w: float, h: float, d: float, ps: ParticleSystem, mtx: matrix.Matrix)
    let max_particle_count = MAX_PARTICLE_COUNT
    let dt = 3.1415f * 2.0f * 16.0f /  max_particle_count as float
    for i, particle in ps.particle_buf do
        let t = i as float * dt
        let s = math.sin(t)
        let c = math.cos(t)
        let ly = 1.0f - 2.0f* i as float / max_particle_count as float
        let w = math.sqrt(1.0f - ly*ly)

        let tmp = vector.vec4(s * 100.0f * w + x,
                                100.0f - 200.0f * i as float/max_particle_count as float + y,
                                c * 100.0f * w + z,
                                1.0f)
        let tmp2 = matrix.multiply(mtx, tmp)

        particle.target = tmp2.vec3()
    end
end


fn gen_plusbox_particles(ps: ParticleSystem, mtx: matrix.Matrix)
    local lines = 0
    local lp = 0
    let kq = 0
    local per = 0
    for p=0, 2 do
       if p == 1 then
          per = MAX_PARTICLE_COUNT / lines
       end
       for a=0, 3 do
          ------------
          for x=0, 4 do
             for y=0, 4 do
                for q=0, 3 do
                    local u = vector.vec4()
                    local v = vector.vec4()
                    if a == 0 then
                        u.x = x as float
                        u.y = y as float
                        u.z = q as float
                        v.x = x as float
                        v.y = y as float
                        v.z = (q + 1) as float
                    elseif a == 1 then
                        u.x = x as float
                        u.y = q as float
                        u.z = y as float
                        v.x = x as float
                        v.y = (q + 1) as float
                        v.z = y as float
                    elseif a == 2 then
                        u.x = q as float
                        u.y = x as float
                        u.z = y as float
                        v.x = (q + 1) as float
                        v.y = x as float
                        v.z = y as float
                    end
                    local corn = 0
                    if x == 0 and y == 0 then
                        corn = 1
                    elseif x == 3 and y == 0 then
                        corn = 1
                    elseif x == 3 and y == 3 then
                        corn = 1
                    elseif x == 0 and y == 3 then
                        corn = 1
                    end

                    if (q == 0 and corn == 0) or (q == 1 and corn == 1) or (q == 2 and corn == 0) then
                        if p == 0 then
                            lines = lines + 1
                        else
                            u.x = (u.x - 1.5f) * 50.0f
                            v.x = (v.x - 1.5f) * 50.0f
                            u.y = (u.y - 1.5f) * 50.0f
                            v.y = (v.y - 1.5f) * 50.0f
                            u.z = (u.z - 1.5f) * 50.0f
                            v.z = (v.z - 1.5f) * 50.0f
                            u.w = 1.0f
                            v.w = 1.0f
                            lines = lines - 1
                            if lines == 0 then
                                gen_points_from_line(matrix.multiply(mtx, u).vec3(), matrix.multiply(mtx, v).vec3(), MAX_PARTICLE_COUNT - lp, ps, lp)
                            else
                                gen_points_from_line(matrix.multiply(mtx, u).vec3(), matrix.multiply(mtx, v).vec3(), per, ps, lp)
                            end
                            lp = lp + per
                        end
                    end
                end
             end
          end
       end
    end
end


fn fux_particle_speed(ps: ParticleSystem)
    for particle in ps.particle_buf do
        particle.speed = (random() * 0.6f + 0.4f) * 0.6f
    end
end


fn update_meshy_cube(ps: ParticleSystem, qb: QuadBatch, delta: float)
    if ps.cool_down > 0.0f then
        ps.cool_down = ps.cool_down - delta
        if ps.cool_down <= 0.0f then
            ps.cool_down = 0.0f
            ps.mode = ps.next_mode
        end
    end

    -- update particles depending on mode
    if ps.mode == PARTICLE_MODE_STATIC then
        -- do nothing
    elseif ps.mode == PARTICLE_MODE_FOLLOW then
        for i=0, MAX_PARTICLE_COUNT do
            let particle = ps.particle_buf[i]
            let tv_x = particle.speed*delta*(particle.target.x - particle.pos.x)
            let tv_y = particle.speed*delta*(particle.target.y - particle.pos.y)
            let tv_z = particle.speed*delta*(particle.target.z - particle.pos.z)

            if (particle.speed < 0.6f) then
                particle.speed = particle.speed*1.008f
            end

            particle.pos.x = particle.pos.x + tv_x
            particle.pos.y = particle.pos.y + tv_y
            particle.pos.z = particle.pos.z + tv_z
        end

    elseif (ps.mode == PARTICLE_MODE_EXPLODE) then

        local g = -0.9f * 10.0f

        for particle in ps.particle_buf do
            particle.vel.y = particle.vel.y + g * delta
            particle.pos.x = particle.pos.x + particle.vel.x
            particle.pos.y = particle.pos.y + particle.vel.y
            particle.pos.z = particle.pos.z + particle.vel.z
        end
    end

    -- render!!!
    qb.start()
    for particle in ps.particle_buf do
        let pos_z = particle.pos.z
        let zzzz = vector.vec4(pos_z, pos_z, pos_z, pos_z)
        qb_add_3d(qb, particle.pos.x - 5f, particle.pos.y - 5f, particle.pos.x + 5.0f, particle.pos.y + 5.0f, 0.0f, 0.0f, 1.0f, 1.0f, zzzz)
    end
    qb.finish()
end


--------------------------------------------------------------
-- scenes??

let particle_amount: int = MAX_PARTICLE_COUNT
local particle_shader: gl.Program
local particle_qb: QuadBatch
local particle_loc_mtx: gl.Uniform


fn scene_particle_init()
    local vertex_src = read_file_as_string("data/shaders/particle_3d.vp")
    local fragment_src = read_file_as_string("data/shaders/particle.fp")

    particle_shader = create_shader(vertex_src, fragment_src)
    check_error("(particle) create shader", false)
    particle_loc_mtx = gl.get_uniform_location(particle_shader, "mtx")
    check_error("(particle) getting locations", false)

    particle_qb = create_quad_batch(particle_amount)

    init_meshy_cube()
end


fn scene_particle_draw(window: glfw.Window, mtx: matrix.Matrix, delta: float)
    let width, height = window.get_framebuffer_size()

    local deltaf = delta

    gl.disable(gl.DEPTH_TEST)
    gl.enable(gl.BLEND)
    gl.blend_func(gl.GL_ONE, gl.GL_ONE)

    update_meshy_cube(test_psys, particle_qb, delta)

    gl.use_program(particle_shader)
    gl.uniform_matrix4fv(particle_loc_mtx, 1, true, mtx)
    particle_qb.render()
end


fn loop_begin(): bool
    return not window.window_should_close()
end


fn loop_end()
    window.swap_buffers()
    glfw.poll_events()
end

let floorsize: int = 256

struct HF
    heights: @[float: 65536]
end

let floordata: [@HF] = [2: @HF]
local music_channel: fmod.Channel

fn gen_floor(qb: QuadBatch, gridsize: int)
    qb.start();
    local uvs = 1.0f / gridsize as float
    for u=0, gridsize-1 do
        local x:float = u as float - 0.5f * gridsize as float
        for v=0, gridsize-1 do
            local y:float = v as float - 0.5f * gridsize as float
            qb_add(qb, x, y, x + 1.0f, y + 1.0f, uvs*u as float, uvs*v as float, uvs*(u+1) as float, uvs*(v+1) as float)
        end
    end
    qb.finish()
end


fn floor_sim(src: int, dst: int)
    let c2 = 30.0f

    let s = floordata[src].heights
    let d = floordata[dst].heights

    local dt = 0.12f

    for u=1, floorsize-1 do
        for v=1, floorsize-1 do
            let idx = 256 * u + v;
            let f = c2 * (s[idx-1] + s[idx+1] + s[idx-floorsize] + s[idx+floorsize] - 4.0f * s[idx]);
            let vel = (s[idx] - d[idx])/dt + f * dt;
            d[idx] = 0.98f * (s[idx] + vel * dt);
        end
    end
end


fn run_floor()
    scene_particle_init()

    let width, height = window.get_framebuffer_size()
    let widthf = width as float
    let heightf = height as float

    let fb = create_quad_batch(1024*1024)

    -- logo texture
    local logo_data = read_file("data/textures/defold_logo.raw")
    local logo_tex = create_texture(1280, 447, logo_data)
    local logo_qb = create_quad_batch(12)

    let vertex_src = read_file_as_string("data/shaders/floor.vp")
    let fragment_src = read_file_as_string("data/shaders/floor.fp")
    local floor_shader = create_shader(vertex_src, fragment_src);
    check_error("(floor) create shader", false);

    -- voxel
    let vertex_src  = read_file_as_string("data/shaders/voxel.vp")
    let fragment_src  = read_file_as_string("data/shaders/voxel.fp")
    let voxel_shader = create_shader(vertex_src, fragment_src)
    let voxel_qb = create_quad_batch(1024*1024);

    --- text
    let vertex_src  = read_file_as_string("data/shaders/shader.vp")
    let fragment_src  = read_file_as_string("data/shaders/shader.fp")
    let text_shader = create_shader(vertex_src, fragment_src)
    check_error("(text) create shader", false)
    let text_qb = create_quad_batch(1024)
    let text_shader = create_shader(vertex_src, fragment_src)
    check_error("(particle) create shader", false)

    local loc_mtx = gl.get_uniform_location(floor_shader, "mtx")
    check_error("(particle) getting locations", false)
    local water_fade = gl.get_uniform_location(floor_shader, "waterFade");
    local logo_fade = gl.get_uniform_location(floor_shader, "logoFade");
    local water_time = gl.get_uniform_location(floor_shader, "waterTime");

    local t = 0.0f

    let tex0_data = read_file("data/textures/consolefont.raw")
    let tex0 = create_texture(256, 256, tex0_data)

    -- FBO stuff
    let vertex_src  = read_file_as_string("data/shaders/screen.vp")
    let fragment_src  = read_file_as_string("data/shaders/screen.fp")
    let screen_shader = create_shader(vertex_src, fragment_src)

    let htex = gl.gen_texture()
    gl.bind_texture(gl.GL_TEXTURE_2D, htex)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)

    gen_floor(fb, 512)

    local cur = 1
    local anim = 0.0f

    local last_time_stamp = glfw.get_time()
    local frame_counter = 0
    local last_fps_ts = last_time_stamp
    local start_time = last_time_stamp
    local to_water:float = 0.0f
    local water_t:float = 0.0f

    local to_logo:float = 0.0f
    local logo_t:float = 0.0f

    local psyk_t:float = 0.0f
    local next_switch = 0u64

    let texdata = [65536: float]


    while loop_begin() do
        let width, height = window.get_framebuffer_size()
        let widthf = width as float
        let heightf = height as float

        local delta = (glfw.get_time() - last_time_stamp) as float
        last_time_stamp = glfw.get_time()

        if last_time_stamp - last_fps_ts >= 1.0 then
            let elapsed = last_time_stamp - last_fps_ts
            last_fps_ts = last_time_stamp
            io.println("FPS: " .. (frame_counter as double / elapsed))
            frame_counter = 0
        end

        let tm = music_channel.get_position(1u64)

        if tm > 12000u64 then
           to_water = to_water + (1.0f - to_water) * 3.0f * delta
           if to_water > 1.0f then
              to_water = 1.0f
           end
        end

        if tm > 42000u64 then
           to_logo = to_logo + (1.0f - to_logo) * 3.0f * delta
           if to_logo > 1.0f then
              to_logo = 1.0f
           end
        end

        if tm > 25500u64 then
           if psyk_t == 0.0f then
              next_switch = 0u64
           end
           psyk_t = psyk_t + delta
        end

        if t > 50.0f then
            break
        end

        local do_switch = 0
        if tm > next_switch and math.cos(psyk_t*3.0f) > 0.8f then
            if psyk_t > 0.0f then
                next_switch = tm + 6000u64
            else
                next_switch = tm + 3000u64
            end
            do_switch = 1
        end

        water_t = to_water * delta + water_t
        logo_t = to_logo * delta + logo_t

        gl.viewport(0, 0, width, height)
        gl.clear_color(0.0f, 0.0f, 0.0f, 1.0f)
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
        gl.disable(gl.BLEND)
        gl.enable(gl.DEPTH_TEST)
        gl.disable(gl.CULL_FACE)

        local dolly = logo_t * 0.9f
        if dolly > 1.0f then
            dolly = 1.0f
        end

        local fov = 2.0f - 1.8f * dolly
        local dolly_dist = (2000f-250f) * dolly
        local elevate = 100.0f * dolly
        local persp = matrix.persp(-0.8f * fov, 0.8f * fov, -0.6f * fov, 0.6f * fov, 1.0f + dolly_dist, 700.0f + dolly_dist)
        local camera = matrix.multiply(persp, matrix.trans(0.0f, -elevate -50.0f + (1f-to_logo)*math.sin(t*0.2f)*10.0f, -250.0f - dolly_dist))

        gl.use_program(floor_shader)
        gl.uniform_matrix4fv(loc_mtx, 1, true, camera)

        -- convert & scale heights
        for k=0, 65536 do
           texdata[k] = 0.001f * floordata[cur].heights[k]
        end

        gl.bind_texture(gl.GL_TEXTURE_2D, htex)
        gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_R32F, 0, 0, 0, gl.GL_RED, gl.FLOAT, texdata)
        gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_R32F, floorsize, floorsize, 0, gl.GL_RED, gl.FLOAT, texdata)
        gl.uniform1f(water_fade, to_water)
        gl.uniform1f(logo_fade, to_logo)
        gl.uniform1f(water_time, water_t)

        fb.render()
        floor_sim(cur, 1 - cur)
        cur = 1 - cur

        -- particles
        local imtx = matrix.ident();
        local rot_mtx = imtx.rotate_X(t*1.1f);
        rot_mtx = rot_mtx.rotate_Z((t*0.7f))

        local move = psyk_t
        if move > 1.0f then
           move = 1.0f;
        end

        local dip_mtx = matrix.trans(math.sin(psyk_t) * move * 200.0f, math.cos(psyk_t*3.0f) * 200.0f - 50.0f, math.cos(psyk_t*0.74f) * move * 200.0f)
        rot_mtx = matrix.multiply(dip_mtx, rot_mtx)

        local for_logo = matrix.multiply(
            matrix.multiply(
                matrix.trans(0f, 1.4f * elevate + 50.0f, 0f),
                matrix.multiply(matrix.ident().rotate_X(-0.25f*3.1415f), matrix.ident().rotate_Y(0.25f*3.1415f))),
            matrix.ident().rotate_Z(0.0f));
        rot_mtx = matrix.interp(rot_mtx, for_logo, to_logo)

        if logo_t > 0.0f then
            test_psys.figure = PARTICLE_FIGURE_PLUSBOX
            do_switch = 0
            if logo_t > 1.3f and logo_t < 10.0f then
                -- final destruction
                logo_t = 100.0f
                test_psys.mode = PARTICLE_MODE_FOLLOW
                do_switch = 1
                next_switch = 300000000000u64
            end
        end

        if water_t > 0.0f then
            if test_psys.mode == PARTICLE_MODE_STATIC then
                test_psys.mode = PARTICLE_MODE_FOLLOW
            end

            if test_psys.figure == PARTICLE_FIGURE_CUBE then
                gen_cube_particles(0.0f, 0.0f, 10.0f, 100.0f, 100.0f, 100.0f, test_psys, rot_mtx)
            elseif test_psys.figure == PARTICLE_FIGURE_SPHERE then
                gen_sphere_particles(0.0f, 0.0f, 10.0f, 80.0f, 80.0f, 80.0f, test_psys, rot_mtx)
            elseif test_psys.figure == PARTICLE_FIGURE_PYRAMID then
                gen_pyramid_particles(0.0f, 0.0f, 10.0f, 100.0f, 100.0f, 100.0f, test_psys, rot_mtx)
            else
                gen_plusbox_particles(test_psys, rot_mtx)
            end

            if do_switch == 1 then
                if test_psys.figure == PARTICLE_FIGURE_CUBE then
                    test_psys.figure = PARTICLE_FIGURE_SPHERE
                elseif test_psys.figure == PARTICLE_FIGURE_SPHERE then
                    test_psys.figure = PARTICLE_FIGURE_PYRAMID
                else
                    test_psys.figure = PARTICLE_FIGURE_CUBE
                end

                fux_particle_speed(test_psys)
            end

            if do_switch == 1 and psyk_t > 0.0f and test_psys.mode == PARTICLE_MODE_FOLLOW then
                test_psys.mode = PARTICLE_MODE_EXPLODE
                test_psys.cool_down = 3.0f
                test_psys.next_mode = PARTICLE_MODE_FOLLOW

                local amp = 30.0f
                for particle in test_psys.particle_buf do
                    local a1 = random() * 3.14f * 2.0f
                    local a2 = random() * 3.14f * 2.0f

                    let vel = particle.vel
                    vel.x = math.sin(a1) * amp
                    vel.y = math.cos(a1) * amp
                    vel.z = math.sin(a2) * amp
                end
            end
        end

        if logo_t > 1.0f then
            test_psys.cool_down = 10000.0f
        end

        gl.use_program(voxel_shader);
        gl.uniform_matrix4fv(
            gl.get_uniform_location(voxel_shader, "mtx"),
            1,
            true,
            matrix.multiply(camera,
                            matrix.multiply(rot_mtx,
                                            matrix.multiply(matrix.scale(0.75f,0.75f,0.75f),
                                                            matrix.scale(13.3f,13.3f,13.3f)))))

        voxel_qb.start()
        qb_write_plusbox(voxel_qb, logo_t - 0.3f)
        voxel_qb.finish()
        voxel_qb.render()

        gl.use_program(particle_shader)
        scene_particle_draw(window, camera, 0.1f)

        if window.get_mouse_button(0) == 1 then
            test_psys.mode = PARTICLE_MODE_STATIC
        end

        local px = (math.sin(2.0f*t)*64.0f) as int + 128
        local py = (math.cos(3.0f*t)*64.0f) as int + 128

        for particle in test_psys.particle_buf do
            let pos = particle.pos;
            if pos.y < 0.0f and pos.y > -5.0f then
                let x = (pos.x + 256.0f) * 0.5f;
                let y = pos.y
                let z = (pos.z + 256.0f) * 0.5f;

                let PX = x as int
                let PY = z as int
                if PX > 0 and PX < 255 and PY > 0 and PY < 255 then
                    floordata[cur].heights[PY*256+PX] = -15.0f;
                end
            end
        end

        ----- TEXt
        gl.disable(gl.DEPTH_TEST);

        local ortho_mtx = matrix.ortho(0.0f, 800.0f, 0.0f, 600.0f, 0.0f, 1.0f)
        local location_mtx = gl.get_uniform_location(text_shader, "mtx")
        local location_anim = gl.get_uniform_location(text_shader, "anim")
        local location_offset = gl.get_uniform_location(text_shader, "offset")
        local location_mode = gl.get_uniform_location(text_shader, "mode")
        check_error("getting locations", false)

        gl.enable(gl.BLEND)
        gl.blend_func(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
        gl.use_program(text_shader)
        gl.uniform_matrix4fv(location_mtx, 1, true, ortho_mtx)
        gl.uniform1f(location_anim, t);
        gl.uniform1f(location_offset, t);
        gl.uniform1i(location_mode, 3);
        gl.bind_texture(gl.GL_TEXTURE_2D, tex0);

        text_qb.start();

        local pandown = (t - 10.0f);
        if pandown < 0.0f then
            pandown = 0.0f
        end
        pandown = pandown * pandown * 500.0f;

        local t1 = 4.0f * t;
        qb_text_slam(text_qb, 75.0f, 500.0f + pandown, "DEFOLD CREW", 128.0f, 64.0f, t1)

        local t2 = 4.0f * (t - 3.5f)
        qb_text_slam(text_qb, 280.0f - pandown, 400.0f, "PRESENTS", 64.0f, 32.0f, t2)

        local t3 = 4.0f * (t - 7.0f)
        qb_text_slam(text_qb, 100.0f, 200.0f - pandown, "SOL HAX", 200.0f, 100.0f, t3)

        text_qb.finish()
        text_qb.render();

        t = t + delta

        -- render logo
        if logo_t > 100.0f then
            gl.use_program(screen_shader)
            gl.bind_texture(gl.GL_TEXTURE_2D, logo_tex)
            location_mtx = gl.get_uniform_location(screen_shader, "mtx")
            gl.uniform_matrix4fv(location_mtx, 1, true, ortho_mtx);
            local logo_scale = 0.3f
            logo_qb.start()
            qb_add_centered(logo_qb, 400.0f, 100.0f, 1280.0f * logo_scale, 447.0f * logo_scale, 0.0f, 1.0f, 1.0f, 0.0f)
            logo_qb.finish()
            logo_qb.render()
        end

        loop_end()

        frame_counter += 1
    end
end


fn init_audio(): fmod.System
    let sys_create_res = fmod.system_create()
    if sys_create_res.0 ~= fmod.OK then
        panic("could not create FMOD system")
    end
    let fmod_system = sys_create_res.1

    if fmod_system.init(32, 0u64, 0u64) ~= fmod.OK then
        panic("could not initialize FMOD")
    end

    log_ok("FMOD initiated")

    return fmod_system
end


fn load_sound(fmod_system: fmod.System, path: String): fmod.Sound
    local sound_result = fmod_system.create_sound(path, 0x40u64, 0u64)

    if sound_result.0 ~= fmod.OK then
        panic("could not create sound: " .. path)
    end

    return sound_result.1
end


fn play_sound(fmod_system: fmod.System, fmod_sound: fmod.Sound): fmod.Channel
    local play_res = fmod_system.play_sound(-1, fmod_sound, false)
    if play_res.0 ~= fmod.OK then
        panic("could not play sound")
    end
    return play_res.1
end
