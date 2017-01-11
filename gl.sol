module gl

import matrix

type Buffer = uint32


let GL_FALSE: uint32 = 0x0u32
let GL_TRUE: uint32 = 0x1u32

let GL_FLOAT: uint32 = 0x1406u32
let GL_BYTE: uint32 = 0x1400u32

let GL_COLOR_BUFFER_BIT: uint32 = 0x4000u32
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

type ShaderType = uint32

let FRAGMENT_SHADER: ShaderType = ShaderType{ 0x8B30 }
let VERTEX_SHADER: ShaderType = ShaderType{ 0x8B31 }

let GL_INFO_LOG_LENGTH  : uint32 = 0x8B84u32


type Target = uint32

let ARRAY_BUFFER: Target = Target{ 0x8892 }


type Usage = uint32

let STATIC_DRAW: Usage = Usage{ 0x88E4 }


let GL_TRIANGLES        : uint32 = 0x0004u32

let GL_TEXTURE_2D       : uint32 = 0x0DE1u32
let GL_RGBA             : uint32 = 0x1908u32
let GL_UNSIGNED_BYTE    : uint32 = 0x1401u32
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


local struct Wrap<T>
    local value: T
end


!symbol("glGetError") !nogc
extern get_error(): uint32

!symbol("glViewport") !nogc
extern viewport(x: int, y :int, width: int, height: int)

!symbol("glClear") !nogc
extern clear(mask: uint32)

!symbol("glClearColor") !nogc
extern clear_color(red: float, green: float, blue: float, alpha: float)

!symbol("glEnable") !nogc
extern enable(cap: uint32)

!symbol("glDisable") !nogc
extern disable(cap: uint32)

!symbol("glBlendFunc") !nogc
extern blend_func(sfactor: uint32, dfactor: uint32)

!symbol("glCreateShader") !nogc
extern create_shader(shaderType: ShaderType): uint32

!symbol("glCreateProgram") !nogc
extern create_program(): uint32

!symbol("glShaderSource") !nogc
extern shader_source(shader: uint32, count: uint64, lines: [String], length: uint32)

!symbol("glCompileShader") !nogc
extern compile_shader(shader: uint32)

!symbol("glAttachShader") !nogc
extern attach_shader(program: uint32, shader: uint32)

!symbol("glLinkProgram") !nogc
extern link_program(program: uint32)

!symbol("glUseProgram") !nogc
extern use_program(program: uint32)

!symbol("glIsShader") !nogc
extern is_shader(obj: uint32): bool

!symbol("glGetShaderiv") !nogc
extern get_shaderiv(shader: uint32, pname: uint32, params: [int])

!symbol("glGetProgramiv") !nogc
extern get_programiv(shader: uint32, pname: uint32, params: [int])

!symbol("glGetShaderInfoLog") !nogc
extern get_shader_info_log(shader: uint32, maxLength: int, length: [int], infoLog: [byte])

!symbol("glGetProgramInfoLog") !nogc
extern get_program_info_log(shader: uint32, maxLength: int, length: [int], infoLog: [byte])

!symbol("glGetUniformLocation") !nogc
extern get_uniform_location(program: uint32, name: String): int

!symbol("glUniform4fv") !nogc
extern uniform4fv(location: int, count: int, value: [float])

!symbol("glUniform1f") !nogc
extern uniform1f(location: int, v0: float)

!symbol("glUniform1i") !nogc
extern uniform1i(location: int, v0: int)

!symbol("glUniformMatrix4fv") !nogc
extern uniform_matrix4fv(location: int, count: int, transpose: bool, value: matrix.Matrix)


!symbol("glGenBuffers") !nogc
local extern gen_buffers(n: int, buffers: Wrap<uint32>)

fn gen_buffer(): Buffer
    let buffer = Wrap<uint32>{}
    gen_buffers(1, buffer)
    return Buffer{buffer.value}
end

!symbol("glGenBuffers") !nogc
local extern gen_buffers(n: int, buffers: [Buffer])

fn gen_buffers(buffers: [Buffer])
    gen_buffers(#buffers, buffers)
end

!symbol("glGenVertexArrays") !nogc
local extern gen_vertex_arrays(n: int, buffers: Wrap<uint32>)

fn gen_vertex_array(): uint32
    let buffer = Wrap<uint32>{}
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
extern vertex_attrib_pointer(index: uint32, size: int, typ: uint32, normalized: bool, stride: int, pointer: int)


-- OGL: Textures
!symbol("glGenTextures") !nogc
local extern gen_textures(n: int, textures: Wrap<uint32>)

fn gen_texture(): uint32
    let texture = Wrap<uint32>{}
    gen_textures(1, texture)
    return texture.value
end

!symbol("glBindTexture") !nogc
extern bind_texture(target: uint32, texture: uint32)

!symbol("glTexImage2D") !nogc
extern tex_image2D(target: uint32, level: int, internalFormat: uint32, width: int, height: int, border: int, format: uint32, typ: uint32, data: uint32) -- for empty textures

!symbol("glTexImage2D") !nogc
extern tex_image2D(target: uint32, level: int, internalFormat: uint32, width: int, height: int, border: int, format: uint32, typ: uint32, data: [byte])

!symbol("glTexImage2D") !nogc
extern tex_image2D(target: uint32, level: int, internalFormat: uint32, width: int, height: int, border: int, format: uint32, typ: uint32, data: [float])

!symbol("glTexParameteri") !nogc
extern tex_parameteri(target: uint32, pname: uint32, param: uint32)


-- OGL: FBO
!symbol("glGenRenderbuffers") !nogc
extern gen_renderbuffers(n: int, renderbuffers: [uint32])

!symbol("glGenRenderbuffers") !nogc
local extern gen_renderbuffers(n: int, renderbuffers: Wrap<uint32>)

fn gen_renderbuffer(): uint32
    let buffer = Wrap<uint32>{}
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
local extern draw_buffers(n: int, bufs: Wrap<uint32>)

fn draw_buffer(buffer: uint32)
    let buffer = Wrap<uint32>{buffer}
    draw_buffers(1, buffer)
end

!symbol("glCheckFramebufferStatus") !nogc
extern check_framebuffer_status(target: uint32): uint32

