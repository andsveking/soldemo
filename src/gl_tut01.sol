module gl_tut01

require io
require glfw
require gl
require C
require math
require vector


!main
fn main(args: [String]): int
    let title_base = "Fun with opengl, fpks: "
    let window = create_window(title_base)

    let renderer = initialize_renderer()

    local frame_counter = 0
    local last_frame_start = glfw.get_time()
    local last_fps_report = last_frame_start
    let max_frame_time = 1.0 / 60.0 / 2.0

    while not window.window_should_close() do
        let frame_start = glfw.get_time()
        let frame_elapsed = frame_start - last_frame_start

        display(frame_start as float, renderer)

        if frame_start - last_fps_report >= 1.0 then
            let exact_elapsed_time = last_frame_start - last_fps_report
            last_fps_report = last_frame_start
            window.set_title(title_base .. (frame_counter as double / exact_elapsed_time*1000.0) as int)
            frame_counter = 0
        end

        let frame_end = glfw.get_time()
        if frame_end-frame_start > max_frame_time then
            io.println("frame took: " .. ((frame_end-frame_start)*1000.0) as uint32 .. " ms")
        end

        last_frame_start = frame_start
        frame_counter +=1

        window.swap_buffers()
        glfw.poll_events()
    end
end


fn display(time: float, renderer: TriangleRenderer)
    gl.clear_color(0.0f, 0.0f, 0.5f, 0.0f)
    gl.clear(gl.COLOR_BUFFER_BIT)

    renderer.render(time)
end


struct TriangleRenderer
    program: gl.Program
    offset_location: gl.Uniform
    time_location: gl.Uniform

    vao: gl.VertexArrayObject
    buffer: gl.Buffer

    fn render(time: float)
        gl.use_program(self.program)
        gl.bind_vertex_array(self.vao)

        gl.uniform1f(self.time_location, time)

        let loop_duration = 5.0f

        let x_offset, y_offset = compute_position_offsets(time, loop_duration)
        gl.uniform2f(self.offset_location, x_offset, y_offset)
        gl.draw_arrays(gl.TRIANGLES, 0u32, 3)

        let x_offset, y_offset = compute_position_offsets(time + (loop_duration/2f), loop_duration)
        gl.uniform2f(self.offset_location, x_offset, y_offset)
        gl.draw_arrays(gl.TRIANGLES, 0u32, 3)

        gl.use_program(gl.NULL_PROGRAM)
    end
end


fn initialize_renderer(): TriangleRenderer
    let program = initialize_program()

    -- uniform locations
    let offset_location = gl.get_uniform_location(program, "offset")
    let time_location = gl.get_uniform_location(program, "time")
    let loop_duration_location = gl.get_uniform_location(program, "loopDuration")

    -- set 'static' uniform
    gl.use_program(program)
    gl.uniform1f(loop_duration_location, 5.0f)
    gl.use_program(gl.NULL_PROGRAM)

    -- our triangle
    let vertex_positions = [6: @vector.Vector4]
    -- vertices
    vertex_positions[0] = vector.Vector4{  0.0f,  0.5f,   0.0f, 1.0f }
    vertex_positions[1] = vector.Vector4{  0.5f, -0.366f, 0.0f, 1.0f }
    vertex_positions[2] = vector.Vector4{ -0.5f, -0.366f, 0.0f, 1.0f }
    -- colors
    vertex_positions[3] = vector.Vector4{ 1.0f, 0.0f, 0.0f, 1.0f }
    vertex_positions[4] = vector.Vector4{ 0.0f, 1.0f, 0.0f, 1.0f }
    vertex_positions[5] = vector.Vector4{ 0.0f, 0.0f, 1.0f, 1.0f }

    -- create VAO
    let vao = gl.gen_vertex_array()
    gl.bind_vertex_array(vao)

    -- create buffer
    let buffer = gl.gen_buffer()
    gl.bind_buffer(gl.ARRAY_BUFFER, buffer)
    gl.buffer_data(gl.ARRAY_BUFFER, C.uintptr((#vertex_positions*4*4) as uint32), vertex_positions as handle, gl.STATIC_DRAW)
    gl.enable_vertex_attrib_array(0)
    gl.enable_vertex_attrib_array(1)
    gl.vertex_attrib_pointer(0u32, 4u32, gl.FLOAT, false, 0, C.uintptr(0u32))
    gl.vertex_attrib_pointer(1u32, 4u32, gl.FLOAT, false, 0, C.uintptr((4*4*3) as uint32))

    -- reset
    gl.bind_buffer(gl.ARRAY_BUFFER, gl.NULL_BUFFER)
    gl.bind_vertex_array(gl.NULL_VAO)

    return TriangleRenderer{ program=program, offset_location=offset_location, time_location=time_location, vao=vao, buffer=buffer }
end


fn compute_position_offsets(time: float, loop_duration: float): float, float
    let scale = math.pi() as float * 2.0f / loop_duration

    let loop_time = math.fmod(time, loop_duration)
    let x_offset = math.cos(loop_time * scale) * 0.5f;
    let y_offset = math.sin(loop_time * scale) * 0.5f;

    return x_offset, y_offset
end


fn initialize_program(): gl.Program
    let fragment_shader = create_shader(gl.FRAGMENT_SHADER, fragment_shader)
    let vertex_shader = create_shader(gl.VERTEX_SHADER, vertex_shader)
    let program = create_program([fragment_shader, vertex_shader])
    gl.delete_shader(fragment_shader)
    gl.delete_shader(vertex_shader)
    return program
end


fn create_program(shaders: [gl.Shader]): gl.Program
    let program = gl.create_program()

    for shader in shaders do
        gl.attach_shader(program, shader)
    end

    gl.link_program(program)
    let link_status = gl.get_programiv(program, gl.PP_LINK_STATUS)
    if link_status == gl.FALSE then
        let log_length = gl.get_programiv(program, gl.PP_INFO_LOG_LENGTH)
        let log = gl.get_program_info_log(program, log_length as uint32)
        io.println("Program linking failed: ")
        io.println(log)
    end

    for shader in shaders do
        gl.detach_shader(program, shader)
    end

    return program
end


fn create_shader(shader_type: gl.ShaderType, source: String): gl.Shader
    let shader = gl.create_shader(shader_type)
    gl.shader_source(shader, source)
    gl.compile_shader(shader)
    let compile_status = gl.get_shaderiv(shader, gl.SP_COMPILE_STATUS)

    if compile_status == gl.FALSE then
        let log_length = gl.get_shaderiv(shader, gl.SP_INFO_LOG_LENGTH)
        let log = gl.get_shader_info_log(shader, log_length as uint32)
        io.println("Shader compilation failed: ")
        io.println(log)
    end

    return shader
end


fn create_window(title: String): glfw.Window
    if glfw.init() == 0 then
        panic("glfw failed to initilaize")
    end

    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 4)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 1)
    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, 1)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    let window = glfw.create_window(400*2, 240*2, title)
    window.make_context_current()

    if window.is_valid() then
        window.show()
    else
        panic("could not create window!")
    end

    window.set_key_callback(*key_callback)
    return window
end


!export("key_callback2")
local fn key_callback(key: glfw.Key, scancode: int, action: glfw.Action, mods: glfw.Mods)
    if key == glfw.KEY_SPACE and action.is_press() then
        io.println("jump!")
    end
end


let vertex_shader: String =
"""
#version 330

layout(location = 0) in vec4 position;
layout (location = 1) in vec4 color;
uniform vec2 offset;

smooth out vec4 theColor;

void main()
{
    vec4 totalOffset = vec4(offset.x, offset.y, 0.0, 0.0);
    gl_Position = position + totalOffset;
    theColor = color;
}
"""


let fragment_shader: String =
"""
#version 330

smooth in vec4 theColor;

out vec4 outputColor;

uniform float loopDuration;
uniform float time;

const vec4 secondColor = vec4(0.0f, 1.0f, 0.0f, 1.0f);

void main()
{
    float currTime = mod(time, loopDuration);
    float currLerp = sin((currTime / loopDuration) * 3.14159 * 2);

    outputColor = mix(theColor, secondColor, currLerp);
}
"""
