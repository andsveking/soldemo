module gl

require C
require matrix


let FALSE: uint32 = 0x0u32
let TRUE: uint32 = 0x1u32

type Type = uint32

let FLOAT: Type = Type{ 0x1406 }
let BYTE: Type = Type{ 0x1400 }
let UNSIGNED_BYTE: Type = Type{ 0x1401 }

let GL_BLEND: uint32 = 0x0BE2u32
let GL_ALPHA_TEST: uint32 = 0x0BC0u32
let GL_DEPTH_TEST: uint32 = 0x0B71u32
let GL_CULL_FACE: uint32 = 0x0B44u32

let GL_ZERO: uint32 = 0u32
let GL_ONE: uint32 = 1u32

let GL_SRC_COLOR           : uint32 = 0x0300u32
let GL_ONE_MINUS_SRC_COLOR : uint32 = 0x0301u32
let GL_SRC_ALPHA           : uint32 = 0x0302u32
let GL_ONE_MINUS_SRC_ALPHA : uint32 = 0x0303u32
let GL_DST_ALPHA           : uint32 = 0x0304u32
let GL_ONE_MINUS_DST_ALPHA : uint32 = 0x0305u32

type BufferMask = uint32

let DEPTH_BUFFER_BIT: BufferMask = BufferMask{ 0x00000100 }
let STENCIL_BUFFER_BIT: BufferMask = BufferMask{ 0x00000400 }
let COLOR_BUFFER_BIT: BufferMask = BufferMask{ 0x00004000 }

fn | (a: BufferMask, b: BufferMask): BufferMask
    return BufferMask{ a.alias | b.alias }
end


type Target = uint32

let ARRAY_BUFFER: Target = Target{ 0x8892 }


type Usage = uint32

let STATIC_DRAW: Usage = Usage{ 0x88E4 }
let STREAM_DRAW: Usage = Usage{ 0x88E0 }


let GL_TRIANGLES        : uint32 = 0x0004u32

let GL_TEXTURE_2D       : uint32 = 0x0DE1u32
let GL_RGBA             : uint32 = 0x1908u32
let GL_LUMINANCE        : uint32 = 0x1901u32
let GL_ALPHA            : uint32 = 0x1906u32
let GL_R32F             : uint32 = 0x822Eu32
let GL_RED              : uint32 = 0x1903u32

let GL_TEXTURE_MAG_FILTER : uint32 = 0x2800u32
let GL_TEXTURE_MIN_FILTER : uint32 = 0x2801u32
let GL_NEAREST            : uint32 = 0x2600u32
let GL_LINEAR             : uint32 = 0x2601u32

let GL_FRAMEBUFFER       : uint32 = 0x8D40u32
let GL_RENDERBUFFER      : uint32 = 0x8D41u32
let GL_DEPTH_COMPONENT   : uint32 = 0x1902u32
let GL_DEPTH_ATTACHMENT  : uint32 = 0x8D00u32
let GL_COLOR_ATTACHMENT0 : uint32 = 0x8CE0u32
let GL_FRAMEBUFFER_COMPLETE : uint32 = 0x8CD5u32


local struct Ptr<T>
    local value: T
end


!symbol("glGetError") !nogc
extern get_error(): uint32

!symbol("glViewport") !nogc
extern viewport(x: int, y :int, width: int, height: int)

!symbol("glClear") !nogc
extern clear(mask: BufferMask)

!symbol("glClearColor") !nogc
extern clear_color(red: float, green: float, blue: float, alpha: float)

!symbol("glEnable") !nogc
extern enable(cap: uint32)

!symbol("glDisable") !nogc
extern disable(cap: uint32)

!symbol("glBlendFunc") !nogc
extern blend_func(sfactor: uint32, dfactor: uint32)


--
-- SHADER
--
type Program = uint32
type Shader = uint32
type ShaderType = uint32

let NULL_PROGRAM: Program = Program{ 0u32 }

let FRAGMENT_SHADER: ShaderType = ShaderType{ 0x8B30 }
let VERTEX_SHADER: ShaderType = ShaderType{ 0x8B31 }
let GEOMETRY_SHADER: ShaderType = ShaderType{ 0x8DD9 }

!symbol("glCreateShader") !nogc
extern create_shader(shaderType: ShaderType): Shader

!symbol("glDeleteShader") !nogc
extern delete_shader(shader: Shader)

!symbol("glCreateProgram") !nogc
extern create_program(): Program

!symbol("glShaderSource") !nogc
local extern shader_source(shader: Shader, count: uint32, src: Ptr<String>, length: C.uintptr)

fn shader_source(shader: Shader, source: String)
    shader_source(shader, 1u32, Ptr<String>{ source }, C.uintptr(0u32))
end

!symbol("glCompileShader") !nogc
extern compile_shader(shader: Shader)

!symbol("glAttachShader") !nogc
extern attach_shader(program: Program, shader: Shader)

!symbol("glDetachShader") !nogc
extern detach_shader(program: Program, shader: Shader)

!symbol("glLinkProgram") !nogc
extern link_program(program: Program)

!symbol("glUseProgram") !nogc
extern use_program(program: Program)

!symbol("glIsShader") !nogc
extern is_shader(shader: Shader): bool


type ShaderParam = uint32

let SP_SHADER_TYPE: ShaderParam = ShaderParam{ 0x8B4F }
let SP_DELETE_STATUS: ShaderParam = ShaderParam{ 0x8B80 }
let SP_COMPILE_STATUS: ShaderParam = ShaderParam{ 0x8B81 }
let SP_INFO_LOG_LENGTH: ShaderParam = ShaderParam{ 0x8B84 }
let SP_SHADER_SOURCE_LENGTH: ShaderParam = ShaderParam{ 0x8B88 }

!symbol("glGetShaderiv") !nogc
local extern get_shaderiv(shader: Shader, pname: ShaderParam, params: Ptr<int>)

fn get_shaderiv(shader: Shader, pname: ShaderParam): int
    let ret_val = Ptr<int>{}
    get_shaderiv(shader, pname, ret_val)
    return ret_val.value
end


type ProgramParam = uint32

let PP_DELETE_STATUS: ProgramParam = ProgramParam{ 0x8B80 }
let PP_LINK_STATUS: ProgramParam = ProgramParam{ 0x8B82 }
let PP_VALIDATE_STATUS: ProgramParam = ProgramParam{ 0x8B83 }
let PP_INFO_LOG_LENGTH: ProgramParam = ProgramParam{ 0x8B84 }
let PP_ATTACHED_SHADERS: ProgramParam = ProgramParam{ 0x8B85 }
let PP_ACTIVE_ATOMIC_COUNTER_BUFFERS: ProgramParam = ProgramParam{ 0x92D9 }
let PP_ACTIVE_ATTRIBUTES: ProgramParam = ProgramParam{ 0x8B89 }
let PP_ACTIVE_ATTRIBUTE_MAX_LENGTH: ProgramParam = ProgramParam{ 0x8B8A }
let PP_ACTIVE_UNIFORMS: ProgramParam = ProgramParam{ 0x8B86 }
let PP_ACTIVE_UNIFORM_BLOCKS: ProgramParam = ProgramParam{ 0x8A36 }
let PP_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH: ProgramParam = ProgramParam{ 0x8A35 }
let PP_ACTIVE_UNIFORM_MAX_LENGTH: ProgramParam = ProgramParam{ 0x8B87 }
let PP_COMPUTE_WORK_GROUP_SIZE: ProgramParam = ProgramParam{ 0x8267 }
let PP_PROGRAM_BINARY_LENGTH: ProgramParam = ProgramParam{ 0x8741 }
let PP_TRANSFORM_FEEDBACK_BUFFER_MODE: ProgramParam = ProgramParam{ 0x8C7F }
let PP_TRANSFORM_FEEDBACK_VARYINGS: ProgramParam = ProgramParam{ 0x8C83 }
let PP_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH: ProgramParam = ProgramParam{ 0x8C76 }
let PP_GEOMETRY_VERTICES_OUT: ProgramParam = ProgramParam{ 0x8916 }
let PP_GEOMETRY_INPUT_TYPE: ProgramParam = ProgramParam{ 0x8917 }
let PP_GEOMETRY_OUTPUT_TYPE: ProgramParam = ProgramParam{ 0x8918 }

!symbol("glGetProgramiv") !nogc
local extern get_programiv(program: Program, pname: ProgramParam, params: Ptr<int>)

fn get_programiv(program: Program, pname: ProgramParam): int
    let ret_val = Ptr<int>{}
    get_programiv(program, pname, ret_val)
    return ret_val.value
end

!symbol("glGetShaderInfoLog") !nogc
local extern get_shader_info_log(shader: Shader, max_size: uint32, length: Ptr<uint32>, info_log: [byte])

fn get_shader_info_log(shader: Shader, max_size: uint32): String
    let byte_buffer = [max_size: byte]
    get_shader_info_log(shader, max_size, Ptr<uint32>{}, byte_buffer)
    return string(byte_buffer)
end

!symbol("glGetProgramInfoLog") !nogc
local extern get_program_info_log(program: Program, max_size: uint32, length: Ptr<uint32>, info_log: [byte])

fn get_program_info_log(program: Program, max_size: uint32): String
    let byte_buffer = [max_size: byte]
    get_program_info_log(program, max_size, Ptr<uint32>{}, byte_buffer)
    return string(byte_buffer)
end

!symbol("glGetUniformLocation") !nogc
extern get_uniform_location(program: Program, name: String): int

!symbol("glUniform4fv") !nogc
extern uniform4fv(location: int, count: int, value: [float])

!symbol("glUniform1f") !nogc
extern uniform1f(location: int, v0: float)

!symbol("glUniform1i") !nogc
extern uniform1i(location: int, v0: int)

!symbol("glUniformMatrix4fv") !nogc
extern uniform_matrix4fv(location: int, count: int, transpose: bool, value: matrix.Matrix)




!symbol("glGenBuffers") !nogc
local extern gen_buffers(n: int, buffers: Ptr<uint32>)

fn gen_buffer(): Buffer
    let buffer = Ptr<uint32>{}
    gen_buffers(1, buffer)
    return Buffer{buffer.value}
end

!symbol("glGenBuffers") !nogc
local extern gen_buffers(n: int, buffers: [Buffer])

fn gen_buffers(buffers: [Buffer])
    gen_buffers(#buffers, buffers)
end

!symbol("glGenVertexArrays") !nogc
local extern gen_vertex_arrays(n: int, buffers: Ptr<uint32>)

fn gen_vertex_array(): uint32
    let buffer = Ptr<uint32>{}
    gen_vertex_arrays(1, buffer)
    return buffer.value
end

!symbol("glBindBuffer") !nogc
extern bind_buffer(target: Target, buffer: Buffer)

!symbol("glBindVertexArray") !nogc
extern bind_vertex_array(array: uint32)

!symbol("glBufferData") !nogc
local extern ext_buffer_data(target: Target, size: int, data: [float], usage: Usage)

fn buffer_data(target: Target, size: int, data: [float], usage: Usage)
    ext_buffer_data(target, size * 4, data, usage)
end

!symbol("glBufferData") !nogc
extern buffer_data(target: Target, size: int, data: [byte], usage: Usage)

!symbol("glDrawArrays") !nogc
extern draw_arrays(mode: uint32, first: uint32, count: int)

!symbol("glEnableVertexAttribArray") !nogc
extern enable_vertex_attrib_array(index: int)

!symbol("glDisableVertexAttribArray") !nogc
extern disable_vertex_attrib_array(index: int)

!symbol("glVertexAttribPointer") !nogc
extern vertex_attrib_pointer(index: uint32, size: uint32, typ: Type, normalized: bool, stride: int, pointer: C.uintptr)


--
-- TEXTURE
--
!symbol("glGenTextures") !nogc
local extern gen_textures(n: int, textures: Ptr<uint32>)

fn gen_texture(): uint32
    let texture = Ptr<uint32>{}
    gen_textures(1, texture)
    return texture.value
end

!symbol("glBindTexture") !nogc
extern bind_texture(target: uint32, texture: uint32)

!symbol("glTexImage2D") !nogc
extern tex_image2D(target: uint32, level: int, internalFormat: uint32, width: int, height: int, border: int, format: uint32, typ: Type, data: uint32) -- for empty textures

!symbol("glTexImage2D") !nogc
extern tex_image2D(target: uint32, level: int, internalFormat: uint32, width: int, height: int, border: int, format: uint32, typ: Type, data: [byte])

!symbol("glTexImage2D") !nogc
extern tex_image2D(target: uint32, level: int, internalFormat: uint32, width: int, height: int, border: int, format: uint32, typ: Type, data: [float])

!symbol("glTexParameteri") !nogc
extern tex_parameteri(target: uint32, pname: uint32, param: uint32)


--
-- BUFFER
--
type Buffer = uint32

let NULL_BUFFER: Buffer = Buffer{ 0u32 }

!symbol("glGenRenderbuffers") !nogc
extern gen_renderbuffers(n: int, renderbuffers: [uint32])

!symbol("glGenRenderbuffers") !nogc
local extern gen_renderbuffers(n: int, renderbuffers: Ptr<uint32>)

fn gen_renderbuffer(): uint32
    let buffer = Ptr<uint32>{}
    gen_renderbuffers(1, buffer)
    return buffer.value
end

!symbol("glBindRenderbuffer") !nogc
extern bind_renderbuffer(target: uint32, renderbuffer: uint32)

!symbol("glRenderbufferStorage") !nogc
extern renderbuffer_storage(target: uint32, internalformat: uint32, width: int, height: int)

!symbol("glGenFramebuffers") !nogc
extern gen_framebuffers(n: int, framebuffers: [uint32])

!symbol("glBindFramebuffer") !nogc
extern bind_framebuffer(target: uint32, framebuffer: uint32)

!symbol("glFramebufferRenderbuffer") !nogc
extern framebuffer_renderbuffer( target: uint32, attachment: uint32, renderbuffertarget: uint32, renderbuffer: uint32)

!symbol("glFramebufferTexture") !nogc
extern framebuffer_texture(target: uint32, attachment: uint32, texture: uint32, level: int)

!symbol("glDrawBuffers") !nogc
extern draw_buffers(n: int, bufs: [uint32])

!symbol("glDrawBuffers") !nogc
local extern draw_buffers(n: int, bufs: Ptr<uint32>)

fn draw_buffer(buffer: uint32)
    let buffer = Ptr<uint32>{buffer}
    draw_buffers(1, buffer)
end

!symbol("glCheckFramebufferStatus") !nogc
extern check_framebuffer_status(target: uint32): uint32

