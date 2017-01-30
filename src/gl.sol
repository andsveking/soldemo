module gl

require C
require matrix


let FALSE: uint32 = 0x0u32
let TRUE: uint32 = 0x1u32

type Type = uint32

let BYTE: Type = Type{ 0x1400 }
let UNSIGNED_BYTE: Type = Type{ 0x1401 }
let SHORT: Type = Type{ 0x1402 }
let UNSIGNED_SHORT: Type = Type{ 0x1403 }
let INT: Type = Type{ 0x1404 }
let UNSIGNED_INT: Type = Type{ 0x1405 }
let FLOAT: Type = Type{ 0x1406 }
let DOUBLE: Type = Type{ 0x140A }


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
let ELEMENT_ARRAY_BUFFER: Target = Target{ 0x8893 }


type Usage = uint32

let STATIC_DRAW: Usage = Usage{ 0x88E4 }
let STREAM_DRAW: Usage = Usage{ 0x88E0 }

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

!symbol("glBlendFunc") !nogc
extern blend_func(sfactor: uint32, dfactor: uint32)


--
-- Capabilities
--
type Capability = uint32

let ALPHA_TEST: Capability = Capability{ 0x0BC0 }
let AUTO_NORMAL: Capability = Capability{ 0x0D80 }
let BLEND: Capability = Capability{ 0x0BE2 }
let CLIP_DISTANCE0: Capability = Capability{ 0x3000 }
let CLIP_DISTANCE1: Capability = Capability{ 0x3001 }
let CLIP_DISTANCE2: Capability = Capability{ 0x3002 }
let CLIP_DISTANCE3: Capability = Capability{ 0x3003 }
let CLIP_DISTANCE4: Capability = Capability{ 0x3004 }
let CLIP_DISTANCE5: Capability = Capability{ 0x3005 }
let CLIP_DISTANCE6: Capability = Capability{ 0x3006 }
let CLIP_DISTANCE7: Capability = Capability{ 0x3007 }
let COLOR_LOGIC_OP: Capability = Capability{ 0x0BF2 }
let CULL_FACE: Capability = Capability{ 0x0B44 }
let DEBUG_OUTPUT: Capability = Capability{ 0x92E0 }
let DEBUG_OUTPUT_SYNCHRONOUS: Capability = Capability{ 0x8242 }
let DEPTH_CLAMP: Capability = Capability{ 0x864F }
let DEPTH_TEST: Capability = Capability{ 0x0B71 }
let DITHER: Capability = Capability{ 0x0BD0 }
let FRAMEBUFFER_SRGB: Capability = Capability{ 0x8DB9 }
let LINE_SMOOTH: Capability = Capability{ 0x0B20 }
let MULTISAMPLE: Capability = Capability{ 0x809D }
let POLYGON_OFFSET_FILL: Capability = Capability{ 0x8037 }
let POLYGON_OFFSET_LINE: Capability = Capability{ 0x2A02 }
let POLYGON_OFFSET_POINT: Capability = Capability{ 0x2A01 }
let POLYGON_SMOOTH: Capability = Capability{ 0x0B41 }
let PRIMITIVE_RESTART: Capability = Capability{ 0x8F9D }
let PRIMITIVE_RESTART_FIXED_INDEX: Capability = Capability{ 0x8D69 }
let RASTERIZER_DISCARD: Capability = Capability{ 0x8C89 }
let SAMPLE_ALPHA_TO_COVERAGE: Capability = Capability{ 0x809E }
let SAMPLE_ALPHA_TO_ONE: Capability = Capability{ 0x809F }
let SAMPLE_COVERAGE: Capability = Capability{ 0x80A0 }
let SAMPLE_SHADING: Capability = Capability{ 0x8C36 }
let SAMPLE_MASK: Capability = Capability{ 0x8E51 }
let SCISSOR_TEST: Capability = Capability{ 0x0C11 }
let STENCIL_TEST: Capability = Capability{ 0x0B90 }
let TEXTURE_CUBE_MAP_SEAMLESS: Capability = Capability{ 0x884F }
let PROGRAM_POINT_SIZE: Capability = Capability{ 0x8642 }

!symbol("glEnable") !nogc
extern enable(cap: Capability)

!symbol("glIsEnabled") !nogc
extern is_enabled(cap: Capability): bool

!symbol("glDisable") !nogc
extern disable(cap: Capability)


--
-- Cull
--

type CullMode = uint32

let FRONT: CullMode = CullMode{ 0x0404 }
let BACK: CullMode = CullMode{ 0x0405 }
let FRONT_AND_BACK: CullMode = CullMode{ 0x0405 }

!symbol("glCullFace") !nogc
extern cull_face(mode: CullMode)


--
-- Front Face
--

type FrontFaceMode = uint32

let CW: FrontFaceMode = FrontFaceMode{ 0x0900 }
let CCW: FrontFaceMode = FrontFaceMode{ 0x0901 }

!symbol("glFrontFace") !nogc
extern front_face(mode: FrontFaceMode)


--
-- Shader
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


--
-- UNIFORM
--

type Uniform = int where
    fn is_valid(): bool
        return self.alias ~= -1
    end
end

!symbol("glGetUniformLocation") !nogc
extern get_uniform_location(program: Program, name: String): Uniform

!symbol("glUniform4fv") !nogc
extern uniform4fv(location: Uniform, count: int, value: [float])

!symbol("glUniform1f") !nogc
extern uniform1f(location: Uniform, value: float)

!symbol("glUniform2f") !nogc
extern uniform2f(location: Uniform, value1: float, value2: float)

!symbol("glUniform1i") !nogc
extern uniform1i(location: Uniform, value: int)

!symbol("glUniformMatrix4fv") !nogc
extern uniform_matrix4fv(location: Uniform, count: int, transpose: bool, value: matrix.Matrix)


--
-- BUFFER
--

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


type VertexArrayObject = uint32

let NULL_VAO: VertexArrayObject = VertexArrayObject{ 0u32 }

!symbol("glGenVertexArrays") !nogc
local extern gen_vertex_arrays(n: int, buffers: Ptr<VertexArrayObject>)

fn gen_vertex_array(): VertexArrayObject
    let buffer = Ptr<VertexArrayObject>{}
    gen_vertex_arrays(1, buffer)
    return buffer.value
end

!symbol("glBindBuffer") !nogc
extern bind_buffer(target: Target, buffer: Buffer)

!symbol("glBindVertexArray") !nogc
extern bind_vertex_array(vao: VertexArrayObject)

!symbol("glBufferData") !nogc
extern buffer_data(target: Target, size: C.uintptr, data: handle, usage: Usage)

!symbol("glBufferSubData") !nogc
extern buffer_sub_data(target: Target, offset: C.uintptr, size: C.uintptr, data: handle)

!symbol("glBufferData") !nogc
extern buffer_data(target: Target, size: int, data: [byte], usage: Usage)

type Mode = uint32

let POINTS: Mode = Mode{ 0x0000 }
let LINES: Mode = Mode{ 0x0001 }
let LINE_LOOP: Mode = Mode{ 0x0002 }
let LINE_STRIP: Mode = Mode{ 0x0003 }
let TRIANGLES: Mode = Mode{ 0x0004 }
let TRIANGLE_STRIP: Mode = Mode{ 0x0005 }
let TRIANGLE_FAN: Mode = Mode{ 0x0006 }
let LINES_ADJACENCY: Mode = Mode{ 0x000A }
let LINE_STRIP_ADJACENCY: Mode = Mode{ 0x000B }
let TRIANGLES_ADJACENCY: Mode = Mode{ 0x000C }
let TRIANGLE_STRIP_ADJACENCY: Mode = Mode{ 0x000D }
let PATCHES: Mode = Mode{ 0x000E }

!symbol("glDrawArrays") !nogc
extern draw_arrays(mode: Mode, first: uint32, count: int)

!symbol("glEnableVertexAttribArray") !nogc
extern enable_vertex_attrib_array(index: int)

!symbol("glDisableVertexAttribArray") !nogc
extern disable_vertex_attrib_array(index: int)

!symbol("glVertexAttribPointer") !nogc
extern vertex_attrib_pointer(index: uint32, size: uint32, typ: Type, normalized: bool, stride: int, pointer: C.uintptr)

!symbol("glVertexAttribIPointer") !nogc
extern vertex_attrib_i_pointer(index: uint32, size: uint32, typ: Type, normalized: bool, stride: int, pointer: C.uintptr)


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
-- BUFFER (again?)
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
