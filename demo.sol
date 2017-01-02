module demo

require io
require math
require rnd

require glfw
require gl
require fmod

require matrix
require vector

let rng: rnd.MT19937 = rnd.MT19937{}

!main
function main(args:[String]): int
    rng.seed(0u32)
    create_lut()

    if glfw.init() == 0 then
        return -1
    end

    -- get a ogl >= 3.2 context on OSX
    -- lets us use layout(location = x)
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3u32)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 2u32)
    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, gl.GL_TRUE)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    window = glfw.create_window(800, 600, "sol", 0u64, 0u64)
    window.make_context_current()

    if window.is_valid() then
        window.show()

        -- init audio and load sound
        local sound_system = init_audio()
        local drum_sound = load_sound(sound_system, "data/music/skadad.mp3")
        music_channel = play_sound(sound_system, drum_sound)

        local vertex_src : String = read_file_as_string("data/shaders/shader.vp")
        -- io.println("vertex_src: " .. vertex_src)
        local fragment_src : String = read_file_as_string("data/shaders/shader.fp")
        -- io.println("fragment_src: " .. fragment_src)

        local shader = create_shader(vertex_src, fragment_src)
        local quad = create_quad()
        local qb : QuadBatch = create_quad_batch(1024)
        qb_begin(qb)
        qb_text(qb, 0.0f, 220.0f, line1, 16.0f, 12.0f)
        qb_text(qb, 100.0f, 160.0f, line2, 32.0f, 24.0f)
        qb_text(qb, 0.0f, 80.0f, line1, 16.0f, 12.0f)
        qb_end(qb)

        local alt_text : QuadBatch = create_quad_batch(1024)
        qb_begin(alt_text)
        qb_text(alt_text, 160.0f-16.0f*5.5f , 5.0f, "DEFOLD CREW", 32.0f, 16.0f)
        qb_end(alt_text)

        -- setup()
        local tex0_data : [byte] = read_file("data/textures/consolefont.raw")
        local tex0 = create_texture(256, 256, tex0_data)

        local anim = 0.0f
        local last_time_stamp = glfw.get_time()

        -- init scenes
        -- scene_particle_init()
        -- run_particle_test()
        run_floor()
    else
        io.println("could not create window!")
    end

    -- release scenes
    glfw.terminate()
    io.println("glfw terminated!")

    return 0
end


------------------------------------------------------------------
-- Structs

struct Wrap<T>
    local value: T
end

struct QuadBatch
    local vert_buf : [float]
    local uv_buf   : [float]
    local capacity : int
    local cursor   : int

    -- gl stuff
    local vert_gl : uint32
    local uv_gl   : uint32
    local vao     : uint32
end


------------------------------------------------------------------
-- External APIs

-- C Std funcs
!nogc extern fopen(filename: String, mode: String) : uint64
!nogc extern fseek(stream : uint64, offset : int64, whence : int) : int
!nogc extern ftell(stream : uint64): int
!nogc extern fclose(stream : uint64): int
!nogc extern fread(ptr : [byte], size : int, count : int, stream : uint64): int64
!nogc extern chdir(path : String): int


-----------------------------------------------------------------------
-- Defines/enums

local SEEK_SET            : int = 0
local SEEK_CUR            : int = 1
local SEEK_END            : int = 2

local RAND_MAX            : int = 2147483647

--
local window: glfw.Window


------------------------------------------------------------------------
-- Helpers
function error_lut(id : uint32) : String
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

function log_error(id : String)
    io.println("[ \x1B[31m!!\x1B[0m ] " .. id)
end

function log_ok(id : String)
    io.println("[ \x1B[32mok\x1B[0m ] " .. id)
end

function random() : float
    return rng.next_float()
end

function check_error(id : String, print_on_ok : bool) : bool
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

function shader_log(obj : uint32)
    local size:[int] = [200:int]
    if gl.is_shader(obj) then
        gl.get_shaderiv(obj, gl.GL_INFO_LOG_LENGTH, size)
    else
        gl.get_programiv(obj, gl.GL_INFO_LOG_LENGTH, size)
    end
    if size[0] == 0 then
        return
    end

    local sub_sizes:[int] = [1:int]
    local data:[byte] = [size[0]:byte]
    if gl.is_shader(obj) then
        gl.get_shader_info_log(obj, size[0], sub_sizes, data)
    else
        gl.get_program_info_log(obj, size[0], sub_sizes, data)
    end

    io.println("Shader log:\n" .. string(data))
end

function read_file(file_path : String) : [byte]
    local f = fopen(file_path, "r")

    if (f ~= 0u64) then
        fseek(f, 0i64, SEEK_END)
        local len : int = ftell(f) + 1
        local ret : [byte] = [len:byte]
        fseek(f, 0i64, SEEK_SET)
        -- FIXME make sure we read the whole file...
        fread(ret, 1, len, f)
        fclose(f);

        -- make sure we null term
        ret[len-1] = 0u8

        log_ok("read " .. file_path)

        return ret
    else
        log_error("could not open " .. file_path)
    end

    local ret : [byte]
    return ret
end

function read_file_as_string(file_path : String) : String
    return string(read_file(file_path))
end

------------------------------------------------------------------------
-- "Resources"
function create_texture(width : int, height : int, data : [byte]) : uint32
    let texture = gl.gen_texture()
    check_error("creating texture", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, texture)
    check_error("bound texture", false)

    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)

    gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, data)
    check_error("uploaded texture data", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, 0u32)
    check_error("unbound texture", false)

    return texture
end


function create_empty_texture(width : int, height : int) : uint32
    let texture = gl.gen_texture()
    check_error("creating empty texture", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, texture)
    check_error("bind texture", true)

    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)

    gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGBA, width, height, 0, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, 0u32)
    check_error("upload empty texture", true)

    gl.bind_texture(gl.GL_TEXTURE_2D, 0u32)
    check_error("unbound texture", true)

    return texture
end


function create_fbo(width : int, height : int, attach_depth : bool) : uint32, uint32
    io.print(width)
    io.print(height)

    local framebuffers : [uint32] = [1:uint32]
    gl.gen_framebuffers(1, framebuffers)
    check_error("creating fbo", true)

    local fbo : uint32 = framebuffers[0]
    gl.bind_framebuffer(gl.GL_FRAMEBUFFER, fbo)

    -- gen empty texture
    local texture = create_empty_texture(width, height)

    let depthbuffer = gl.gen_renderbuffer()
    check_error("creating depth buffer", true)
    gl.bind_renderbuffer(gl.GL_RENDERBUFFER, depthbuffer)
    gl.renderbuffer_storage(gl.GL_RENDERBUFFER, gl.GL_DEPTH_COMPONENT, width, height)
    check_error("binding depth buffer", true)
    gl.framebuffer_renderbuffer(gl.GL_FRAMEBUFFER, gl.GL_DEPTH_ATTACHMENT, gl.GL_RENDERBUFFER, depthbuffer)
    check_error("binding texture", true)
    gl.framebuffer_texture(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, texture, 0);

    local fbo_status : uint32 = gl.check_framebuffer_status(gl.GL_FRAMEBUFFER)
    if (fbo_status ~= gl.GL_FRAMEBUFFER_COMPLETE) then
        log_error("fbo is not complete!")
    else
        log_ok("fbo is complete")
    end
    gl.bind_framebuffer(gl.GL_FRAMEBUFFER, 0u32)

    return fbo, texture
end


function render_to_fbo(fbo : uint32)
    gl.bind_framebuffer(gl.GL_FRAMEBUFFER, fbo)
    check_error("binding fbo", false)

    if (fbo ~= 0u32) then
        gl.draw_buffer(gl.GL_COLOR_ATTACHMENT0)
        check_error("drawing to fbo", false)
    end
end


function create_quad_batch(capacity : int) : QuadBatch
    let qb = QuadBatch { vert_gl  = 0u32,
                           uv_gl    = 0u32,
                           vert_buf = [capacity*3*6: float],
                           uv_buf   = [capacity*2*6: float],
                           capacity = capacity,
                           cursor   = 0 }

    -- generate gl buffers
    qb.vert_gl = gl.gen_buffer()
    qb.uv_gl = gl.gen_buffer()

    qb.vao = gl.gen_vertex_array()

    gl.bind_vertex_array(qb.vao)
    gl.enable_vertex_attrib_array(0)
    gl.bind_buffer(gl.GL_ARRAY_BUFFER, qb.vert_gl)
    gl.vertex_attrib_pointer(0u32, 3, gl.GL_FLOAT, false, 0, 0)
    gl.bind_vertex_array(0u32)

    return qb
end

function qb_begin(qb : QuadBatch)
    qb.cursor = 0
end

function qb_end(qb : QuadBatch)
    local i : int = qb.cursor*3*6

    gl.bind_vertex_array(qb.vao)

    gl.enable_vertex_attrib_array(0)
    gl.bind_buffer(gl.GL_ARRAY_BUFFER, qb.vert_gl)
    check_error("qb_render: binding vert buffer", false)
    gl.buffer_data(gl.GL_ARRAY_BUFFER, i*4, qb.vert_buf, gl.GL_STATIC_DRAW)
    check_error("qb_render: upload vert buffer", false)
    gl.vertex_attrib_pointer(0u32, 3, gl.GL_FLOAT, false, 0, 0)

    gl.enable_vertex_attrib_array(1)
    gl.bind_buffer(gl.GL_ARRAY_BUFFER, qb.uv_gl)
    check_error("qb_render: binding uv buffer", false)
    gl.buffer_data(gl.GL_ARRAY_BUFFER, i*4, qb.uv_buf, gl.GL_STATIC_DRAW)
    check_error("qb_render: upload uv buffer", false)
    gl.vertex_attrib_pointer(1u32, 2, gl.GL_FLOAT, false, 0, 0)

    gl.bind_vertex_array(0u32)
end


function qb_render(qb : QuadBatch)
    gl.bind_vertex_array(qb.vao)
    gl.draw_arrays(gl.GL_TRIANGLES, 0u32, qb.cursor*6);
end


function qb_add(qb : QuadBatch, x0 : float, y0 : float, x1 : float, y1 : float, u0 : float, v0 : float, u1 : float, v1 : float)
--    d - c
--    | / |
--    a - b

    local i : int = qb.cursor*3*6 -- (x,y) * vert_count * triangle_count_per_quad

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

    i = qb.cursor * 2 * 6
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


function qb_write(qb : QuadBatch, where_pos:int, x : float, y : float, z : float)
    qb.vert_buf[where_pos + 0] = x
    qb.vert_buf[where_pos + 1] = y
    qb.vert_buf[where_pos + 2] = z
end


function qb_write_cube_side(qb : QuadBatch, where_pos:int, where_uv:int, x:float, y:float, z:float, ux:float, uy:float, uz:float, vx:float, vy:float, vz:float, u:float, v:float)
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

function qb_write_cube(qb : QuadBatch, x:float, y:float, z:float)
    local szf = 0.50f
    qb_write_cube_side(qb, 3*6*(qb.cursor+0), 2*6*(qb.cursor+0), x + 0.0f, y + 0.0f, z - szf, szf, 0.0f, 0.0f, 0.0f, szf, 0.0f, 1f, 0f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+1), 2*6*(qb.cursor+1), x + 0.0f, y + 0.0f, z + szf,-szf, 0.0f, 0.0f, 0.0f,-szf, 0.0f, 1f, 0f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+2), 2*6*(qb.cursor+2), x + szf, y + 0.0f, z + 0.0f, 0.0f, 0.0f, szf, 0.0f, szf, 0.0f, 0f, 1f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+3), 2*6*(qb.cursor+3), x - szf, y + 0.0f, z + 0.0f, 0.0f, 0.0f,-szf, 0.0f, szf, 0.0f, 0f, 1f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+4), 2*6*(qb.cursor+4), x + 0.0f, y + szf, z + 0.0f, szf, 0.0f, 0.0f, 0.0f, 0.0f, szf, 0f, 0f)
    qb_write_cube_side(qb, 3*6*(qb.cursor+5), 2*6*(qb.cursor+5), x + 0.0f, y - szf, z + 0.0f,-szf, 0.0f, 0.0f, 0.0f, 0.0f,-szf, 0f, 0f)
    qb.cursor = qb.cursor + 6;
end


function qb_write_plusbox(qb:QuadBatch, t:float)
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


function qb_add_3d(qb: QuadBatch, x0: float, y0: float, x1: float, y1: float, u0: float, v0: float, u1: float, v1: float, z: vector.Vector4)
--   d - c
--   | / |
--   a - b

    let i : int = qb.cursor*3*6 -- (x,y) * vert_count * triangle_count_per_quad

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

function qb_add_centered(qb : QuadBatch, x : float, y : float, w : float, h : float, u0 : float, v0 : float, u1 : float, v1 : float)

    local wh = w / 2.0f
    local hh = h / 2.0f
    qb_add(qb, x - wh, y - hh, x + wh, y + hh, u0, v0, u1, v1)

end


function create_quad() : uint32
    local buffer = gl.gen_buffer()
    check_error("creating geo buffers", true)

    gl.bind_buffer(gl.GL_ARRAY_BUFFER, buffer)
    check_error("binding geo buffers", true)

    local data = [12:float]
    data[0] = -1.0f
    data[1] = -1.0f

    data[2] =  1.0f
    data[3] = -1.0f

    data[4] =  1.0f
    data[5] =  1.0f

    data[6] = -1.0f
    data[7] = -1.0f

    data[8] =  1.0f
    data[9] =  1.0f

    data[10] = -1.0f
    data[11] =  1.0f

    gl.buffer_data(gl.GL_ARRAY_BUFFER, 6*2*4, data, gl.GL_STATIC_DRAW)
    check_error("loading geo buffers", true)

    let vao = gl.gen_vertex_array();
    gl.bind_vertex_array(vao);

    gl.enable_vertex_attrib_array(0)
    gl.bind_buffer(gl.GL_ARRAY_BUFFER, buffer)
    gl.vertex_attrib_pointer(0u32, 2, gl.GL_FLOAT, false, 0, 0);

    return vao
end


function create_shader(vert_src : String, frag_src : String) : uint32
    local vert = gl.create_shader(gl.GL_VERTEX_SHADER)
    local frag = gl.create_shader(gl.GL_FRAGMENT_SHADER)
    local shader = gl.create_program()
    check_error("create programs", true)

    local a : [String] = [1:String]
    a[0] = vert_src
    gl.shader_source(vert, 1u64, a, 0u32)
    check_error("shader vert source", true)
    gl.compile_shader(vert)
    check_error("shader vert compile", true)
    shader_log(vert)

    local a : [String] = [1:String]
    a[0] = frag_src
    gl.shader_source(frag, 1u64, a, 0u32)
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
    shader_log(shader)

    return shader
end


-- ugly LUT
local lut_u: [float] = [16*16:float]
local lut_v: [float] = [16*16:float]
function create_lut()
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


function qb_text(qb : QuadBatch, start_x : float, start_y : float, txt : String, char_w : float, spacing : float)
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


function qb_text_slam(qb : QuadBatch, start_x : float, start_y : float, txt : String, char_w : float, spacing : float, where2:float)
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
local MAX_PARTICLE_COUNT : int = 1024 * 2
struct Particle
    local pos: @vector.Vector3
    local vel: @vector.Vector3
    local target: @vector.Vector3
    local speed: float
end

local PARTICLE_MODE_STATIC  : int = 0
local PARTICLE_MODE_FOLLOW  : int = 1
local PARTICLE_MODE_EXPLODE : int = 2

local PARTICLE_FIGURE_CUBE   : int = 0
local PARTICLE_FIGURE_SPHERE : int = 1
local PARTICLE_FIGURE_PLUSBOX : int = 2
local PARTICLE_FIGURE_PYRAMID : int = 3

struct ParticleSystem
    local mode : int
    local next_mode : int
    local figure : int
    local particle_buf : [@Particle]
    local cool_down : float
end


local test_psys : ParticleSystem = ParticleSystem {
    next_mode = PARTICLE_MODE_STATIC,
    mode = PARTICLE_MODE_STATIC,
    figure = PARTICLE_FIGURE_CUBE,
    cool_down = 0.0f }


function init_meshy_cube()
    test_psys.particle_buf = [MAX_PARTICLE_COUNT:@Particle]

    for particle in test_psys.particle_buf do
        local a : float = random() * 3.14f * 2.0f
        particle.pos.x = math.cos(a) * 2048.0f
        particle.pos.y = math.sin(a) * 1048.0f + 1100.0f
        particle.pos.z = 2000.0f
        particle.speed = (random() * 0.6f + 0.4f) * 0.6f
    end
end


function gen_points_from_line(v0: vector.Vector3, v1: vector.Vector3, points_per_line: int, ps: ParticleSystem, fill_start : int)
    local vec = vector.vec3(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z)
    local step = vector.vec3(vec.x / points_per_line as float,
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


function gen_square_points(x : float, y : float, w : float, h : float, ps : ParticleSystem, point_count : int)
    local wh : float = w / 2.0f
    local hh : float = h / 2.0f

    -- calc number of lines
    local lines = 4
    local points_per_line = point_count as float / lines as float

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


function gen_pyramid_particles(x: float, y: float, z: float, w: float, h: float, d: float, ps: ParticleSystem, mtx: matrix.Matrix)
    local wh : float = w / 2.0f
    local hh : float = h / 2.0f
    local dh : float = d / 2.0f

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

    local lines = 8
    local points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    local ppl_i = points_per_line as int
    gen_points_from_line(v0, v1, ppl_i, ps, ppl_i*0)
    gen_points_from_line(v1, v2, ppl_i, ps, ppl_i*1)
    gen_points_from_line(v2, v3, ppl_i, ps, ppl_i*2)
    gen_points_from_line(v3, v0, ppl_i, ps, ppl_i*3)

    gen_points_from_line(v0, v4, ppl_i, ps, ppl_i*4)
    gen_points_from_line(v1, v4, ppl_i, ps, ppl_i*5)
    gen_points_from_line(v2, v4, ppl_i, ps, ppl_i*6)
    gen_points_from_line(v3, v4, MAX_PARTICLE_COUNT - ppl_i*7, ps, ppl_i*7)
end


function gen_cube_particles(x: float, y: float, z: float, w: float, h: float, d: float, ps: ParticleSystem, mtx: matrix.Matrix)
    local wh : float = w / 2.0f
    local hh : float = h / 2.0f
    local dh : float = d / 2.0f

    -- verts
    let v0 = matrix.multiply(mtx, vector.vec4(-wh, -hh, dh, 1.0f))
    let v1 = matrix.multiply(mtx, vector.vec4(wh, -hh, dh, 1.0f))
    let v2 = matrix.multiply(mtx, vector.vec4(wh, hh, dh, 1.0f))
    let v3 = matrix.multiply(mtx, vector.vec4(-wh, hh, dh, 1.0f))
    let v4 = matrix.multiply(mtx, vector.vec4(-wh, -hh, -dh, 1.0f))
    let v5 = matrix.multiply(mtx, vector.vec4(wh, -hh, -dh, 1.0f))
    let v6 = matrix.multiply(mtx, vector.vec4(wh, hh, -dh, 1.0f))
    let v7 = matrix.multiply(mtx, vector.vec4(-wh, hh, -dh, 1.0f));

    let v0 = vector.vec3(v0.x + x, v0.y + y, v0.z + z)
    let v1 = vector.vec3(v1.x + x, v1.y + y, v1.z + z)
    let v2 = vector.vec3(v2.x + x, v2.y + y, v2.z + z)
    let v3 = vector.vec3(v3.x + x, v3.y + y, v3.z + z)
    let v4 = vector.vec3(v4.x + x, v4.y + y, v4.z + z)
    let v5 = vector.vec3(v5.x + x, v5.y + y, v5.z + z)
    let v6 = vector.vec3(v6.x + x, v6.y + y, v6.z + z)
    let v7 = vector.vec3(v7.x + x, v7.y + y, v7.z + z)

    local lines = 12
    local points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    local ppl_i = points_per_line as int
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


function gen_sphere_particles(x: float, y: float, z: float, w: float, h: float, d: float, ps: ParticleSystem, mtx: matrix.Matrix)
    let max_particle_count = MAX_PARTICLE_COUNT
    local dt = 3.1415f * 2.0f * 16.0f /  max_particle_count as float
    for i, particle in ps.particle_buf do
        local t = i as float * dt
        local s = math.sin(t)
        local c = math.cos(t)
        local ly = 1.0f - 2.0f* i as float / max_particle_count as float
        local w = math.sqrt(1.0f - ly*ly)

        local tmp = vector.vec4(s * 100.0f * w + x,
                                100.0f - 200.0f * i as float/max_particle_count as float + y,
                                c * 100.0f * w + z,
                                1.0f)
        local tmp2 = matrix.multiply(mtx, tmp)

        particle.target = tmp2.vec3()
    end
end


function gen_plusbox_particles(ps: ParticleSystem, mtx: matrix.Matrix)
    local lines:int = 0;
    local lp:int = 0;
    local kq:int = 0;
    local per:int = 0;
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
                    if (x == 0 and y == 0) then
                        corn = 1
                    elseif (x == 3 and y == 0) then
                        corn = 1
                    elseif (x == 3 and y == 3) then
                        corn = 1
                    elseif (x == 0 and y == 3) then
                        corn = 1
                    end

                    if ((q == 0 and corn == 0) or (q == 1 and corn == 1) or (q == 2 and corn == 0)) then
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
                                gen_points_from_line(matrix.multiply(mtx, u).vec3(), matrix.multiply(mtx, v).vec3(), MAX_PARTICLE_COUNT - lp, ps, lp);
                            else
                                gen_points_from_line(matrix.multiply(mtx, u).vec3(), matrix.multiply(mtx, v).vec3(), per, ps, lp);
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


function fux_particle_speed(ps : ParticleSystem)
    for particle in ps.particle_buf do
        particle.speed = (random() * 0.6f + 0.4f) * 0.6f
    end
end


function update_meshy_cube(ps : ParticleSystem, qb : QuadBatch, delta : float)
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
    qb_begin(qb)
    for particle in ps.particle_buf do
        let pos_z = particle.pos.z
        let zzzz = vector.vec4(pos_z, pos_z, pos_z, pos_z)
        qb_add_3d(qb, particle.pos.x - 5f, particle.pos.y - 5f, particle.pos.x + 5.0f, particle.pos.y + 5.0f, 0.0f, 0.0f, 1.0f, 1.0f, zzzz)
    end
    qb_end(qb)
end


--------------------------------------------------------------
-- scenes??
function run_particle_test()

    scene_particle_init()

    local last_time_stamp = glfw.get_time()

    while loop_begin() do
        let width, height = window.get_framebuffer_size()
        let widthf = width as float
        let heightf = height as float

        gl.viewport(0, 0, width, height)
        gl.clear_color(1.0f, 0.2f, 0.2f, 1.0f)
        gl.clear(0x4100u32)
        gl.disable(gl.GL_BLEND)
        gl.enable(gl.GL_DEPTH_TEST)
        gl.disable(gl.GL_CULL_FACE)

        local delta = glfw.get_time() - last_time_stamp
        last_time_stamp = glfw.get_time()
        loop_end()
    end
end

local particle_shader : uint32
local mesh_shader : uint32
local particle_qb : QuadBatch
let particle_amount : int = MAX_PARTICLE_COUNT
local particle_loc_mtx : int


function scene_particle_init()
    local vertex_src : String = read_file_as_string("data/shaders/particle_3d.vp")
    local fragment_src : String = read_file_as_string("data/shaders/particle.fp")

    particle_shader = create_shader(vertex_src, fragment_src)
    check_error("(particle) create shader", false)
    particle_loc_mtx = gl.get_uniform_location(particle_shader, "mtx")
    check_error("(particle) getting locations", false)

    particle_qb = create_quad_batch(particle_amount)

    init_meshy_cube()
end


function scene_particle_draw(window: glfw.Window, mtx: matrix.Matrix, delta: float)
    -- TODO fix allocation
    let width, height = window.get_framebuffer_size()
    local widthf = width as float
    local heightf = height as float

    local deltaf = delta

    gl.disable(gl.GL_DEPTH_TEST)
    gl.enable(gl.GL_BLEND)
    gl.blend_func(gl.GL_ONE, gl.GL_ONE)

    update_meshy_cube(test_psys, particle_qb, delta)

    gl.use_program(particle_shader)
    gl.uniform_matrix4fv(particle_loc_mtx, 1, true, mtx)
    qb_render(particle_qb)
end


function create_mesh(path : String) : uint32
    local buffer = gl.gen_buffer()
    gl.bind_buffer(gl.GL_ARRAY_BUFFER, buffer)

    local data : [byte] = read_file(path)
    io.println(#data)

    gl.buffer_data(gl.GL_ARRAY_BUFFER, #data, data, gl.GL_STATIC_DRAW)
    check_error("loading mesh geo buffers", true)

    let vao = gl.gen_vertex_array();
    gl.bind_vertex_array(vao);

    gl.enable_vertex_attrib_array(0)
    gl.bind_buffer(gl.GL_ARRAY_BUFFER, buffer)
    gl.vertex_attrib_pointer(0u32, 3, gl.GL_FLOAT, false, 0, 0);

    return vao
end


function loop_begin(): bool
    return window.window_should_close()
end

function loop_end()
    window.swap_buffers()
    glfw.poll_events()
end

local floorsize:int = 256

struct HF
    heights : @[float:65536]
end

local floordata:[@HF] = [2:@HF]
local music_channel: fmod.Channel

function gen_floor(qb:QuadBatch, gridsize:int)
    qb_begin(qb);
    local uvs = 1.0f / gridsize as float
    for u=0, gridsize-1 do
        local x:float = u as float - 0.5f * gridsize as float
        for v=0, gridsize-1 do
            local y:float = v as float - 0.5f * gridsize as float
            qb_add(qb, x, y, x + 1.0f, y + 1.0f, uvs*u as float, uvs*v as float, uvs*(u+1) as float, uvs*(v+1) as float)
        end
    end
    qb_end(qb)
end


function floor_sim(src: int, dst: int)
    local c2 = 30.0f

    local s = floordata[src].heights
    local d = floordata[dst].heights

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


function run_floor()
    scene_particle_init()

    let width, height = window.get_framebuffer_size()
    let widthf = width as float
    let heightf = height as float

    local fb : QuadBatch = create_quad_batch(1024*1024)

    -- logo texture
    local logo_data : [byte] = read_file("data/textures/defold_logo.raw")
    local logo_tex = create_texture(1280, 447, logo_data)
    local logo_qb = create_quad_batch(12)

    local vertex_src : String = read_file_as_string("data/shaders/floor.vp")
    local fragment_src : String = read_file_as_string("data/shaders/floor.fp")
    local floor_shader = create_shader(vertex_src, fragment_src);
    check_error("(floor) create shader", false);

    -- voxel
    vertex_src  = read_file_as_string("data/shaders/voxel.vp")
    fragment_src  = read_file_as_string("data/shaders/voxel.fp")
    local voxel_shader = create_shader(vertex_src, fragment_src)
    local voxel_qb = create_quad_batch(1024*1024);

    --- text
    vertex_src  = read_file_as_string("data/shaders/shader.vp")
    fragment_src  = read_file_as_string("data/shaders/shader.fp")
    local text_shader = create_shader(vertex_src, fragment_src)
    check_error("(text) create shader", false);
    local text_qb : QuadBatch = create_quad_batch(1024)
    local text_shader = create_shader(vertex_src, fragment_src)
    check_error("(particle) create shader", false)

    local loc_mtx:int = gl.get_uniform_location(floor_shader, "mtx")
    check_error("(particle) getting locations", false)
    local water_fade:int = gl.get_uniform_location(floor_shader, "waterFade");
    local logo_fade:int = gl.get_uniform_location(floor_shader, "logoFade");
    local water_time:int = gl.get_uniform_location(floor_shader, "waterTime");

    local t:float = 0.0f

    local tex0_data : [byte] = read_file("data/textures/consolefont.raw")
    local tex0 = create_texture(256, 256, tex0_data)

    -- FBO stuff
    vertex_src  = read_file_as_string("data/shaders/screen.vp")
    fragment_src  = read_file_as_string("data/shaders/screen.fp")
    local screen_shader = create_shader(vertex_src, fragment_src)
    local screen_quad = create_quad()

    let htex = gl.gen_texture()
    gl.bind_texture(gl.GL_TEXTURE_2D, htex)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)
    gl.tex_parameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)

    gen_floor(fb, 512)

    local cur = 1
    local anim = 0.0f

    local last_time_stamp = glfw.get_time()
    local start_time = last_time_stamp
    local to_water:float = 0.0f
    local water_t:float = 0.0f

    local to_logo:float = 0.0f
    local logo_t:float = 0.0f

    local psyk_t:float = 0.0f
    local next_switch = 0u64

    local texdata: [float] = [65536:float]

    while loop_begin() do
        let width, height = window.get_framebuffer_size()
        let widthf = width as float
        let heightf = height as float

        local delta = (glfw.get_time() - last_time_stamp) as float
        last_time_stamp = glfw.get_time()

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

        water_t = to_water * delta + water_t;
        logo_t = to_logo * delta + logo_t;

        gl.viewport(0, 0, width, height)
        gl.clear_color(0.0f, 0.0f, 0.0f, 1.0f)
        gl.clear(0x4100u32)
        gl.disable(gl.GL_BLEND)
        gl.enable(gl.GL_DEPTH_TEST)
        gl.disable(gl.GL_CULL_FACE)

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

        gl.bind_texture(gl.GL_TEXTURE_2D, htex);
        gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_R32F, 0, 0, 0, gl.GL_RED, gl.GL_FLOAT, texdata);
        gl.tex_image2D(gl.GL_TEXTURE_2D, 0, gl.GL_R32F, floorsize, floorsize, 0, gl.GL_RED, gl.GL_FLOAT, texdata);
        gl.uniform1f(water_fade, to_water);
        gl.uniform1f(logo_fade, to_logo);
        gl.uniform1f(water_time, water_t);

        qb_render(fb)
        floor_sim(cur, 1 - cur)
        cur = 1 - cur

        -- particles
        local imtx = matrix.ident();
        local rot_mtx = imtx.rotate_X(t*1.1f);
        rot_mtx = rot_mtx.rotate_Z((t*0.7f))

        local move = psyk_t;
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

        qb_begin(voxel_qb);
        qb_write_plusbox(voxel_qb, logo_t - 0.3f);
        qb_end(voxel_qb);
        qb_render(voxel_qb);

        gl.use_program(particle_shader)
        scene_particle_draw(window, camera, 0.1f)

        if window.get_mouse_button(0) == 1 then
            test_psys.mode = PARTICLE_MODE_STATIC
        end

        local px:int = (math.sin(2.0f*t)*64.0f) as int + 128;
        local py:int = (math.cos(3.0f*t)*64.0f) as int + 128;

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
        gl.disable(gl.GL_DEPTH_TEST);

        local ortho_mtx = matrix.ortho(0.0f, 800.0f, 0.0f, 600.0f, 0.0f, 1.0f)
        local location_mtx = gl.get_uniform_location(text_shader, "mtx")
        local location_anim = gl.get_uniform_location(text_shader, "anim")
        local location_offset = gl.get_uniform_location(text_shader, "offset")
        local location_mode = gl.get_uniform_location(text_shader, "mode")
        check_error("getting locations", false)

        gl.enable(gl.GL_BLEND)
        gl.blend_func(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
        gl.use_program(text_shader)
        gl.uniform_matrix4fv(location_mtx, 1, true, ortho_mtx)
        gl.uniform1f(location_anim, t);
        gl.uniform1f(location_offset, t);
        gl.uniform1i(location_mode, 3);
        gl.bind_texture(gl.GL_TEXTURE_2D, tex0);

        qb_begin(text_qb);

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

        qb_end(text_qb)
        qb_render(text_qb);

        t = t + delta

        -- render logo
        if (logo_t > 100.0f) then
            gl.use_program(screen_shader)
            gl.bind_texture(gl.GL_TEXTURE_2D, logo_tex)
            location_mtx = gl.get_uniform_location(screen_shader, "mtx")
            gl.uniform_matrix4fv(location_mtx, 1, true, ortho_mtx);
            local logo_scale = 0.3f
            qb_begin(logo_qb)
            qb_add_centered(logo_qb, 400.0f, 100.0f, 1280.0f * logo_scale, 447.0f * logo_scale, 0.0f, 1.0f, 1.0f, 0.0f)
            qb_end(logo_qb)
            qb_render(logo_qb)
        end

        loop_end()
    end
end


function init_audio(): fmod.System
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


function load_sound(fmod_system: fmod.System, path: String): fmod.Sound
    local sound_result = fmod_system.create_sound(path, 0x40u64, 0u64)

    if sound_result.0 ~= fmod.OK then
        panic("could not create sound: " .. path)
    end

    return sound_result.1
end


function play_sound(fmod_system: fmod.System, fmod_sound: fmod.Sound): fmod.Channel
    local play_res = fmod_system.play_sound(-1, fmod_sound, false)
    if play_res.0 ~= fmod.OK then
        panic("could not play sound")
    end
    return play_res.1;
end

local line1: String = "SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL"
local line2: String = "awesome scroller! check it... - leet haxxxx - very lua - much types"
local line3: String = "awesome scroller - check it"

local mesh_vbo : uint32 = 0u32

