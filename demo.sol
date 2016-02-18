module demo

require io
require math

------------------------------------------------------------------
-- Structs
value struct StringArray
   local arr: [byte]
end
-- typedef StringArray [byte]

-- value struct FloatArray
--     local data : [float]
--     local capacity : int
--     local size : int
-- end

struct WrapPointer
    local ptr : uint64
end

struct WrapUInt64
    local val : uint64
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

struct FMOD_CREATESOUNDEXINFO
    local cbsize : int;             -- [w] Size of this structure.  This is used so the structure can be expanded in the future and still work on older versions of FMOD Ex. */
    local length : uint32;             -- [w] Optional. Specify 0 to ignore. Size in bytes of file to load, or sound to create (in this case only if FMOD_OPENUSER is used).  Required if loading from memory.  If 0 is specified, then it will use the size of the file (unless loading from memory then an error will be returned). */
    local fileoffset : uint32;         -- [w] Optional. Specify 0 to ignore. Offset from start of the file to start loading from.  This is useful for loading files from inside big data files. */
    local numchannels : int;        -- [w] Optional. Specify 0 to ignore. Number of channels in a sound mandatory if FMOD_OPENUSER or FMOD_OPENRAW is used. */
    local defaultfrequency : int;   -- [w] Optional. Specify 0 to ignore. Default frequency of sound in a sound mandatory if FMOD_OPENUSER or FMOD_OPENRAW is used.  Other formats use the frequency determined by the file format. */
    local format : uint64;             -- [w] Optional. Specify 0 or FMOD_SOUND_FORMAT_NONE to ignore. Format of the sound mandatory if FMOD_OPENUSER or FMOD_OPENRAW is used.  Other formats use the format determined by the file format.   */
    local decodebuffersize : uint32;   -- [w] Optional. Specify 0 to ignore. For streams.  This determines the size of the double buffer (in PCM samples) that a stream uses.  Use this for user created streams if you want to determine the size of the callback buffer passed to you.  Specify 0 to use FMOD's default size which is currently equivalent to 400ms of the sound format created/loaded. */
    local initialsubsound : int;    -- [w] Optional. Specify 0 to ignore. In a multi-sample file format such as .FSB/.DLS/.SF2, specify the initial subsound to seek to, only if FMOD_CREATESTREAM is used. */
    local numsubsounds : int;       -- [w] Optional. Specify 0 to ignore or have no subsounds.  In a sound created with FMOD_OPENUSER, specify the number of subsounds that are accessable with Sound::getSubSound.  If not created with FMOD_OPENUSER, this will limit the number of subsounds loaded within a multi-subsound file.  If using FSB, then if FMOD_CREATESOUNDEXINFO::inclusionlist is used, this will shuffle subsounds down so that there are not any gaps.  It will mean that the indices of the sounds will be different. */
    local inclusionlist : uint32;      -- [w] Optional. Specify 0 to ignore. In a multi-sample format such as .FSB/.DLS/.SF2 it may be desirable to specify only a subset of sounds to be loaded out of the whole file.  This is an array of subsound indices to load into memory when created. */
    local inclusionlistnum : int;   -- [w] Optional. Specify 0 to ignore. This is the number of integers contained within the inclusionlist array. */
    local pcmreadcallback : uint64;    -- [w] Optional. Specify 0 to ignore. Callback to 'piggyback' on FMOD's read functions and accept or even write PCM data while FMOD is opening the sound.  Used for user sounds created with FMOD_OPENUSER or for capturing decoded data as FMOD reads it. */
    local pcmsetposcallback : uint64;  -- [w] Optional. Specify 0 to ignore. Callback for when the user calls a seeking function such as Channel::setTime or Channel::setPosition within a multi-sample sound, and for when it is opened.*/
    local nonblockcallback : uint64;   -- [w] Optional. Specify 0 to ignore. Callback for successful completion, or error while loading a sound that used the FMOD_NONBLOCKING flag.  Also called duing seeking, when setPosition is called or a stream is restarted. */
    local dlsname : String;            -- [w] Optional. Specify 0 to ignore. Filename for a DLS or SF2 sample set when loading a MIDI file. If not specified, on Windows it will attempt to open /windows/system32/drivers/gm.dls or /windows/system32/drivers/etc/gm.dls, on Mac it will attempt to load /System/Library/Components/CoreAudio.component/Contents/Resources/gs_instruments.dls, otherwise the MIDI will fail to open. Current DLS support is for level 1 of the specification. */
    local encryptionkey : String;      -- [w] Optional. Specify 0 to ignore. Key for encrypted FSB file.  Without this key an encrypted FSB file will not load. */
    local maxpolyphony : int;       -- [w] Optional. Specify 0 to ignore. For sequenced formats with dynamic channel allocation such as .MID and .IT, this specifies the maximum voice count allowed while playing.  .IT defaults to 64.  .MID defaults to 32. */
    local userdata : uint64;           -- [w] Optional. Specify 0 to ignore. This is user data to be attached to the sound during creation.  Access via Sound::getUserData.  Note: This is not passed to FMOD_FILE_OPENCALLBACK, that is a different userdata that is file specific. */
    local suggestedsoundtype : uint64; -- [w] Optional. Specify 0 or FMOD_SOUND_TYPE_UNKNOWN to ignore.  Instead of scanning all codec types, use this to speed up loading by making it jump straight to this codec. */
    local useropen : uint64;           -- [w] Optional. Specify 0 to ignore. Callback for opening this file. */
    local userclose : uint64;          -- [w] Optional. Specify 0 to ignore. Callback for closing this file. */
    local userread : uint64;           -- [w] Optional. Specify 0 to ignore. Callback for reading from this file. */
    local userseek : uint64;           -- [w] Optional. Specify 0 to ignore. Callback for seeking within this file. */
    local userasyncread : uint64;      -- [w] Optional. Specify 0 to ignore. Callback for seeking within this file. */
    local userasynccancel : uint64;    -- [w] Optional. Specify 0 to ignore. Callback for seeking within this file. */
    local speakermap : uint64;         -- [w] Optional. Specify 0 to ignore. Use this to differ the way fmod maps multichannel sounds to speakers.  See FMOD_SPEAKERMAPTYPE for more. */
    local initialsoundgroup : uint64;  -- [w] Optional. Specify 0 to ignore. Specify a sound group if required, to put sound in as it is created. */
    local initialseekposition : uint32;-- [w] Optional. Specify 0 to ignore. For streams. Specify an initial position to seek the stream to. */
    local initialseekpostype : uint64; -- [w] Optional. Specify 0 to ignore. For streams. Specify the time unit for the position set in initialseekposition. */
    local ignoresetfilesystem : int;-- [w] Optional. Specify 0 to ignore. Set to 1 to use fmod's built in file system. Ignores setFileSystem callbacks and also FMOD_CREATESOUNEXINFO file callbacks.  Useful for specific cases where you don't want to use your own file system but want to use fmod's file system (ie net streaming). */
    local cddaforceaspi : int;      -- [w] Optional. Specify 0 to ignore. For CDDA sounds only - if non-zero use ASPI instead of NTSCSI to access the specified CD/DVD device. */
    local audioqueuepolicy : uint32;   -- [w] Optional. Specify 0 or FMOD_AUDIOQUEUE_CODECPOLICY_DEFAULT to ignore. Policy used to determine whether hardware or software is used for decoding, see FMOD_AUDIOQUEUE_CODECPOLICY for options (iOS >= 3.0 required, otherwise only hardware is available) */
    local minmidigranularity : uint32; -- [w] Optional. Specify 0 to ignore. Allows you to set a minimum desired MIDI mixer granularity. Values smaller than 512 give greater than default accuracy at the cost of more CPU and vice versa. Specify 0 for default (512 samples). */
    local nonblockthreadid : int;   -- [w] Optional. Specify 0 to ignore. Specifies a thread index to execute non blocking load on.  Allows for up to 5 threads to be used for loading at once.  This is to avoid one load blocking another.  Maximum value = 4. */
end

------------------------------------------------------------------
-- External APIs

-- GLFW
extern glfwInit():int
extern glfwCreateWindow(  width : int, height : int, title:String, monitor : uint64, share : uint64 ) : uint64
extern glfwShowWindow( window : uint64 )
extern glfwTerminate()
extern glfwSwapBuffers( window : uint64 )
extern glfwPollEvents()
extern glfwWindowShouldClose( window : uint64 ) : int
extern glfwSetWindowShouldClose( window : uint64, int )
extern glfwWindowHint( target : uint32, hint : uint32 )

extern glfwGetMouseButton(window : uint64, button : int ) : int
extern glfwGetFramebufferSize(window : uint64, width : [int], height : [int] )
extern glfwGetWindowSize(window : uint64, width : [int], height : [int] )
extern glfwGetTime() : double

-- OpenGL
extern glGetError() : uint32
extern glViewport( x : int, y : int, width : int, height : int )
extern glClear( mask : uint32 )
extern glClearColor( red : float, green : float, blue : float, alpha : float )
extern glEnable( cap : uint32 )
extern glDisable( cap : uint32 )
extern glBlendFunc( sfactor : uint32, dfactor : uint32 )

-- OGL: Shaders
extern glCreateShader( shaderType : uint32 ) : uint32
extern glCreateProgram() : uint32
-- !nogc extern glShaderSource( shader : uint32, count : uint64, lines : [String], length : [uint32] )
extern glShaderSource( shader : uint32, count : uint64, lines : [String], length : uint32 )
extern glCompileShader( shader : uint32 )
extern glAttachShader( program : uint32, shader : uint32 )
extern glLinkProgram( program : uint32 )
extern glUseProgram( program : uint32 )
extern glIsShader( obj : uint32 ) : bool
extern glGetShaderiv( shader : uint32, pname : uint32, params : [int])
extern glGetProgramiv( shader : uint32, pname : uint32, params : [int])
extern glGetShaderInfoLog( shader : uint32, maxLength : int, length : [int], infoLog : [byte])
extern glGetProgramInfoLog( shader : uint32, maxLength : int, length : [int], infoLog : [byte])
extern glGetUniformLocation( program : uint32, name : String) : int
extern glUniform4fv( location : int, count : int, value : [float] )
extern glUniform1f( location : int, v0 : float )
extern glUniform1i( location : int, v0 : int )
extern glUniformMatrix4fv( location : int, count : int, transpose : bool, value : [float] )

-- OGL: Geometry
extern glGenBuffers( n : int, buffers : [uint32] )
extern glGenVertexArrays( n : int, buffers : [uint32] )
extern glBindBuffer( target: uint32, buffer : uint32 )
extern glBindVertexArray( array : uint32 )
extern glBufferData( target : uint32, size : int, data : [float], usage : uint32)
extern glBufferData( target : uint32, size : int, data : [byte], usage : uint32)
-- extern glBufferData( target : uint32, size : int, data : [byte], usage : uint32)
extern glDrawArrays( mode : uint32, first : uint32, count : int )
extern glEnableVertexAttribArray( index : int )
extern glDisableVertexAttribArray( index : int )
extern glVertexAttribPointer( index : uint32, size : int, type : uint32, normalized : bool, stride : int, pointer : int )

-- OGL: Textures
extern glGenTextures( n : int, textures : [uint32] )
extern glBindTexture( target : uint32, texture : uint32)
extern glTexImage2D( target : uint32, level : int, internalFormat : uint32, width : int, height : int, border : int, format : uint32, type : uint32, data : uint32) -- for empty textures
extern glTexImage2D( target : uint32, level : int, internalFormat : uint32, width : int, height : int, border : int, format : uint32, type : uint32, data : [byte])
extern glTexImage2D( target : uint32, level : int, internalFormat : uint32, width : int, height : int, border : int, format : uint32, type : uint32, data : [float])
extern glTexParameteri( target : uint32, pname : uint32, param : uint32 )

-- OGL: FBO
extern glGenRenderbuffers( n : int, renderbuffers : [uint32] )
extern glBindRenderbuffer( target : uint32, renderbuffer : uint32)
extern glRenderbufferStorage( target : uint32, internalformat : uint32, width : int, height : int)
extern glGenFramebuffers( n : int, framebuffers : [uint32] )
extern glBindFramebuffer( target : uint32, framebuffer : uint32)
extern glFramebufferRenderbuffer(  target : uint32, attachment : uint32, renderbuffertarget : uint32, renderbuffer : uint32)
extern glFramebufferTexture( target : uint32, attachment : uint32, texture : uint32, level : int )
extern glDrawBuffers( n : int, bufs : [uint32] )
extern glCheckFramebufferStatus( target : uint32 ) : uint32


-- FMOD: Core
-- function FMOD_ErrorString(errcode : uint64) : String
extern FMOD_System_Create(system : [@WrapPointer]) : uint64
extern FMOD_System_Init(system : uint64, maxchannels : int, flags : uint64, extradriverdata : uint64) : uint64
extern FMOD_System_CreateSound(system : uint64, path : String, mode : uint64, exinfo : uint64, sound : [@WrapPointer]) : uint64
extern FMOD_System_PlaySound(system : uint64, channelid : int, sound : uint64, paused : bool, channel : [@WrapPointer]) : uint64
extern FMOD_Channel_GetPosition(channelid : uint64, ms : [@WrapUInt64], timeunit : uint64);

-- C Std funcs
extern fopen( filename: String, mode: String) : uint64
extern fseek( stream : uint64, offset : int64, whence : int ) : int
extern ftell( stream : uint64 ) : int
extern fclose( stream : uint64 ) : int
extern fread( ptr : [byte], size : int, count : int, stream : uint64) : int64
extern chdir(path : String) : int
extern rand() : int


-----------------------------------------------------------------------
-- Defines/enums
local GLFW_CONTEXT_VERSION_MAJOR : uint32 = 0x00022002u32
local GLFW_CONTEXT_VERSION_MINOR : uint32 = 0x00022003u32
local GLFW_OPENGL_FORWARD_COMPAT : uint32 = 0x00022006u32
local GLFW_OPENGL_PROFILE        : uint32 = 0x00022008u32
local GLFW_OPENGL_CORE_PROFILE   : uint32 = 0x00032001u32

local GL_FALSE : uint32 = 0x0u32
local GL_TRUE  : uint32 = 0x1u32

local GL_FLOAT : uint32 = 0x1406u32
local GL_BYTE  : uint32 = 0x1400u32

local GL_COLOR_BUFFER_BIT : uint32 = 0x4000u32
local GL_BLEND            : uint32 = 0x0BE2u32
local GL_ALPHA_TEST       : uint32 = 0x0BC0u32
local GL_DEPTH_TEST       : uint32 = 0x0B71u32
local GL_CULL_FACE        : uint32 = 0x0B44u32


local GL_ZERO                : uint32 = 0u32
local GL_ONE                 : uint32 = 1u32
local GL_SRC_COLOR           : uint32 = 0x0300u32
local GL_ONE_MINUS_SRC_COLOR : uint32 = 0x0301u32
local GL_SRC_ALPHA           : uint32 = 0x0302u32
local GL_ONE_MINUS_SRC_ALPHA : uint32 = 0x0303u32
local GL_DST_ALPHA           : uint32 = 0x0304u32
local GL_ONE_MINUS_DST_ALPHA : uint32 = 0x0305u32

local GL_FRAGMENT_SHADER  : uint32 = 0x8B30u32
local GL_VERTEX_SHADER    : uint32 = 0x8B31u32

local GL_INFO_LOG_LENGTH  : uint32 = 0x8B84u32

local GL_ARRAY_BUFFER     : uint32 = 0x8892u32
local GL_STATIC_DRAW      : uint32 = 0x88E4u32
local GL_TRIANGLES        : uint32 = 0x0004u32

local GL_TEXTURE_2D       : uint32 = 0x0DE1u32
local GL_RGBA             : uint32 = 0x1908u32
local GL_UNSIGNED_BYTE    : uint32 = 0x1401u32
local GL_LUMINANCE        : uint32 = 0x1901u32
local GL_ALPHA            : uint32 = 0x1906u32
local GL_R32F             : uint32 = 0x822Eu32
local GL_RED              : uint32 = 0x1903u32

local GL_TEXTURE_MAG_FILTER : uint32 = 0x2800u32
local GL_TEXTURE_MIN_FILTER : uint32 = 0x2801u32
local GL_NEAREST            : uint32 = 0x2600u32
local GL_LINEAR             : uint32 = 0x2601u32

local GL_FRAMEBUFFER       : uint32 = 0x8D40u32
local GL_RENDERBUFFER      : uint32 = 0x8D41u32
local GL_DEPTH_COMPONENT   : uint32 = 0x1902u32
local GL_DEPTH_ATTACHMENT  : uint32 = 0x8D00u32
local GL_COLOR_ATTACHMENT0 : uint32 = 0x8CE0u32
local GL_FRAMEBUFFER_COMPLETE : uint32 = 0x8CD5u32

local SEEK_SET            : int = 0
local SEEK_CUR            : int = 1
local SEEK_END            : int = 2

local RAND_MAX            : int = 2147483647

--
local window : uint64

local FMOD_OK             : uint64 = 0u64
local FMOD_ERR_ALREADYLOCKED : uint64          = 1u64
local FMOD_ERR_BADCOMMAND : uint64             = 2u64
local FMOD_ERR_CDDA_DRIVERS : uint64           = 3u64
local FMOD_ERR_CDDA_INIT : uint64              = 4u64
local FMOD_ERR_CDDA_INVALID_DEVICE : uint64    = 5u64
local FMOD_ERR_CDDA_NOAUDIO : uint64           = 6u64
local FMOD_ERR_CDDA_NODEVICES : uint64         = 7u64
local FMOD_ERR_CDDA_NODISC : uint64            = 8u64
local FMOD_ERR_CDDA_READ : uint64              = 9u64
local FMOD_ERR_CHANNEL_ALLOC : uint64          = 10u64
local FMOD_ERR_CHANNEL_STOLEN : uint64         = 11u64
local FMOD_ERR_COM : uint64                    = 12u64
local FMOD_ERR_DMA : uint64                    = 13u64
local FMOD_ERR_DSP_CONNECTION : uint64         = 14u64
local FMOD_ERR_DSP_FORMAT : uint64             = 15u64
local FMOD_ERR_DSP_NOTFOUND : uint64           = 16u64
local FMOD_ERR_DSP_RUNNING : uint64            = 17u64
local FMOD_ERR_DSP_TOOMANYCONNECTIONS : uint64 = 18u64
local FMOD_ERR_FILE_BAD : uint64               = 19u64
local FMOD_ERR_FILE_COULDNOTSEEK : uint64      = 20u64
local FMOD_ERR_FILE_DISKEJECTED : uint64       = 21u64
local FMOD_ERR_FILE_EOF : uint64               = 22u64
local FMOD_ERR_FILE_NOTFOUND : uint64          = 23u64
local FMOD_ERR_FILE_UNWANTED : uint64          = 24u64
local FMOD_ERR_FORMAT : uint64                 = 25u64
local FMOD_ERR_HTTP : uint64                   = 26u64
local FMOD_ERR_HTTP_ACCESS : uint64            = 27u64
local FMOD_ERR_HTTP_PROXY_AUTH : uint64        = 28u64
local FMOD_ERR_HTTP_SERVER_ERROR : uint64      = 29u64
local FMOD_ERR_HTTP_TIMEOUT : uint64           = 30u64
local FMOD_ERR_INITIALIZATION : uint64         = 31u64
local FMOD_ERR_INITIALIZED : uint64            = 32u64
local FMOD_ERR_INTERNAL : uint64               = 33u64
local FMOD_ERR_INVALID_ADDRESS : uint64        = 34u64
local FMOD_ERR_INVALID_FLOAT : uint64          = 35u64
local FMOD_ERR_INVALID_HANDLE : uint64         = 36u64
local FMOD_ERR_INVALID_PARAM : uint64          = 37u64
local FMOD_ERR_INVALID_POSITION : uint64       = 38u64
local FMOD_ERR_INVALID_SPEAKER : uint64        = 39u64
local FMOD_ERR_INVALID_SYNCPOINT : uint64      = 40u64
local FMOD_ERR_INVALID_VECTOR : uint64         = 41u64
local FMOD_ERR_MAXAUDIBLE : uint64             = 42u64
local FMOD_ERR_MEMORY : uint64                 = 43u64
local FMOD_ERR_MEMORY_CANTPOINT : uint64       = 44u64
local FMOD_ERR_MEMORY_SRAM : uint64            = 45u64
local FMOD_ERR_NEEDS2D : uint64                = 46u64
local FMOD_ERR_NEEDS3D : uint64                = 47u64
local FMOD_ERR_NEEDSHARDWARE : uint64          = 48u64
local FMOD_ERR_NEEDSSOFTWARE : uint64          = 49u64
local FMOD_ERR_NET_CONNECT : uint64            = 50u64
local FMOD_ERR_NET_SOCKET_ERROR : uint64       = 51u64
local FMOD_ERR_NET_URL : uint64                = 52u64
local FMOD_ERR_NET_WOULD_BLOCK : uint64        = 53u64
local FMOD_ERR_NOTREADY : uint64               = 54u64
local FMOD_ERR_OUTPUT_ALLOCATED : uint64       = 55u64
local FMOD_ERR_OUTPUT_CREATEBUFFER : uint64    = 56u64
local FMOD_ERR_OUTPUT_DRIVERCALL : uint64      = 57u64
local FMOD_ERR_OUTPUT_ENUMERATION : uint64     = 58u64
local FMOD_ERR_OUTPUT_FORMAT : uint64          = 59u64
local FMOD_ERR_OUTPUT_INIT : uint64            = 60u64
local FMOD_ERR_OUTPUT_NOHARDWARE : uint64      = 61u64
local FMOD_ERR_OUTPUT_NOSOFTWARE : uint64      = 62u64
local FMOD_ERR_PAN : uint64                    = 63u64
local FMOD_ERR_PLUGIN : uint64                 = 64u64
local FMOD_ERR_PLUGIN_INSTANCES : uint64       = 65u64
local FMOD_ERR_PLUGIN_MISSING : uint64         = 66u64
local FMOD_ERR_PLUGIN_RESOURCE : uint64        = 67u64
local FMOD_ERR_PRELOADED : uint64              = 68u64
local FMOD_ERR_PROGRAMMERSOUND : uint64        = 69u64
local FMOD_ERR_RECORD : uint64                 = 70u64
local FMOD_ERR_REVERB_INSTANCE : uint64        = 71u64
local FMOD_ERR_SUBSOUND_ALLOCATED : uint64     = 72u64
local FMOD_ERR_SUBSOUND_CANTMOVE : uint64      = 73u64
local FMOD_ERR_SUBSOUND_MODE : uint64          = 74u64
local FMOD_ERR_SUBSOUNDS : uint64              = 75u64
local FMOD_ERR_TAGNOTFOUND : uint64            = 76u64
local FMOD_ERR_TOOMANYCHANNELS : uint64        = 77u64
local FMOD_ERR_UNIMPLEMENTED : uint64          = 78u64
local FMOD_ERR_UNINITIALIZED : uint64          = 79u64
local FMOD_ERR_UNSUPPORTED : uint64            = 80u64
local FMOD_ERR_UPDATE : uint64                 = 81u64
local FMOD_ERR_VERSION : uint64                = 82u64
local FMOD_ERR_EVENT_FAILED : uint64           = 83u64
local FMOD_ERR_EVENT_INFOONLY : uint64         = 84u64
local FMOD_ERR_EVENT_INTERNAL : uint64         = 85u64
local FMOD_ERR_EVENT_MAXSTREAMS : uint64       = 86u64
local FMOD_ERR_EVENT_MISMATCH : uint64         = 87u64
local FMOD_ERR_EVENT_NAMECONFLICT : uint64     = 88u64
local FMOD_ERR_EVENT_NOTFOUND : uint64         = 89u64
local FMOD_ERR_EVENT_NEEDSSIMPLE : uint64      = 90u64
local FMOD_ERR_EVENT_GUIDCONFLICT : uint64     = 91u64
local FMOD_ERR_EVENT_ALREADY_LOADED : uint64   = 92u64
local FMOD_ERR_MUSIC_UNINITIALIZED : uint64    = 93u64
local FMOD_ERR_MUSIC_NOTFOUND : uint64         = 94u64
local FMOD_ERR_MUSIC_NOCALLBACK : uint64       = 95u64

local FMOD_DEFAULT                   : uint64 = 0x00000000u64
local FMOD_LOOP_OFF                  : uint64 = 0x00000001u64
local FMOD_LOOP_NORMAL               : uint64 = 0x00000002u64
local FMOD_LOOP_BIDI                 : uint64 = 0x00000004u64
local FMOD_2D                        : uint64 = 0x00000008u64
local FMOD_3D                        : uint64 = 0x00000010u64
local FMOD_HARDWARE                  : uint64 = 0x00000020u64
local FMOD_SOFTWARE                  : uint64 = 0x00000040u64
local FMOD_CREATESTREAM              : uint64 = 0x00000080u64
local FMOD_CREATESAMPLE              : uint64 = 0x00000100u64
local FMOD_CREATECOMPRESSEDSAMPLE    : uint64 = 0x00000200u64
local FMOD_OPENUSER                  : uint64 = 0x00000400u64
local FMOD_OPENMEMORY                : uint64 = 0x00000800u64
local FMOD_OPENMEMORY_POINT          : uint64 = 0x10000000u64
local FMOD_OPENRAW                   : uint64 = 0x00001000u64
local FMOD_OPENONLY                  : uint64 = 0x00002000u64
local FMOD_ACCURATETIME              : uint64 = 0x00004000u64
local FMOD_MPEGSEARCH                : uint64 = 0x00008000u64
local FMOD_NONBLOCKING               : uint64 = 0x00010000u64
local FMOD_UNIQUE                    : uint64 = 0x00020000u64
local FMOD_3D_HEADRELATIVE           : uint64 = 0x00040000u64
local FMOD_3D_WORLDRELATIVE          : uint64 = 0x00080000u64
local FMOD_3D_INVERSEROLLOFF         : uint64 = 0x00100000u64
local FMOD_3D_LINEARROLLOFF          : uint64 = 0x00200000u64
local FMOD_3D_LINEARSQUAREROLLOFF    : uint64 = 0x00400000u64
local FMOD_3D_CUSTOMROLLOFF          : uint64 = 0x04000000u64
local FMOD_3D_IGNOREGEOMETRY         : uint64 = 0x40000000u64
local FMOD_UNICODE                   : uint64 = 0x01000000u64
local FMOD_IGNORETAGS                : uint64 = 0x02000000u64
local FMOD_LOWMEM                    : uint64 = 0x08000000u64
local FMOD_LOADSECONDARYRAM          : uint64 = 0x20000000u64
local FMOD_VIRTUAL_PLAYFROMSTART     : uint64 = 0x80000000u64

------------------------------------------------------------------------
-- Helpers
function ERROR_LUT( id : uint32 ) : String
    if (id == 0u32) then
        return "GL_NO_ERROR"
    elseif (id == 0x0500u32) then
        return "GL_INVALID_ENUM"                   -- 0x0500
    elseif (id == 0x0501u32) then
        return "GL_INVALID_VALUE"                  -- 0x0501
    elseif (id == 0x0502u32) then
        return "GL_INVALID_OPERATION"              -- 0x0502
    end

    return "unknown"
end

function log_error( id : String )
    io.println( "[ \x1B[31m!!\x1B[0m ] " .. id )
end

function log_ok( id : String )
    io.println( "[ \x1B[32mok\x1B[0m ] " .. id )
end

function random() : float
    return rand() as float / RAND_MAX as float
end


function check_error( id : String, print_on_ok : bool ) : bool
    local err = glGetError()
    if ( err ~= 0u32 ) then
        log_error( id .. " - Error: " .. ERROR_LUT(err) )
        return false
    end

    if (print_on_ok) then
        log_ok(id)
    end
    return true
end

function shader_log( obj : uint32 )
    local size:[int] = [200:int]
    if glIsShader(obj) then
        glGetShaderiv( obj, GL_INFO_LOG_LENGTH, size )
    else
        glGetProgramiv( obj, GL_INFO_LOG_LENGTH, size )
    end
    if size[0] == 0 then
        return
    end

    local sub_sizes:[int] = [1:int]
    local data:[byte] = [size[0]:byte]
    if glIsShader(obj) then
        glGetShaderInfoLog( obj, size[0], sub_sizes, data)
    else
        glGetProgramInfoLog( obj, size[0], sub_sizes, data)
    end

    io.println("Shader log:\n" .. string(data) )
end

function read_file( file_path : String ) : [byte]
    local f = fopen(file_path, "r")

    if (f ~= 0u64) then
        fseek( f, 0i64, SEEK_END )
        local len : int = ftell( f ) + 1
        local ret : [byte] = [len:byte]
        fseek(f, 0i64, SEEK_SET)
        -- FIXME make sure we read the whole file...
        fread( ret, 1, len, f )
        fclose( f );

        -- make sure we null term
        ret[len-1] = 0u8

        log_ok( "read " .. file_path )

        return ret
    else
        log_error( "could not open " .. file_path )
    end

    local ret : [byte]
    return ret
end

function read_file_as_string( file_path : String ) : String
    return string(read_file(file_path))
end

------------------------------------------------------------------------
-- "Resources"
function create_texture( width : int, height : int, data : [byte] ) : uint32
    local textures : [uint32] = [1:uint32]
    glGenTextures( 1, textures )
    check_error("creating texture", true )
    local texture : uint32 = textures[0]

    glBindTexture( GL_TEXTURE_2D, texture )
    check_error("bound texture", false )

    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )

    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data )
    check_error("uploaded texture data", true )

    glBindTexture( GL_TEXTURE_2D, 0u32 )
    check_error("unbound texture", false )

    return texture
end

function create_empty_texture( width : int, height : int ) : uint32
    local textures : [uint32] = [1:uint32]
    glGenTextures(1, textures )
    check_error("creating empty texture", true )
    local texture : uint32 = textures[0]

    glBindTexture( GL_TEXTURE_2D, texture )
    check_error("bind texture", true )

    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )

    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0u32 )
    check_error("upload empty texture", true )

    glBindTexture( GL_TEXTURE_2D, 0u32 )
    check_error("unbound texture", true )

    return texture
end

function create_fbo( width : int, height : int, attach_depth : bool ) : uint32, uint32

    io.print(width)
    io.print(height)

    local framebuffers : [uint32] = [1:uint32]
    glGenFramebuffers( 1, framebuffers )
    check_error("creating fbo", true )

    local fbo : uint32 = framebuffers[0]
    glBindFramebuffer( GL_FRAMEBUFFER, fbo )

    -- gen empty texture
    local texture = create_empty_texture( width, height )

    local depthbuffers : [uint32] = [1:uint32]
    glGenRenderbuffers( 1, depthbuffers )
    local depthbuffer : uint32 = depthbuffers[0]
    check_error("creating depth buffer", true )
    glBindRenderbuffer( GL_RENDERBUFFER, depthbuffer )
    glRenderbufferStorage( GL_RENDERBUFFER, GL_DEPTH_COMPONENT, width, height )
    check_error("binding depth buffer", true )
    glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbuffer )
    check_error("binding texture", true )
    glFramebufferTexture( GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, texture, 0 );


    local fbo_status : uint32 = glCheckFramebufferStatus( GL_FRAMEBUFFER )
    if (fbo_status ~= GL_FRAMEBUFFER_COMPLETE) then
        log_error("fbo is not complete!")
    else
        log_ok("fbo is complete")
    end
    glBindFramebuffer( GL_FRAMEBUFFER, 0u32 )

    return fbo, texture

end

function render_to_fbo( fbo : uint32 )
    glBindFramebuffer( GL_FRAMEBUFFER, fbo )
    check_error("binding fbo", false )

    if (fbo ~= 0u32) then
        local drawbuffers : [uint32] = [GL_COLOR_ATTACHMENT0];
        glDrawBuffers( 1, drawbuffers )
        check_error("drawing to fbo", false )
    end
end

-- function create_mesh_from_file( path : String ) : uint32

--     local raw_data : [byte] = read_file( path )

--     io.println(#raw_data)

--     -- generate gl buffers
--     local buffers : [uint32] = [1:uint32]
--     glGenBuffers(1, buffers)
--     local vert_gl = buffers[0]

--     local vao : [uint32] = [1:uint32]
--     glGenVertexArrays( 1, vao )
--     local vao_obj = vao[0]

--     glBindVertexArray(vao_obj)
--     glEnableVertexAttribArray( 0 )
--     glBindBuffer( GL_ARRAY_BUFFER, vert_gl )
--     glBufferData( GL_ARRAY_BUFFER, #raw_data, raw_data, GL_STATIC_DRAW )
--     glVertexAttribPointer(0u32, 3, GL_FLOAT, false, 0, 0)
--     glBindVertexArray(0u32)

--     return vao_obj

-- end

function create_quad_batch( capacity : int ) : QuadBatch
    local qb : QuadBatch = QuadBatch { vert_gl  = 0u32,
                                       uv_gl    = 0u32,
                                       vert_buf = [capacity*3*6:float],
                                       uv_buf   = [capacity*2*6:float],
                                       capacity = capacity,
                                       cursor   = 0 }

    -- generate gl buffers
    local buffers : [uint32] = [2:uint32]
    glGenBuffers(2, buffers)
    qb.vert_gl = buffers[0]
    qb.uv_gl   = buffers[1]

    local vao : [uint32] = [1:uint32]
    glGenVertexArrays( 1, vao )
    qb.vao = vao[0]

    glBindVertexArray(qb.vao)
    glEnableVertexAttribArray( 0 )
    glBindBuffer( GL_ARRAY_BUFFER, qb.vert_gl )
    glVertexAttribPointer(0u32, 3, GL_FLOAT, false, 0, 0)
    glBindVertexArray(0u32)

    return qb
end

function qb_begin( qb : QuadBatch )
    qb.cursor = 0
end

function qb_end( qb : QuadBatch )

    local i : int = qb.cursor*3*6

    glBindVertexArray(qb.vao)

    glEnableVertexAttribArray( 0 )
    glBindBuffer( GL_ARRAY_BUFFER, qb.vert_gl )
    check_error( "qb_render: binding vert buffer", false )
    glBufferData( GL_ARRAY_BUFFER, i*4, qb.vert_buf, GL_STATIC_DRAW )
    check_error( "qb_render: upload vert buffer", false )
    glVertexAttribPointer(0u32, 3, GL_FLOAT, false, 0, 0)

    glEnableVertexAttribArray( 1 )
    glBindBuffer( GL_ARRAY_BUFFER, qb.uv_gl )
    check_error( "qb_render: binding uv buffer", false )
    glBufferData( GL_ARRAY_BUFFER, i*4, qb.uv_buf, GL_STATIC_DRAW )
    check_error( "qb_render: upload uv buffer", false )
    glVertexAttribPointer(1u32, 2, GL_FLOAT, false, 0, 0)

    glBindVertexArray(0u32)
end

function qb_render( qb : QuadBatch )


    glBindVertexArray(qb.vao)
    glDrawArrays( GL_TRIANGLES, 0u32, qb.cursor*6 );


end

function qb_add( qb : QuadBatch, x0 : float, y0 : float, x1 : float, y1 : float, u0 : float, v0 : float, u1 : float, v1 : float)

    --[[

    d - c
    | / |
    a - b

    ]]--

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

function qb_write( qb : QuadBatch, where_pos:int, x : float, y : float, z : float)
    qb.vert_buf[where_pos + 0] = x
    qb.vert_buf[where_pos + 1] = y
    qb.vert_buf[where_pos + 2] = z
end

function qb_write_cube_side(qb : QuadBatch, where_pos:int, where_uv:int, x:float, y:float, z:float, ux:float, uy:float, uz:float, vx:float, vy:float, vz:float, u:float, v:float)
    qb_write(qb, where_pos + 0, x - ux - vx, y - uy - vy, z - uz - vz);
    qb_write(qb, where_pos + 3, x + ux - vx, y + uy - vy, z + uz - vz);
    qb_write(qb, where_pos + 6, x + ux + vx, y + uy + vy, z + uz + vz);
    qb_write(qb, where_pos + 9, x - ux - vx, y - uy - vy, z - uz - vz);
    qb_write(qb, where_pos + 12, x + ux + vx, y + uy + vy, z + uz + vz);
    qb_write(qb, where_pos + 15, x - ux + vx, y - uy + vy, z - uz + vz);
    for col=0, 6 do
        qb.uv_buf[where_uv + 2*col + 0] = u
        qb.uv_buf[where_uv + 2*col + 1] = v
    end
end

function qb_write_cube(qb : QuadBatch, x:float, y:float, z:float)
    local szf = 0.50f
    qb_write_cube_side(qb, 3*6*(qb.cursor+0), 2*6*(qb.cursor+0), x + 0.0f, y + 0.0f, z - szf, szf, 0.0f, 0.0f, 0.0f, szf, 0.0f, 1f, 0f);
    qb_write_cube_side(qb, 3*6*(qb.cursor+1), 2*6*(qb.cursor+1), x + 0.0f, y + 0.0f, z + szf,-szf, 0.0f, 0.0f, 0.0f,-szf, 0.0f, 1f, 0f);
    qb_write_cube_side(qb, 3*6*(qb.cursor+2), 2*6*(qb.cursor+2), x + szf, y + 0.0f, z + 0.0f, 0.0f, 0.0f, szf, 0.0f, szf, 0.0f, 0f, 1f);
    qb_write_cube_side(qb, 3*6*(qb.cursor+3), 2*6*(qb.cursor+3), x - szf, y + 0.0f, z + 0.0f, 0.0f, 0.0f,-szf, 0.0f, szf, 0.0f, 0f, 1f);
    qb_write_cube_side(qb, 3*6*(qb.cursor+4), 2*6*(qb.cursor+4), x + 0.0f, y + szf, z + 0.0f, szf, 0.0f, 0.0f, 0.0f, 0.0f, szf, 0f, 0f);
    qb_write_cube_side(qb, 3*6*(qb.cursor+5), 2*6*(qb.cursor+5), x + 0.0f, y - szf, z + 0.0f,-szf, 0.0f, 0.0f, 0.0f, 0.0f,-szf, 0f, 0f);
    qb.cursor = qb.cursor + 6;
end

function qb_write_plusbox(qb:QuadBatch, t:float)
    local s = 100f - 100f*t*t
    --local s = 1.0f - 0.2f * t
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
                    end end end
                end
            end
        end
    end
end

function qb_add_3d( qb : QuadBatch, x0 : float, y0 : float, x1 : float, y1 : float, u0 : float, v0 : float, u1 : float, v1 : float, z:[float])

    --[[

    d - c
    | / |
    a - b

    ]]

    local i : int = qb.cursor*3*6 -- (x,y) * vert_count * triangle_count_per_quad

    -- vertices
    -- tri A: a,b,c
    qb.vert_buf[i+ 1] = y0
    qb.vert_buf[i+ 2] = z[0]
    qb.vert_buf[i+ 0] = x0

    qb.vert_buf[i+ 4] = y0
    qb.vert_buf[i+ 5] = z[1]
    qb.vert_buf[i+ 3] = x1

    qb.vert_buf[i+ 7] = y1
    qb.vert_buf[i+ 8] = z[3]
    qb.vert_buf[i+ 6] = x1

    -- tri B: a,c,d
    qb.vert_buf[i+10] = y0
    qb.vert_buf[i+11] = z[0]
    qb.vert_buf[i+9] = x0

    qb.vert_buf[i+13] = y1
    qb.vert_buf[i+14] = z[3]
    qb.vert_buf[i+12] = x1

    qb.vert_buf[i+16] = y1
    qb.vert_buf[i+17] = z[2]
    qb.vert_buf[i+15] = x0

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

function qb_add_centered( qb : QuadBatch, x : float, y : float, w : float, h : float, u0 : float, v0 : float, u1 : float, v1 : float )

    local wh = w / 2.0f
    local hh = h / 2.0f
    qb_add( qb, x - wh, y - hh, x + wh, y + hh, u0, v0, u1, v1 )

end

function create_quad() : uint32
    local buffers : [uint32] = [1:uint32]
    glGenBuffers( 1, buffers )
    check_error("creating geo buffers", true )
    glBindBuffer( GL_ARRAY_BUFFER, buffers[0] )
    check_error( "binding geo buffers", true )

    local data : [float] = [12:float]
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

    glBufferData( GL_ARRAY_BUFFER, 6*2*4, data, GL_STATIC_DRAW )
    check_error( "loading geo buffers", true )

    local vao : [uint32] = [1:uint32]
    glGenVertexArrays( 1, vao );
    glBindVertexArray(vao[0]);

    glEnableVertexAttribArray( 0 )
    glBindBuffer( GL_ARRAY_BUFFER, buffers[0] )
    glVertexAttribPointer(0u32, 2, GL_FLOAT, false, 0, 0);

    -- return buffers[0]
    return vao[0]
end

function create_shader( vert_src : String, frag_src : String ) : uint32
    local vert = glCreateShader( GL_VERTEX_SHADER )
    local frag = glCreateShader( GL_FRAGMENT_SHADER )
    local shader = glCreateProgram()
    check_error("create programs", true)

    local a : [String] = [1:String]
    a[0] = vert_src
    glShaderSource( vert, 1u64, a, 0u32 )
    check_error("shader vert source", true)
    glCompileShader( vert )
    check_error("shader vert compile", true)
    shader_log( vert )

    local a : [String] = [1:String]
    a[0] = frag_src
    glShaderSource( frag, 1u64, a, 0u32 )
    check_error("shader frag source", true)
    glCompileShader( frag )
    check_error("shader frag compile", true)
    shader_log( frag )

    glAttachShader( shader, vert )
    check_error("shader attach vert", true)
    glAttachShader( shader, frag )
    check_error("shader attach frag", true)

    glLinkProgram( shader )
    check_error("shader link", true)
    shader_log( shader )

    return shader
end

function ortho_matrix( l : float, r : float, b : float, t : float, n : float, f : float ) : [float]
    local mtx : [float] = [16:float]

    --x, y
    mtx[0] = 2.0f/(r-l);
    mtx[1] = 0.0f;
    mtx[2] = 0.0f;
    mtx[3] = -(r+l)/(r-l);

    mtx[4] = 0.0f;
    mtx[5] = 2.0f/(t-b);
    mtx[6] = 0.0f;
    mtx[7] = -(t+b)/(t-b);

    mtx[8] = 0.0f;
    mtx[9] = 0.0f;
    mtx[10] = -2.0f/(f-n);
    mtx[11] = -(f+n)/(f-n);

    mtx[12] = 0.0f;
    mtx[13] = 0.0f;
    mtx[14] = 0.0f;
    mtx[15] = 1.0f;

    return mtx
end

function persp_mtx( l : float, r : float, b : float, t : float, n : float, f : float ) : [float]
    local mtx : [float] = [16:float]

    --x, y
    mtx[0] = 2.0f/(r-l);
    mtx[1] = 0.0f;
    mtx[2] = -(r+l)/(r-l);
    mtx[3] = 0.0f;

    mtx[4] = 0.0f;
    mtx[5] = 2.0f/(t-b);
    mtx[6] = -(t+b)/(t-b);
    mtx[7] = 0.0f;

    mtx[8] = 0.0f;
    mtx[9] = 0.0f;
    mtx[10] = -(f+n)/(n-f);
    mtx[11] = -2.0f*f*n/(n-f);

    mtx[12] = 0.0f;
    mtx[13] = 0.0f;
    mtx[14] = -1.0f;
    mtx[15] = 0.0f;
    return mtx
end


function scale_mtx(x:float, y:float, z:float) : [float]
    local mtx : [float] = [16:float]
    mtx[0] = x
    mtx[1] = 0.0f
    mtx[2] = 0.0f
    mtx[3] = 0.0f

    mtx[4] = 0.0f
    mtx[5] = y
    mtx[6] = 0.0f
    mtx[7] = 0.0f

    mtx[8] = 0.0f
    mtx[9] = 0.0f
    mtx[10] = z
    mtx[11] = 0.0f

    mtx[12] = 0.0f
    mtx[13] = 0.0f
    mtx[14] = 0.0f
    mtx[15] = 1.0f
    return mtx
end

function ident_mtx() : [float]
    return scale_mtx(1.0f, 1.0f, 1.0f)
end

function trans_mtx(x:float, y:float, z:float) : [float]
    local mtx : [float] = ident_mtx()
    mtx[3] = x
    mtx[7] = y
    mtx[11] = z
    return mtx
end

function mtx_mul(a:[float], b:[float]) : [float]
    local mtx : [float] = [16:float]
    for c=0, 4 do
        for d=0, 4 do
            local sum = 0.0f
            for k=0, 4 do
                sum = sum + a[4*c + k] * b[4*k + d]
            end
            mtx[4*c + d] = sum
        end
    end
    return mtx
end

function mtx_interp(a:[float], b:[float], t:float) : [float]
    local mtx : [float] = [16:float]
    for c=0, 16 do
        mtx[c] = a[c] * (1f-t) + b[c] * t
    end
    return mtx
end

function mtx_rotate_X(Q : [float], angle: float) : [float]
    -- io.println(angle)
    local s : float = math.sin(angle);
    local c : float = math.cos(angle);
    local R : [float] = [16:float]

    R[0] = 1.f;
    R[1] = 0.f;
    R[2] = 0.f;
    R[3] = 0.f;
    R[4] = 0.f;
    R[5] =   c;
    R[6] =   s;
    R[7] = 0.f;
    R[8] = 0.f;
    R[9] =  -s;
    R[10] =   c;
    R[11] = 0.f;
    R[12] = 0.f;
    R[13] = 0.f;
    R[14] = 0.f;
    R[15] = 1.f;

    return mtx_mul(R, Q)
    -- return R
end

function mtx_rotate_Y(Q : [float], angle : float) : [float]
    local s : float = math.sin(angle)
    local c : float = math.cos(angle)
    local R : [float] =  [16:float]

    R[0] = c
    R[1] = 0.f
    R[2] = s
    R[3] = 0.f
    R[4] = 0.f
    R[5] = 1.f
    R[6] = 0.f
    R[7] = 0.f
    R[8] = -s
    R[9] = 0.f
    R[10] = c
    R[11] = 0.f
    R[12] = 0.f
    R[13] = 0.f
    R[14] = 0.f
    R[15] = 1.f

    return mtx_mul(R, Q)
end

function mtx_rotate_Z(Q : [float], angle : float) : [float]
    local s : float = math.sin(angle)
    local c : float = math.cos(angle)
    local R : [float] =  [16:float]

    R[0] = c
    R[1] = s
    R[2] = 0.f
    R[3] = 0.f
    R[4] = -s
    R[5] = c
    R[6] = 0.f
    R[7] = 0.f
    R[8] = 0.f
    R[9] = 0.f
    R[10] = 1.f
    R[11] = 0.f
    R[12] = 0.f
    R[13] = 0.f
    R[14] = 0.f
    R[15] = 1.f

    return mtx_mul(R, Q)
end

function vec_mul(mtx:[float], vec:[float]) : [float]
    local out : [float] = [4:float]
    for k=0, #out do
        out[k] = mtx[4*k+0] * vec[0] + mtx[4*k+1] * vec[1] + mtx[4*k+2] * vec[2] + mtx[4*k+3] * vec[3];
    end
    return out
end

-- ugly LUT
local lut_u : [float] = [16*16:float]
local lut_v : [float] = [16*16:float]
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

function qb_text( qb : QuadBatch, start_x : float, start_y : float, txt : String, char_w : float, spacing : float )
    local delta = 16.0f / 256.0f
    local i = 0
    local x = start_x
    while (txt.byte_at(i) ~= 0u8) do
        local u0 = lut_u[txt.byte_at(i)]
        local v0 = lut_v[txt.byte_at(i)]
        local u1 = u0 + delta
        local v1 = v0 + delta

        qb_add_centered( qb, x, start_y, char_w, char_w, u0, v1, u1, v0 )

        i = i + 1
        x = x + spacing
    end

end

function qb_text_slam( qb : QuadBatch, start_x : float, start_y : float, txt : String, char_w : float, spacing : float, where2:float )

    local delta = 16.0f / 256.0f
    local i = 0
    local x = start_x
    while (txt.byte_at(i) ~= 0u8) do
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

        qb_add_centered( qb, x, start_y, char_w*size, char_w*size, u0, v1, u1, v0 )

        i = i + 1
        x = x + spacing
    end

end

--------------------------------------------------------------
-- particle meshes????
local MAX_PARTICLE_COUNT : int = 1024 * 2
struct Particle
    local pos : @[3:float]
    local vel : @[3:float]
    local target : @[3:float]
    local speed : float
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

    -- gen_cube_particles( 0.0f, 0.0f, 0.0f, 200.0f, 200.0f, 200.0f, test_psys )
    -- gen_square_points( 0.0f, 0.0f, 200.0f, 200.0f, test_psys, MAX_PARTICLE_COUNT )

    for i=0, MAX_PARTICLE_COUNT do
        local a : float = random() * 3.14f * 2.0f
        test_psys.particle_buf[i].pos[0] = math.cos(a) * 2048.0f
        test_psys.particle_buf[i].pos[1] = math.sin(a) * 1048.0f + 1100.0f
        test_psys.particle_buf[i].pos[2] = 2000.0f
        test_psys.particle_buf[i].speed = (random() * 0.6f + 0.4f) * 0.6f
    end
end

function gen_points_from_line( v0 : [float], v1 : [float], points_per_line : int, ps : ParticleSystem, fill_start : int )

    local vec  : [float] = [3:float]
    local step : [float] = [3:float]
    vec[0] = v1[0] - v0[0]
    vec[1] = v1[1] - v0[1]
    vec[2] = v1[2] - v0[2]
    step[0] = vec[0] / points_per_line as float
    step[1] = vec[1] / points_per_line as float
    step[2] = vec[2] / points_per_line as float

    local d = 0.0f
    for i=fill_start, fill_start + points_per_line do
        ps.particle_buf[i].target[0] = v0[0] + step[0] * d
        ps.particle_buf[i].target[1] = v0[1] + step[1] * d
        ps.particle_buf[i].target[2] = v0[2] + step[2] * d

        d = d + 1.0f
    end

end

function gen_square_points( x : float, y : float, w : float, h : float, ps : ParticleSystem, point_count : int )
    -- local points : [float] = [point_count*3:float]

    local wh : float = w / 2.0f
    local hh : float = h / 2.0f

    -- calc number of lines
    local lines = 4
    local points_per_line = point_count as float / lines as float

    -- verts
    local v0 : [float] = [3:float]
    local v1 : [float] = [3:float]
    local v2 : [float] = [3:float]
    local v3 : [float] = [3:float]
    v0[0] = x - wh
    v0[1] = y - hh
    v0[2] = 0.0f
    v1[0] = x + wh
    v1[1] = y - hh
    v1[2] = 0.0f
    v2[0] = x + wh
    v2[1] = y + hh
    v2[2] = 0.0f
    v3[0] = x - wh
    v3[1] = y + hh
    v3[2] = 0.0f

    -- vectors
    local ppl_i = points_per_line as int
    gen_points_from_line( v0, v1, ppl_i, ps, ppl_i*0 )
    gen_points_from_line( v1, v2, ppl_i, ps, ppl_i*1 )
    gen_points_from_line( v2, v3, ppl_i, ps, ppl_i*2 )
    gen_points_from_line( v3, v0, ppl_i, ps, ppl_i*3 )

    -- return points
end

function gen_plus_side( x : float, y : float, z : float, w : float, h : float, d : float, ps : ParticleSystem, start_i : int, mtx : [float] ) : int

    local wh : float = w / 2.0f
    local hh : float = h / 2.0f
    local dh : float = d / 2.0f

    local wh2 : float = wh / 2.0f
    local hh2 : float = hh / 2.0f
    local dh2 : float = dh / 2.0f

    -- verts
    local v0 : [float] = [4:float]
    local v1 : [float] = [4:float]
    local v2 : [float] = [4:float]
    local v3 : [float] = [4:float]

    v0[0] = - wh2
    v0[1] = - hh
    v0[2] =   dh
    v0[3] = 1.0f
    v0 = vec_mul(mtx, v0)

    v1[0] =   wh2
    v1[1] = - hh
    v1[2] =   dh
    v1[3] = 1.0f
    v1 = vec_mul(mtx, v1)

    v2[0] =   wh2
    v2[1] =   hh
    v2[2] =   dh
    v2[3] = 1.0f
    v2 = vec_mul(mtx, v2)

    v3[0] = - wh2
    v3[1] =   hh
    v3[2] =   dh
    v3[3] = 1.0f
    v3 = vec_mul(mtx, v3)


    v0[0] = v0[0] + x
    v0[1] = v0[1] + y
    v0[2] = v0[2] + z
    v1[0] = v1[0] + x
    v1[1] = v1[1] + y
    v1[2] = v1[2] + z
    v2[0] = v2[0] + x
    v2[1] = v2[1] + y
    v2[2] = v2[2] + z
    v3[0] = v3[0] + x
    v3[1] = v3[1] + y
    v3[2] = v3[2] + z


    local lines = 32
    local points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    local ppl_i = points_per_line as int
    gen_points_from_line( v0, v1, ppl_i, ps, ppl_i*0 + start_i*ppl_i)
    gen_points_from_line( v1, v2, ppl_i, ps, ppl_i*1 + start_i*ppl_i)
    gen_points_from_line( v2, v3, ppl_i, ps, ppl_i*2 + start_i*ppl_i)
    gen_points_from_line( v3, v0, ppl_i, ps, ppl_i*3 + start_i*ppl_i)

end

--[[
function gen_logo_particles( x : float, y : float, z : float, w : float, h : float, d : float, ps : ParticleSystem, mtx : [float] )

    local rmtx : [float] = ident_mtx()

    rmtx = ident_mtx()
    rmtx = mtx_rotate_x(rmtx, 3.14/2.0)
    rmtx = mtx_mul(mtx, rmtx)
    gen_plus_side( x, y, z, w, h, d, ps, 0, rmtx )

    rmtx = ident_mtx()
    rmtx = mtx_rotate_x(rmtx, 3.14/2.0 * 2.0)
    rmtx = mtx_mul(mtx, rmtx)
    gen_plus_side( x, y, z, w, h, d, ps, 4, rmtx )

    rmtx = mtx_rotate_X(rmtx, 3.14/2.0)
    gen_plus_side( x, y, z, w, h, d, ps, 8, rmtx )
    rmtx = mtx_rotate_X(rmtx, 3.14/2.0)
    gen_plus_side( x, y, z, w, h, d, ps, 12, rmtx )

    rmtx = ident_mtx()
    rmtx = mtx_rotate_Y(rmtx, 3.14/2.0)
    rmtx = mtx_mul(mtx, rmtx)
    gen_plus_side( x, y, z, w, h, d, ps, 16, rmtx )

    rmtx = ident_mtx()
    rmtx = mtx_rotate_Y(rmtx, -3.14/2.0)
    rmtx = mtx_mul(mtx, rmtx)
    gen_plus_side( x, y, z, w, h, d, ps, 20, rmtx )
    -- rmtx = mtx_rotate_Y(rmtx, 3.14/2.0)
    -- gen_plus_side( x, y, z, w, h, d, ps, 20, rmtx )
    -- rmtx = mtx_rotate_Y(rmtx, 3.14/2.0)
    -- gen_plus_side( x, y, z, w, h, d, ps, 24, rmtx )
    -- rmtx = mtx_rotate_Y(rmtx, 3.14/2.0)
    -- gen_plus_side( x, y, z, w, h, d, ps, 28, rmtx )

end
]]

function gen_pyramid_particles( x : float, y : float, z : float, w : float, h : float, d : float, ps : ParticleSystem, mtx : [float] )

    local wh : float = w / 2.0f
    local hh : float = h / 2.0f
    local dh : float = d / 2.0f

    -- verts
    local v0 : [float] = [4:float]
    local v1 : [float] = [4:float]
    local v2 : [float] = [4:float]
    local v3 : [float] = [4:float]
    local v4 : [float] = [4:float]

    v0[0] = - wh
    v0[1] = - hh
    v0[2] =   dh
    v0[3] = 1.0f
    v0 = vec_mul(mtx, v0)

    v1[0] =   wh
    v1[1] = - hh
    v1[2] =   dh
    v1[3] = 1.0f
    v1 = vec_mul(mtx, v1)

    v2[0] =   wh
    v2[1] = - hh
    v2[2] = - dh
    v2[3] = 1.0f
    v2 = vec_mul(mtx, v2)

    v3[0] = - wh
    v3[1] = - hh
    v3[2] = - dh
    v3[3] = 1.0f
    v3 = vec_mul(mtx, v3)

    v4[0] = 0.0f
    v4[1] =   hh
    v4[2] = 0.0f
    v4[3] = 1.0f
    v4 = vec_mul(mtx, v4)

    v0[0] = v0[0] + x
    v0[1] = v0[1] + y
    v0[2] = v0[2] + z
    v1[0] = v1[0] + x
    v1[1] = v1[1] + y
    v1[2] = v1[2] + z
    v2[0] = v2[0] + x
    v2[1] = v2[1] + y
    v2[2] = v2[2] + z
    v3[0] = v3[0] + x
    v3[1] = v3[1] + y
    v3[2] = v3[2] + z
    v4[0] = v4[0] + x
    v4[1] = v4[1] + y
    v4[2] = v4[2] + z

    local lines = 8
    local points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    local ppl_i = points_per_line as int
    gen_points_from_line( v0, v1, ppl_i, ps, ppl_i*0 )
    gen_points_from_line( v1, v2, ppl_i, ps, ppl_i*1 )
    gen_points_from_line( v2, v3, ppl_i, ps, ppl_i*2 )
    gen_points_from_line( v3, v0, ppl_i, ps, ppl_i*3 )

    gen_points_from_line( v0, v4, ppl_i, ps, ppl_i*4 )
    gen_points_from_line( v1, v4, ppl_i, ps, ppl_i*5 )
    gen_points_from_line( v2, v4, ppl_i, ps, ppl_i*6 )
    gen_points_from_line( v3, v4, MAX_PARTICLE_COUNT - ppl_i*7, ps, ppl_i*7 )

end

function gen_cube_particles( x : float, y : float, z : float, w : float, h : float, d : float, ps : ParticleSystem, mtx : [float] )

    local wh : float = w / 2.0f
    local hh : float = h / 2.0f
    local dh : float = d / 2.0f

    -- verts
    local v0 : [float] = [4:float]
    local v1 : [float] = [4:float]
    local v2 : [float] = [4:float]
    local v3 : [float] = [4:float]
    local v4 : [float] = [4:float]
    local v5 : [float] = [4:float]
    local v6 : [float] = [4:float]
    local v7 : [float] = [4:float]

    v0[0] = - wh
    v0[1] = - hh
    v0[2] =   dh
    v0[3] = 1.0f
    v0 = vec_mul(mtx, v0)

    v1[0] =   wh
    v1[1] = - hh
    v1[2] =   dh
    v1[3] = 1.0f
    v1 = vec_mul(mtx, v1)

    v2[0] =   wh
    v2[1] =   hh
    v2[2] =   dh
    v2[3] = 1.0f
    v2 = vec_mul(mtx, v2)

    v3[0] = - wh
    v3[1] =   hh
    v3[2] =   dh
    v3[3] = 1.0f
    v3 = vec_mul(mtx, v3)

    v4[0] = - wh
    v4[1] = - hh
    v4[2] = - dh
    v4[3] = 1.0f
    v4 = vec_mul(mtx, v4)

    v5[0] =   wh
    v5[1] = - hh
    v5[2] = - dh
    v5[3] = 1.0f
    v5 = vec_mul(mtx, v5)

    v6[0] =   wh
    v6[1] =   hh
    v6[2] = - dh
    v6[3] = 1.0f
    v6 = vec_mul(mtx, v6)

    v7[0] = - wh
    v7[1] =   hh
    v7[2] = - dh
    v7[3] = 1.0f
    v7 = vec_mul(mtx, v7)

    v0[0] = v0[0] + x
    v0[1] = v0[1] + y
    v0[2] = v0[2] + z
    v1[0] = v1[0] + x
    v1[1] = v1[1] + y
    v1[2] = v1[2] + z
    v2[0] = v2[0] + x
    v2[1] = v2[1] + y
    v2[2] = v2[2] + z
    v3[0] = v3[0] + x
    v3[1] = v3[1] + y
    v3[2] = v3[2] + z
    v4[0] = v4[0] + x
    v4[1] = v4[1] + y
    v4[2] = v4[2] + z
    v5[0] = v5[0] + x
    v5[1] = v5[1] + y
    v5[2] = v5[2] + z
    v6[0] = v6[0] + x
    v6[1] = v6[1] + y
    v6[2] = v6[2] + z
    v7[0] = v7[0] + x
    v7[1] = v7[1] + y
    v7[2] = v7[2] + z

    local lines = 12
    local points_per_line = MAX_PARTICLE_COUNT as float / lines as float

    local ppl_i = points_per_line as int
    gen_points_from_line( v0, v1, ppl_i, ps, ppl_i*0 )
    gen_points_from_line( v1, v2, ppl_i, ps, ppl_i*1 )
    gen_points_from_line( v2, v3, ppl_i, ps, ppl_i*2 )
    gen_points_from_line( v3, v0, ppl_i, ps, ppl_i*3 )

    gen_points_from_line( v4, v5, ppl_i, ps, ppl_i*4 )
    gen_points_from_line( v5, v6, ppl_i, ps, ppl_i*5 )
    gen_points_from_line( v6, v7, ppl_i, ps, ppl_i*6 )
    gen_points_from_line( v7, v4, ppl_i, ps, ppl_i*7 )

    gen_points_from_line( v0, v4, ppl_i, ps, ppl_i*8 )
    gen_points_from_line( v1, v5, ppl_i, ps, ppl_i*9 )

    gen_points_from_line( v3, v7, ppl_i, ps, ppl_i*10 )
    gen_points_from_line( v2, v6, MAX_PARTICLE_COUNT - ppl_i*11, ps, ppl_i*11 )

end


function gen_sphere_particles( x : float, y : float, z : float, w : float, h : float, d : float, ps : ParticleSystem, mtx : [float] )

    local dt:float = 3.1415f * 2.0f * 16.0f / MAX_PARTICLE_COUNT as float
    for i=0, MAX_PARTICLE_COUNT do
       local tmp:[float] = [4:float];
       local t = i as float * dt;
       local s = math.sin(t);
       local c = math.cos(t);
       local ly = 1.0f - 2.0f* i as float / MAX_PARTICLE_COUNT as float;
       local w = math.sqrt(1.0f - ly*ly);
       tmp[0] = s * 100.0f * w + x;
       tmp[1] = 100.0f - 200.0f * i as float/MAX_PARTICLE_COUNT as float + y;
       tmp[2] = c * 100.0f * w + z;
       tmp[3] = 1.0f;

       local tmp2:[float] = vec_mul(mtx, tmp);

        ps.particle_buf[i].target[0] = tmp2[0];
        ps.particle_buf[i].target[1] = tmp2[1];
        ps.particle_buf[i].target[2] = tmp2[2];
    end
end

function gen_plusbox_particles( ps : ParticleSystem, mtx : [float] )
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
                    local u:[float] = [4:float]
                    local v:[float] = [4:float]
                    if a == 0 then
                        u[0] = x as float
                        u[1] = y as float
                        u[2] = q as float
                        v[0] = x as float
                        v[1] = y as float
                        v[2] = (q + 1) as float
                    elseif a == 1 then
                        u[0] = x as float
                        u[1] = q as float
                        u[2] = y as float
                        v[0] = x as float
                        v[1] = (q + 1) as float
                        v[2] = y as float
                    elseif a == 2 then
                        u[0] = q as float
                        u[1] = x as float
                        u[2] = y as float
                        v[0] = (q + 1) as float
                        v[1] = x as float
                        v[2] = y as float
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
                            u[3] = 1.0f
                            v[3] = 1.0f
                            local b = 0
                            while b < 3 do
                                u[b] = (u[b] - 1.5f) * 50.0f
                                v[b] = (v[b] - 1.5f) * 50.0f
                                b = b + 1
                            end
                            lines = lines - 1
                            if lines == 0 then
                                gen_points_from_line(vec_mul(mtx, u), vec_mul(mtx, v), MAX_PARTICLE_COUNT - lp, ps, lp);
                            else
                                gen_points_from_line(vec_mul(mtx, u), vec_mul(mtx, v), per, ps, lp);
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

function fux_particle_speed( ps : ParticleSystem )

    local i : int = 0
    while (i < MAX_PARTICLE_COUNT) do
        ps.particle_buf[i].speed = (random() * 0.6f + 0.4f) * 0.6f
        i = i + 1
    end

end

function update_meshy_cube( ps : ParticleSystem, qb : QuadBatch, delta : float )

    if ps.cool_down > 0.0f then
        ps.cool_down = ps.cool_down - delta
        if (ps.cool_down <= 0.0f) then
            ps.cool_down = 0.0f

            ps.mode = ps.next_mode
        end
    end

    -- update particles depending on mode
    if (ps.mode == PARTICLE_MODE_STATIC) then
        -- do nothing
    elseif (ps.mode == PARTICLE_MODE_FOLLOW) then
        local tv : [float] = [3:float]
        local i : int = 0
        while (i < MAX_PARTICLE_COUNT) do
            --tv[0] = 0.6f*delta*(ps.particle_buf[i].target[0] - ps.particle_buf[i].pos[0])
            --tv[1] = 0.6f*delta*(ps.particle_buf[i].target[1] - ps.particle_buf[i].pos[1])
            --tv[2] = 0.6f*delta*(ps.particle_buf[i].target[2] - ps.particle_buf[i].pos[2])
            tv[0] = ps.particle_buf[i].speed*delta*(ps.particle_buf[i].target[0] - ps.particle_buf[i].pos[0])
            tv[1] = ps.particle_buf[i].speed*delta*(ps.particle_buf[i].target[1] - ps.particle_buf[i].pos[1])
            tv[2] = ps.particle_buf[i].speed*delta*(ps.particle_buf[i].target[2] - ps.particle_buf[i].pos[2])

            if (ps.particle_buf[i].speed < 0.6f) then
                ps.particle_buf[i].speed = ps.particle_buf[i].speed*1.008f
                --test_psys.particle_buf[i].speed = (random() * 0.3f + 0.7f) * 0.6f)
            end

            ps.particle_buf[i].pos[0] = ps.particle_buf[i].pos[0] + tv[0]
            ps.particle_buf[i].pos[1] = ps.particle_buf[i].pos[1] + tv[1]
            ps.particle_buf[i].pos[2] = ps.particle_buf[i].pos[2] + tv[2]

            i = i + 1
        end

    elseif (ps.mode == PARTICLE_MODE_EXPLODE) then

        local g = -0.9f * 10.0f

        local i : int = 0
        while (i < MAX_PARTICLE_COUNT) do

            ps.particle_buf[i].vel[1] = ps.particle_buf[i].vel[1] + g * delta

            ps.particle_buf[i].pos[0] = ps.particle_buf[i].pos[0] + ps.particle_buf[i].vel[0]
            ps.particle_buf[i].pos[1] = ps.particle_buf[i].pos[1] + ps.particle_buf[i].vel[1]
            ps.particle_buf[i].pos[2] = ps.particle_buf[i].pos[2] + ps.particle_buf[i].vel[2]

            --if (ps.particle_buf[i].speed < 0.6f) then
                --ps.particle_buf[i].speed = ps.particle_buf[i].speed*2.0f
            --ps.particle_buf[i].speed = (random() * 0.3f + 0.7f) * 0.6f
            --end

            i = i + 1
        end
    end

    -- render!!!
    qb_begin( qb )
    local zzz : [float] = [4:float]
    -- zzz[0] = 0.0f
    -- zzz[1] = 0.0f
    -- zzz[2] = 0.0f
    for i=0, MAX_PARTICLE_COUNT do
       -- qb_add_centered( qb,
       -- ps.particle_buf[i].pos[0],
       -- ps.particle_buf[i].pos[1],
       -- 8.0f, 8.0f,
       -- 0.0f, 0.0f, 1.0f, 1.0f )
       zzz[0] = ps.particle_buf[i].pos[2]
       zzz[1] = ps.particle_buf[i].pos[2]
       zzz[2] = ps.particle_buf[i].pos[2]
       zzz[3] = ps.particle_buf[i].pos[2]
       qb_add_3d( qb, ps.particle_buf[i].pos[0] - 5f, ps.particle_buf[i].pos[1] - 5f, ps.particle_buf[i].pos[0] + 5.0f, ps.particle_buf[i].pos[1] + 5.0f, 0.0f, 0.0f, 1.0f, 1.0f, zzz)
    end
    qb_end( qb )

end


--------------------------------------------------------------
-- scenes??
function run_particle_test(  )

    scene_particle_init()

    local last_time_stamp = glfwGetTime()

    while loop_begin() do
        local width  : [int] = [1:int]
        local height : [int] = [1:int]

        glfwGetFramebufferSize( window, width, height )
        local widthf = width[0] as float
        local heightf = height[0] as float

        glViewport(0,0,width[0],height[0])
        glClearColor(1.0f, 0.2f, 0.2f, 1.0f)
        glClear( 0x4100u32 )
        glDisable( GL_BLEND )
        glEnable( GL_DEPTH_TEST )
        glDisable( GL_CULL_FACE )

        local delta = glfwGetTime() - last_time_stamp
        last_time_stamp = glfwGetTime()

        -- if (last_time_stamp > 2.0) then
        --     io.println("asdads")
        -- end

        -- scene_particle_draw(window, delta)

        -- qb_render(fb)
        --     floor_sim(cur, 1 - cur)
        --     cur = 1 - cur

        --     t = t + 0.01f

        loop_end()
    end

    scene_particle_release()

end

local apa : String = "asd"
local particle_shader : uint32
local mesh_shader : uint32
local particle_qb : QuadBatch
-- local particle_mtx : [float] = ortho_mtx( 0.0f, 320.0f, 0.0f, 320.0f, 0.0f, 1.0f)
local particle_amount : int = 1024*10
local particle_loc_mtx : int

-- struct Particle
--     local pos : @[3:float]
--     --local vel : @[3:float]
--     local target : @[3:float]
--     local speed : float
-- end

-- local particle_buf : [@Particle] = [particle_amount:@Particle]

function scene_particle_init()

    local vertex_src : String = read_file_as_string("data/shaders/particle_3d.vp")
    local fragment_src : String = read_file_as_string("data/shaders/particle.fp")

    particle_shader = create_shader( vertex_src, fragment_src )
    check_error("(particle) create shader", false)
    particle_loc_mtx = glGetUniformLocation( particle_shader, "mtx")
    check_error("(particle) getting locations", false)

    particle_qb = create_quad_batch( particle_amount )


    -- local vertex_mesh_src : String = read_file_as_string("data/shaders/mesh.vp")
    -- mesh_shader = create_shader( vertex_mesh_src, fragment_src )
    -- check_error("(mesh) create shader", false)

    init_meshy_cube()

    --[[
    qb_begin( particle_qb )
    -- qb_add_centered( particle_qb, 320.0f, 320.0f, 640.0f, 640.0f, 0.0f, 0.0f, 1.0f, 1.0f )
    qb_add( particle_qb,
          0.0f,   0.0f,
        640.0f, 640.0f,
          0.0f,   0.0f,
          1.0f,   1.0f )
    qb_end( particle_qb )
    ]]

    -- init particles
    --[[
    local i : int = 0
    while (i < particle_amount) do

        particle_buf[i].pos[0] = 0.0f
        -- particle_buf[i].pos[0] = (random() * 2.0f - 1.0f) * 320.0f
        particle_buf[i].pos[1] = 0.0f
        -- particle_buf[i].pos[1] = (random() * 2.0f - 1.0f) * 320.0f
        particle_buf[i].pos[2] = 0.0f

        -- local angle = random() * 3.14f * 2.0f
        -- local asd = random() * 10.0f
        -- particle_buf[i].vel[0] = float(sin(double(angle))) * asd
        -- particle_buf[i].vel[1] = float(cos(double(angle))) * asd
        -- particle_buf[i].vel[2] = 0.0f

        i = i + 1
    end
    ]]

end

function scene_particle_draw(window : uint64, mtx : [float], delta : float)
    local width  : [int] = [1:int]
    local height : [int] = [1:int]
    glfwGetFramebufferSize( window, width, height )
    local widthf = width[0] as float
    local heightf = height[0] as float

    local deltaf = delta
    -- io.println(widthf)
    -- local particle_mtx = ortho_mtx( -widthf / 2.0f, widthf / 2.0f, -heightf / 2.0f, heightf / 2.0f, 0.0f, 1.0f)

    glDisable( GL_DEPTH_TEST )
    glEnable( GL_BLEND )
    glBlendFunc( GL_ONE, GL_ONE )

    update_meshy_cube( test_psys, particle_qb, delta)

    --[[
    qb_begin( particle_qb )
    -- qb_add_centered( particle_qb, widthf / 2.0f, heightf / 2.09f, widthf, heightf, 0.0f, 0.0f, 1.0f, 1.0f )
    local i : int = 0
    while (i < particle_amount) do

        -- particle_buf[i].pos[0] = particle_buf[i].pos[0] + deltaf*particle_buf[i].vel[0]
        -- particle_buf[i].pos[1] = particle_buf[i].pos[1] + deltaf*particle_buf[i].vel[1]
        -- particle_buf[i].pos[2] = particle_buf[i].pos[2] + deltaf*particle_buf[i].vel[2]

        qb_add_centered( particle_qb,
            -- widthf / 2.0f + (random() * 2.0f - 1.0f) * widthf,
            particle_buf[i].pos[0],
            -- (random() * 2.0f - 1.0f) * widthf,
            particle_buf[i].pos[1],
            -- (random() * 2.0f - 1.0f) * heightf,
            -- heightf / 2.0f + (random() * 2.0f - 1.0f) * heightf,
            8.0f, 8.0f,
            0.0f, 0.0f, 1.0f, 1.0f )
        i = i + 1
    end
    qb_end( particle_qb )
    ]]

    glUseProgram(particle_shader)
    glUniformMatrix4fv(particle_loc_mtx, 1, true, mtx)
    qb_render( particle_qb )

end

function scene_particle_release()

    apa = ""

end

function create_mesh( path : String ) : uint32

    local buffers : [uint32] = [1:uint32]
    glGenBuffers( 1, buffers )
    glBindBuffer( GL_ARRAY_BUFFER, buffers[0] )

    local data : [byte] = read_file( path )
    io.println(#data)

    glBufferData( GL_ARRAY_BUFFER, #data, data, GL_STATIC_DRAW )
    check_error( "loading mesh geo buffers", true )

    local vao : [uint32] = [1:uint32]
    glGenVertexArrays( 1, vao );
    glBindVertexArray(vao[0]);

    glEnableVertexAttribArray( 0 )
    glBindBuffer( GL_ARRAY_BUFFER, buffers[0] )
    glVertexAttribPointer(0u32, 3, GL_FLOAT, false, 0, 0);

    -- return buffers[0]
    return vao[0]

end

--------------------------------------------------------------
--
function setup()
    -- create shader

    -- create_quad()

end

function unused_render( window : uint64, delta : double )
    local width  : [int] = [1:int]
    local height : [int] = [1:int]
    glfwGetFramebufferSize( window, width, height )
    -- glfwGetWindowSize( window, width, height )


    -- local ortho_mtx = ortho_mtx( 0, width, 0, height, -1.0f, 1.0f )

    glViewport(0,0,width[0],height[0])
    glClearColor(0.2f, 0.2f, 0.2f, 1.0f)
    glClear( GL_COLOR_BUFFER_BIT )
    glEnable( GL_BLEND )
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDisable( GL_DEPTH_TEST )
    glDisable( GL_CULL_FACE )




--    scene_particle_draw( window, delta )


end

function loop_begin():bool
    return glfwWindowShouldClose( window ) <= 0
end

function loop_end()
        glfwSwapBuffers(window)
        glfwPollEvents()
end

local floorsize:int = 256

struct HF
    heights : @[65536:float];
end

local floordata:[@HF] = [2:@HF];
local music_channel:uint64;

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


function floor_sim(src:int, dst:int)
    local c2 = 30.0f

    local s = floordata[src].heights
    local d = floordata[dst].heights

    local dt = 0.12f

    for u=1, floorsize-1 do
        for v=1, floorsize-1 do
            local idx = 256 * u + v;

            local f = c2 * (s[idx-1] + s[idx+1] + s[idx-floorsize] + s[idx+floorsize] - 4.0f * s[idx]);
            local vel = (s[idx] - d[idx])/dt + f * dt;
            d[idx] = 0.98f * (s[idx] + vel * dt);
        end
    end
end

function run_floor()
    scene_particle_init()

    local width = [1:int]
    local height = [1:int]
    glfwGetFramebufferSize( window, width, height )
    local widthf = width[0] as float
    local heightf = height[0] as float

    local fb : QuadBatch = create_quad_batch(1024*1024)

    -- logo texture
    local logo_data : [byte] = read_file( "data/textures/defold_logo.raw" )
    local logo_tex = create_texture(1280, 447, logo_data)
    local logo_qb = create_quad_batch(12)

    local vertex_src : String = read_file_as_string("data/shaders/floor.vp")
    local fragment_src : String = read_file_as_string("data/shaders/floor.fp")
    local floor_shader = create_shader( vertex_src, fragment_src );
    check_error("(floor) create shader", false);

    -- voxel
    vertex_src  = read_file_as_string("data/shaders/voxel.vp")
    fragment_src  = read_file_as_string("data/shaders/voxel.fp")
    local voxel_shader = create_shader( vertex_src, fragment_src )
    local voxel_qb = create_quad_batch(1024*1024);

    --- text

    vertex_src  = read_file_as_string("data/shaders/shader.vp")
    fragment_src  = read_file_as_string("data/shaders/shader.fp")
    local text_shader = create_shader( vertex_src, fragment_src )
    check_error("(text) create shader", false);
    local text_qb : QuadBatch = create_quad_batch( 1024 )
    local text_shader = create_shader( vertex_src, fragment_src )
    check_error("(particle) create shader", false)

    local loc_mtx:int = glGetUniformLocation( floor_shader, "mtx")
    check_error("(particle) getting locations", false)
    local water_fade:int = glGetUniformLocation( floor_shader, "waterFade");
    local logo_fade:int = glGetUniformLocation( floor_shader, "logoFade");
    local water_time:int = glGetUniformLocation( floor_shader, "waterTime");

    local t:float = 0.0f

    local tex0_data : [byte] = read_file( "data/textures/consolefont.raw" )
    local tex0 = create_texture(256, 256, tex0_data)

    -- FBO stuff
    vertex_src  = read_file_as_string("data/shaders/screen.vp")
    fragment_src  = read_file_as_string("data/shaders/screen.fp")
    local screen_shader = create_shader( vertex_src, fragment_src )
    local screen_quad = create_quad()
--    local screen_fbo, screen_texture = create_fbo(width[0], height[0], true)

    local htex = [1:uint32]
    glGenTextures(1, htex);
    glBindTexture(GL_TEXTURE_2D, htex[0]);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR )
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR )

    gen_floor(fb, 512)

    local cur = 1
    local anim = 0.0f

    local last_time_stamp = glfwGetTime();
    local start_time = glfwGetTime();
    local to_water:float = 0.0f;
    local water_t:float = 0.0f;

    local to_logo:float = 0.0f;
    local logo_t:float = 0.0f;


    local psyk_t:float = 0.0f;
    local next_switch = 0u64;

    while loop_begin() do
--        render_to_fbo(screen_fbo )

        glfwGetFramebufferSize( window, width, height )
        widthf = width[0] as float
        heightf = height[0] as float

        local delta = (glfwGetTime() - last_time_stamp) as float
        last_time_stamp = glfwGetTime()

        local tm:[@WrapUInt64] = [1:@WrapUInt64];
        FMOD_Channel_GetPosition(music_channel, tm, 1u64);

        if tm[0].val > 12000u64 then
--      if tm[0].val > 1000u64 then
           to_water = to_water + (1.0f - to_water) * 3.0f * delta
           if to_water > 1.0f then
              to_water = 1.0f
           end
        end

        if tm[0].val > 42000u64 then
--      if tm[0].val > 3000u64 then
           to_logo = to_logo + (1.0f - to_logo) * 3.0f * delta
           if to_logo > 1.0f then
              to_logo = 1.0f
           end
        end

--      if tm[0].val > 2000u64 then
        if tm[0].val > 25500u64 then
           if psyk_t == 0.0f then
              next_switch = 0u64;
           end
           psyk_t = psyk_t + delta
        end

        if t > 50.0f then
            break
        end


        local do_switch = 0
        if tm[0].val > next_switch and math.cos(psyk_t*3.0f) > 0.8f then
            if psyk_t > 0.0f then
                next_switch = tm[0].val + 6000u64
            else
                next_switch = tm[0].val + 3000u64
            end
            do_switch = 1
        end

        water_t = to_water * delta + water_t;
        logo_t = to_logo * delta + logo_t;



        glViewport(0,0,width[0],height[0])
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
        glClear( 0x4100u32 )
        glDisable( GL_BLEND )
        glEnable( GL_DEPTH_TEST )
        glDisable( GL_CULL_FACE )

        local ortho_mtx = ortho_matrix( 0.0f, 320.0f, 0.0f, 320.0f, 0.0f, 1.0f);

        local dolly = logo_t * 0.9f
        if dolly > 1.0f then
            dolly = 1.0f
        end

        local fov = 2.0f - 1.8f * dolly
        local dolly_dist = (2000f-250f) * dolly
        local elevate = 100.0f * dolly
        local persp = persp_mtx( -0.8f * fov, 0.8f * fov, -0.6f * fov, 0.6f * fov, 1.0f + dolly_dist, 700.0f + dolly_dist)
        local camera = mtx_mul(persp, trans_mtx(0.0f, -elevate -50.0f + (1f-to_logo)*math.sin(t*0.2f)*10.0f, -250.0f - dolly_dist))

        glUseProgram(floor_shader)
        glUniformMatrix4fv(loc_mtx, 1, true, camera)

        -- convert & scale heights
        local texdata : [float] = [65536:float]
        for k=0, 65536 do
           texdata[k] = 0.001f * floordata[cur].heights[k]
        end

        glBindTexture(GL_TEXTURE_2D, htex[0]);
        glTexImage2D( GL_TEXTURE_2D, 0, GL_R32F, 0, 0, 0, GL_RED, GL_FLOAT, texdata);
        glTexImage2D( GL_TEXTURE_2D, 0, GL_R32F, floorsize, floorsize, 0, GL_RED, GL_FLOAT, texdata);
        glUniform1f(water_fade, to_water);
        glUniform1f(logo_fade, to_logo);
        glUniform1f(water_time, water_t);

        qb_render(fb)
        floor_sim(cur, 1 - cur)
        cur = 1 - cur

        -- particles
        local imtx : [float] = ident_mtx();
        local rot_mtx : [float] = mtx_rotate_X(imtx, t*1.1f);
        rot_mtx = mtx_rotate_Z(rot_mtx, (t*0.7f))

        local move:float = psyk_t;
        if move > 1.0f then
           move = 1.0f;
        end

        local dip_mtx = trans_mtx(math.sin(psyk_t)*move*200.0f,math.cos(psyk_t*3.0f) * 200.0f - 50.0f,math.cos(psyk_t*0.74f)*move*200.0f);
        rot_mtx = mtx_mul(dip_mtx, rot_mtx);


        local for_logo = mtx_mul(mtx_mul(trans_mtx(0f, 1.4f * elevate + 50.0f, 0f), mtx_mul(mtx_rotate_X(ident_mtx(), -0.25f*3.1415f), mtx_rotate_Y(ident_mtx(), 0.25f*3.1415f))), mtx_rotate_Z(ident_mtx(), 0.0f));
        rot_mtx = mtx_interp(rot_mtx, for_logo, to_logo);

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

            if (test_psys.mode == PARTICLE_MODE_STATIC) then
                test_psys.mode = PARTICLE_MODE_FOLLOW;
            end
            -- gen_logo_particles(0.0f, 0.0f, 0.0f, 100.0f, 100.0f, 100.0f, test_psys, rot_mtx )

            if (test_psys.figure == PARTICLE_FIGURE_CUBE) then
                gen_cube_particles(0.0f, 0.0f, 10.0f, 100.0f, 100.0f, 100.0f, test_psys, rot_mtx )
            elseif ( test_psys.figure == PARTICLE_FIGURE_SPHERE) then
                gen_sphere_particles(0.0f, 0.0f, 10.0f, 80.0f, 80.0f, 80.0f, test_psys, rot_mtx )
            elseif ( test_psys.figure == PARTICLE_FIGURE_PYRAMID) then
                gen_pyramid_particles(0.0f, 0.0f, 10.0f, 100.0f, 100.0f, 100.0f, test_psys, rot_mtx )
            else
                gen_plusbox_particles(test_psys, rot_mtx )
            end

            if do_switch == 1 then
                if (test_psys.figure == PARTICLE_FIGURE_CUBE) then
                    test_psys.figure = PARTICLE_FIGURE_SPHERE
                elseif (test_psys.figure == PARTICLE_FIGURE_SPHERE) then
                    --test_psys.figure = PARTICLE_FIGURE_PLUSBOX
                --elseif (test_psys.figure == PARTICLE_FIGURE_PLUSBOX) then
                    test_psys.figure = PARTICLE_FIGURE_PYRAMID
                else
                    test_psys.figure = PARTICLE_FIGURE_CUBE
                end

                fux_particle_speed( test_psys )
            end

            if (do_switch == 1 and psyk_t > 0.0f and test_psys.mode == PARTICLE_MODE_FOLLOW ) then
                test_psys.mode = PARTICLE_MODE_EXPLODE
                test_psys.cool_down = 3.0f
                test_psys.next_mode = PARTICLE_MODE_FOLLOW

                local i : int = 0
                local amp = 30.0f
                for i=0, MAX_PARTICLE_COUNT do
                    local a1 = random() * 3.14f * 2.0f
                    local a2 = random() * 3.14f * 2.0f

                    test_psys.particle_buf[i].vel[0] = math.sin(a1) * amp
                    test_psys.particle_buf[i].vel[1] = math.cos(a1) * amp
                    test_psys.particle_buf[i].vel[2] = math.sin(a2) * amp
                end
            end
        end

        if logo_t > 1.0f then
            test_psys.cool_down = 10000.0f
        end

        glUseProgram(voxel_shader);
        glUniformMatrix4fv(glGetUniformLocation(voxel_shader, "mtx"), 1, true, mtx_mul(camera, mtx_mul(rot_mtx, mtx_mul(scale_mtx(0.75f,0.75f,0.75f),scale_mtx(13.3f,13.3f,13.3f)))))

        qb_begin(voxel_qb);
        qb_write_plusbox(voxel_qb, logo_t - 0.3f);
        qb_end(voxel_qb);
        qb_render(voxel_qb);



        glUseProgram(particle_shader)
        scene_particle_draw(window, camera, 0.1f)

        if (glfwGetMouseButton(window, 0) == 1) then
            test_psys.mode = PARTICLE_MODE_STATIC
        end

        local px:int = (math.sin(2.0f*t)*64.0f) as int + 128;
        local py:int = (math.cos(3.0f*t)*64.0f) as int + 128;


        for p=0, MAX_PARTICLE_COUNT do
            local pos:[3:float] = test_psys.particle_buf[p].pos;
            if (pos[1] < 0.0f) and (pos[1] > -5.0f) then
                local x = (pos[0] + 256.0f) * 0.5f;
                local z = (pos[2] + 256.0f) * 0.5f;
                local y = pos[1];

                local PX = x as int
                local PY = z as int
                if PX > 0 and PX < 255 and PY > 0 and PY < 255 then
                    floordata[cur].heights[PY*256+PX] = -15.0f;
                end
            end
        end

        -- glUseProgram(mesh_shader)
        -- local mtxloc = glGetUniformLocation( mesh_shader, "mtx")
        -- glUniformMatrix4fv(mtxloc, 1, true, camera)
        -- glBindVertexArray(mesh_vbo)
        -- glDrawArrays( GL_TRIANGLES, 0u32, 48 );

        ----- TEXt
        glDisable(GL_DEPTH_TEST);

        local ortho_mtx = ortho_matrix( 0.0f, 800.0f, 0.0f, 600.0f, 0.0f, 1.0f )
        local location_mtx = glGetUniformLocation( text_shader, "mtx")
        local location_anim = glGetUniformLocation( text_shader, "anim")
        local location_offset = glGetUniformLocation( text_shader, "offset")
        local location_mode = glGetUniformLocation( text_shader, "mode")
        check_error("getting locations", false)

        glEnable(GL_BLEND)
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glUseProgram(text_shader);
        glUniformMatrix4fv(location_mtx, 1, true, ortho_mtx);
        glUniform1f(location_anim, t);
        glUniform1f(location_offset, t);
        glUniform1i(location_mode, 3);
        glBindTexture( GL_TEXTURE_2D, tex0 );

        qb_begin(text_qb);

        local pandown = (t - 10.0f);
        if pandown < 0.0f then
            pandown = 0.0f
        end
        pandown = pandown * pandown * 500.0f;
        if (pandown > 1000.0f) then
        end

        local t1 = 4.0f * t;
        qb_text_slam(text_qb, 75.0f, 500.0f + pandown, "DEFOLD CREW", 128.0f, 64.0f, t1)

        local t2 = 4.0f * (t - 3.5f)
        qb_text_slam(text_qb, 280.0f - pandown, 400.0f, "PRESENTS", 64.0f, 32.0f, t2)

        local t3 = 4.0f * (t - 7.0f)
        qb_text_slam(text_qb, 100.0f, 200.0f - pandown, "SOL HAX", 200.0f, 100.0f, t3)

        qb_end(text_qb)
        qb_render(text_qb);

        t = t + delta

        -- render to backbuffer
--        render_to_fbo( 0u32 )
--        glUseProgram(screen_shader)
--        glBindTexture(GL_TEXTURE_2D, screen_texture);
 --       glBindVertexArray(screen_quad)
 --       glDrawArrays( GL_TRIANGLES, 0u32, 1*6 );

        -- redner logo
        if (logo_t > 100.0f) then
            glUseProgram(screen_shader)
            glBindTexture(GL_TEXTURE_2D, logo_tex)
            location_mtx = glGetUniformLocation( screen_shader, "mtx")
            glUniformMatrix4fv(location_mtx, 1, true, ortho_mtx);
            local logo_scale = 0.3f
            qb_begin(logo_qb)
            qb_add_centered(logo_qb, 400.0f, 100.0f, 1280.0f * logo_scale, 447.0f * logo_scale, 0.0f, 1.0f, 1.0f, 0.0f )
            qb_end(logo_qb)
            qb_render(logo_qb)
        end


        loop_end()
    end

    scene_particle_release()
end

function init_audio() : uint64
    local system_ptr_wrap : [@WrapPointer] = [1:@WrapPointer]
    if (FMOD_System_Create(system_ptr_wrap) ~= FMOD_OK) then
        log_error("could not create FMOD system")
        return 0u64
    end
    local fmod_system = system_ptr_wrap[0].ptr

    if (FMOD_System_Init(fmod_system, 32, 0u64, 0u64) ~= FMOD_OK) then
        log_error("could not init FMOD")
        return 0u64
    end
    -- io.println(apa[0].ptr[0])

    log_ok("FMOD initiated")

    return fmod_system
end


function load_sound( fmod_system : uint64, path : String ) : uint64

    local sound_ptr_wrap : [@WrapPointer] = [1:@WrapPointer]
    -- local extinfo : [FMOD_CREATESOUNDEXINFO] = [1:FMOD_CREATESOUNDEXINFO]
    -- extinfo[0] =
    local res : uint64 = FMOD_System_CreateSound( fmod_system, path, 0x40u64, 0u64, sound_ptr_wrap)

    if (res ~= FMOD_OK) then
        log_error("(" .. path .. ") could not create sound: ")
--        io.println(res)
        -- log_error("(" .. path .. ") could not create sound: " .. FMOD_ErrorString(res))
        return 0u64
    end

    local sound_ptr = sound_ptr_wrap[0].ptr

    return sound_ptr
end

function play_sound( fmod_system : uint64, fmod_sound : uint64 ) : uint64
    local channel_ptr_wrap : [@WrapPointer] = [1:@WrapPointer]
    local res : uint64 = FMOD_System_PlaySound( fmod_system, -1, fmod_sound, false, channel_ptr_wrap)
    if (res ~= FMOD_OK) then
        log_error("could not play sound: ")
--        io.println(res)
        -- log_error("(" .. path .. ") could not create sound: " .. FMOD_ErrorString(res))
    end
    return channel_ptr_wrap[0].ptr;
end

local line1: String = "SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL"
local line2: String = "awesome scroller! check it... - leet haxxxx - very lua - much types"
local line3: String = "awesome scroller - check it"

local mesh_vbo : uint32 = 0u32

!main
function main(args:[String]): int

    create_lut()

    -- chdir("/Users/svenandersson/Documents/development/demo/")

    if (glfwInit() == 0) then
        return -1
    end

    -- get a ogl >= 3.2 context on OSX
    -- lets us use layout(location = x)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3u32);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2u32);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    window = glfwCreateWindow( 800, 600, "sol", 0u64, 0u64)

    if (window ~= 0u64) then
        glfwShowWindow( window )

        -- init audio and load sound
        local sound_system = init_audio()
        local drum_sound = load_sound( sound_system, "data/music/skadad.mp3" )
        music_channel = play_sound( sound_system, drum_sound )

        local vertex_src : String = read_file_as_string("data/shaders/shader.vp")
        -- io.println("vertex_src: " .. vertex_src)
        local fragment_src : String = read_file_as_string("data/shaders/shader.fp")
        -- io.println("fragment_src: " .. fragment_src)

        local shader = create_shader( vertex_src, fragment_src )
        local quad = create_quad()
        local qb : QuadBatch = create_quad_batch( 1024 )
        qb_begin(qb)
        -- qb_add( qb, -100.0f, -100.0f, 100.0f, 100.0f, 0.0f, 0.0f, 1.0f, 1.0f )
        qb_text(qb, 0.0f, 220.0f, line1, 16.0f, 12.0f)
        qb_text(qb, 100.0f, 160.0f, line2, 32.0f, 24.0f)
        qb_text(qb, 0.0f, 80.0f, line1, 16.0f, 12.0f)
        -- qb_add( qb, -1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f )
        qb_end( qb )


        -- load logo mesh
        -- mesh_vbo = create_mesh_from_file( "test" )
        -- mesh_vbo = create_mesh( "test" )

        local alt_text : QuadBatch = create_quad_batch( 1024 )
        qb_begin(alt_text)
        qb_text(alt_text, 160.0f-16.0f*5.5f , 5.0f, "DEFOLD CREW", 32.0f, 16.0f)
        qb_end(alt_text)

        -- setup()
        local tex0_data : [byte] = read_file( "data/textures/consolefont.raw" )
        local tex0 = create_texture(256, 256, tex0_data)
        --[[
        local tex0 = create_texture(2, 1, [255u8,0u8,0u8,255u8,
                                           0u8,255u8,0u8,255u8,
                                           0u8,0u8,255u8,255u8,
                                           255u8,255u8,255u8,255u8])
        ]]

        local anim = 0.0f
        local last_time_stamp = glfwGetTime()

        -- init scenes
        -- scene_particle_init()
        -- run_particle_test()
        run_floor()
    else
        io.println("could not create window!")
    end

    -- release scenes
    scene_particle_release()

    glfwTerminate()
    io.println("glfw terminated!")

    return 0
end
