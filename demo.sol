module demo

require io

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
extern C
    -- GLFW
    function glfwInit():int
    function glfwCreateWindow(  width : int, height : int, title:[uint8], monitor : uint64, share : uint64 ) : uint64
    function glfwShowWindow( window : uint64 )
    function glfwTerminate()
    function glfwSwapBuffers( window : uint64 )
    function glfwPollEvents()
    function glfwWindowShouldClose( window : uint64 ) : int
    function glfwSetWindowShouldClose( window : uint64, int )
    function glfwWindowHint( target : uint32, hint : uint32 )

    function glfwGetMouseButton(window : uint64, button : int ) : int
    function glfwGetFramebufferSize(window : uint64, width : [int], height : [int] )
    function glfwGetWindowSize(window : uint64, width : [int], height : [int] )
    function glfwGetTime() : double

    -- OpenGL
    function glGetError() : uint32
    function glViewport( x : int, y : int, width : int, height : int )
    function glClear( mask : uint32 )
    function glClearColor( red : float, green : float, blue : float, alpha : float )
    function glEnable( cap : uint32 )
    function glDisable( cap : uint32 )
    function glBlendFunc( sfactor : uint32, dfactor : uint32 )

        -- OGL: Shaders
        function glCreateShader( shaderType : uint32 ) : uint32
        function glCreateProgram() : uint32
        -- !nogc function glShaderSource( shader : uint32, count : uint64, lines : [String], length : [uint32] )
        function glShaderSource( shader : uint32, count : uint64, lines : [@String], length : uint32 )
        function glCompileShader( shader : uint32 )
        function glAttachShader( program : uint32, shader : uint32 )
        function glLinkProgram( program : uint32 )
        function glUseProgram( program : uint32 )
        function glIsShader( obj : uint32 ) : bool
        function glGetShaderiv( shader : uint32, pname : uint32, params : [int])
        function glGetProgramiv( shader : uint32, pname : uint32, params : [int])
        function glGetShaderInfoLog( shader : uint32, maxLength : int, length : [int], infoLog : [byte])
        function glGetProgramInfoLog( shader : uint32, maxLength : int, length : [int], infoLog : [byte])
        function glGetUniformLocation( program : uint32, name : [byte]) : int
        function glUniform4fv( location : int, count : int, value : [float] )
        function glUniform1f( location : int, v0 : float )
        function glUniform1i( location : int, v0 : int )
        function glUniformMatrix4fv( location : int, count : int, transpose : bool, value : [float] )

        -- OGL: Geometry
        function glGenBuffers( n : int, buffers : [uint32] )
        function glGenVertexArrays( n : int, buffers : [uint32] )
        function glBindBuffer( target : uint32, buffer : uint32 )
        function glBindVertexArray( array : uint32 )
        function glBufferData( target : uint32, size : int, data : [float], usage : uint32)
        -- function glBufferData( target : uint32, size : int, data : [byte], usage : uint32)
        function glDrawArrays( mode : uint32, first : uint32, count : int )
        function glEnableVertexAttribArray( index : int )
        function glDisableVertexAttribArray( index : int )
        function glVertexAttribPointer( index : uint32, size : int, type : uint32, normalized : bool, stride : int, pointer : int )

        -- OGL: Textures
        function glGenTextures( n : int, textures : [uint32] )
        function glBindTexture( target : uint32, texture : uint32)
        function glTexImage2D( target : uint32, level : int, internalFormat : uint32, width : int, height : int, border : int, format : uint32, type : uint32, data : [byte])
        function glTexParameteri( target : uint32, pname : uint32, param : uint32 )

    -- FMOD: Core
    -- function FMOD_ErrorString(errcode : uint64) : String
    function FMOD_System_Create(system : [@WrapPointer]) : uint64
    function FMOD_System_Init(system : uint64, maxchannels : int, flags : uint64, extradriverdata : uint64) : uint64
    function FMOD_System_CreateSound(system : uint64, path : [byte], mode : uint64, exinfo : uint64, sound : [@WrapPointer]) : uint64
    function FMOD_System_PlaySound(system : uint64, channelid : int, sound : uint64, paused : bool, channel : [@WrapPointer]) : uint64

    -- C Std funcs
    function fopen( filename : [byte], mode : [byte] ) : uint64
    function fseek( stream : uint64, offset : int64, whence : int ) : int
    function ftell( stream : uint64 ) : int
    function fclose( stream : uint64 ) : int
    function fread( ptr : [byte], size : int, count : int, stream : uint64) : int64
    function chdir(path : String) : int
    function rand() : int
    function sin(a : double) : double
    function cos(a : double) : double

end

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

local GL_TEXTURE_MAG_FILTER : uint32 = 0x2800u32
local GL_TEXTURE_MIN_FILTER : uint32 = 0x2801u32
local GL_NEAREST            : uint32 = 0x2600u32
local GL_LINEAR             : uint32 = 0x2601u32

local SEEK_SET            : int = 0
local SEEK_CUR            : int = 1
local SEEK_END            : int = 2

local RAND_MAX            : int = 2147483647

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
    return float(C.rand()) / float(RAND_MAX)
end


function check_error( id : String, print_on_ok : bool ) : bool
    local err = C.glGetError()
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
    if (C.glIsShader(obj)) then
        C.glGetShaderiv( obj, GL_INFO_LOG_LENGTH, size )
    else
        C.glGetProgramiv( obj, GL_INFO_LOG_LENGTH, size )
    end
    if (size[0] == 0) then
        return
    end

    local sub_sizes:[int] = [1:int]
    local data:[byte] = [size[0]:byte]
    if (C.glIsShader(obj)) then
        C.glGetShaderInfoLog( obj, size[0], sub_sizes, data)
    else
        C.glGetProgramInfoLog( obj, size[0], sub_sizes, data)
    end

    io.println("Shader log:\n" .. String { bytes = data } )
end

function read_file( file_path : String ) : [byte]
    local f = C.fopen( file_path.bytes, "r".bytes )

    if (f ~= 0u64) then

        C.fseek( f, 0i64, SEEK_END )
        local len : int = C.ftell( f ) + 1
        local ret : [byte] = [len:byte]
        C.fseek( f, 0i64, SEEK_SET)
        -- FIXME make sure we read the whole file...
        C.fread( ret, 1, len, f )
        C.fclose( f );

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
    local ret : String = String { bytes = read_file( file_path ) }
    return ret
end

------------------------------------------------------------------------
-- "Resources"
function create_texture( width : int, height : int, data : [byte] ) : uint32
    local textures : [uint32] = [1:uint32]
    C.glGenTextures( 1, textures )
    check_error("creating texture", true )
    local texture : uint32 = textures[0]

    C.glBindTexture( GL_TEXTURE_2D, texture )
    check_error("bound texture", false )

    C.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
    C.glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )

    C.glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data )
    check_error("uploaded texture data", true )

    C.glBindTexture( GL_TEXTURE_2D, 0u32 )
    check_error("unbound texture", false )

    return texture
end

function create_quad_batch( capacity : int ) : QuadBatch
    local qb : QuadBatch = QuadBatch { vert_gl  = 0u32,
                                       uv_gl    = 0u32,
                                       vert_buf = [capacity*2*6:float],
                                       uv_buf   = [capacity*2*6:float],
                                       capacity = capacity,
                                       cursor   = 0 }

    -- generate gl buffers
    local buffers : [uint32] = [2:uint32]
    C.glGenBuffers(2, buffers)
    qb.vert_gl = buffers[0]
    qb.uv_gl   = buffers[1]

    local vao : [uint32] = [1:uint32]
    C.glGenVertexArrays( 1, vao )
    qb.vao = vao[0]

    C.glBindVertexArray(qb.vao)
    C.glEnableVertexAttribArray( 0 )
    C.glBindBuffer( GL_ARRAY_BUFFER, qb.vert_gl )
    C.glVertexAttribPointer(0u32, 2, GL_FLOAT, false, 0, 0)
    C.glBindVertexArray(0u32)

    return qb
end

function qb_begin( qb : QuadBatch )
    qb.cursor = 0
end

function qb_end( qb : QuadBatch )

    local i : int = qb.cursor*2*6

    C.glBindVertexArray(qb.vao)

    C.glEnableVertexAttribArray( 0 )
    C.glBindBuffer( GL_ARRAY_BUFFER, qb.vert_gl )
    check_error( "qb_render: binding vert buffer", false )
    C.glBufferData( GL_ARRAY_BUFFER, i*4, qb.vert_buf, GL_STATIC_DRAW )
    check_error( "qb_render: upload vert buffer", false )
    C.glVertexAttribPointer(0u32, 2, GL_FLOAT, false, 0, 0)

    C.glEnableVertexAttribArray( 1 )
    C.glBindBuffer( GL_ARRAY_BUFFER, qb.uv_gl )
    check_error( "qb_render: binding uv buffer", false )
    C.glBufferData( GL_ARRAY_BUFFER, i*4, qb.uv_buf, GL_STATIC_DRAW )
    check_error( "qb_render: upload uv buffer", false )
    C.glVertexAttribPointer(1u32, 2, GL_FLOAT, false, 0, 0)

    C.glBindVertexArray(0u32)
end

function qb_render( qb : QuadBatch )


    C.glBindVertexArray(qb.vao)
    C.glDrawArrays( GL_TRIANGLES, 0u32, qb.cursor*6 );


end

function qb_add( qb : QuadBatch, x0 : float, y0 : float, x1 : float, y1 : float, u0 : float, v0 : float, u1 : float, v1 : float )

    --[[

    d - c
    | / |
    a - b

    ]]

    local i : int = qb.cursor*2*6 -- (x,y) * vert_count * triangle_count_per_quad

    -- vertices
    -- tri A: a,b,c
    qb.vert_buf[i+ 0] = x0
    qb.vert_buf[i+ 1] = y0

    qb.vert_buf[i+ 2] = x1
    qb.vert_buf[i+ 3] = y0

    qb.vert_buf[i+ 4] = x1
    qb.vert_buf[i+ 5] = y1

    -- tri B: a,c,d
    qb.vert_buf[i+ 6] = x0
    qb.vert_buf[i+ 7] = y0

    qb.vert_buf[i+ 8] = x1
    qb.vert_buf[i+ 9] = y1

    qb.vert_buf[i+10] = x0
    qb.vert_buf[i+11] = y1

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
    C.glGenBuffers( 1, buffers )
    check_error("creating geo buffers", true )
    C.glBindBuffer( GL_ARRAY_BUFFER, buffers[0] )
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

    C.glBufferData( GL_ARRAY_BUFFER, 6*2*4, data, GL_STATIC_DRAW )
    check_error( "loading geo buffers", true )

    local vao : [uint32] = [1:uint32]
    C.glGenVertexArrays( 1, vao );
    C.glBindVertexArray(vao[0]);

    C.glEnableVertexAttribArray( 0 )
    C.glBindBuffer( GL_ARRAY_BUFFER, buffers[0] )
    C.glVertexAttribPointer(0u32, 2, GL_FLOAT, false, 0, 0);

    -- return buffers[0]
    return vao[0]
end

function create_shader( vert_src : String, frag_src : String ) : uint32
    local vert = C.glCreateShader( GL_VERTEX_SHADER )
    local frag = C.glCreateShader( GL_FRAGMENT_SHADER )
    local shader = C.glCreateProgram()
    check_error("create programs", true)

    local a : [@String] = [1:@String]
    a[0] = vert_src
    C.glShaderSource( vert, 1u64, a, 0u32 )
    check_error("shader vert source", true)
    C.glCompileShader( vert )
    check_error("shader vert compile", true)
    shader_log( vert )

    local a : [@String] = [1:@String]
    a[0] = frag_src
    C.glShaderSource( frag, 1u64, a, 0u32 )
    check_error("shader frag source", true)
    C.glCompileShader( frag )
    check_error("shader frag compile", true)
    shader_log( frag )

    C.glAttachShader( shader, vert )
    check_error("shader attach vert", true)
    C.glAttachShader( shader, frag )
    check_error("shader attach frag", true)

    C.glLinkProgram( shader )
    check_error("shader link", true)
    shader_log( shader )

    return shader
end

function ortho_mtx( l : float, r : float, b : float, t : float, n : float, f : float ) : [float]
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

function ident_mtx() : [float]
    local mtx : [float] = [16:float]

    mtx[0] = 1.0f
    mtx[1] = 0.0f
    mtx[2] = 0.0f
    mtx[3] = 0.0f
    mtx[4] = 0.0f
    mtx[5] = 1.0f
    mtx[6] = 0.0f
    mtx[7] = 0.0f
    mtx[8] = 0.0f
    mtx[9] = 0.0f
    mtx[10] = 1.0f
    mtx[11] = 0.0f
    mtx[12] = 0.0f
    mtx[13] = 0.0f
    mtx[14] = 0.0f
    mtx[15] = 1.0f

    return mtx
end

-- ugly LUT
local lut_u : [float] = [16*16:float]
local lut_v : [float] = [16*16:float]
function create_lut()
    local delta = 16.0f / 256.0f

    local u = 0.0f
    local v = 0.0f

    local y = 0
    local x = 0
    while (y < 16) do
        while (x < 16) do

            lut_u[y*16+x] = u
            lut_v[y*16+x] = v

            u = u + delta
            x = x + 1
        end

        u = 0.0f
        v = v + delta
        x = 0
        y = y + 1
    end
    -- for y=0,16 do
    --     for x=0,16 do
    --         print(x)
    --         print(y)
    --     end
    -- end
end

function qb_text( qb : QuadBatch, start_x : float, start_y : float, txt : String, char_w : float, spacing : float )

    local delta = 16.0f / 256.0f
    local i = 0
    local x = start_x
    while (txt.bytes[i] ~= 0u8) do
        -- local b : float = i
        -- io.print(txt.bytes[i])

        local u0 = lut_u[txt.bytes[i]]
        local v0 = lut_v[txt.bytes[i]]
        local u1 = u0 + delta
        local v1 = v0 + delta

        qb_add_centered( qb, x, start_y, char_w, char_w, u0, v1, u1, v0 )
        -- qb_add( qb, x, start_y, x + char_w, start_y + char_w, u0, v1, u1, v0 )

        i = i + 1
        x = x + spacing
    end

end


--------------------------------------------------------------
-- scenes??
local apa : String = "asd"
local particle_shader : uint32
local particle_qb : QuadBatch
-- local particle_mtx : [float] = ortho_mtx( 0.0f, 320.0f, 0.0f, 320.0f, 0.0f, 1.0f)
local particle_amount : int = 1024*10
local particle_loc_mtx : int

struct Particle
    local pos : @[3:float]
    local vel : @[3:float]
end

local particle_buf : [@Particle] = [particle_amount:@Particle]

function scene_particle_init()

    local vertex_src : String = read_file_as_string("data/shaders/particle.vp")
    local fragment_src : String = read_file_as_string("data/shaders/particle.fp")

    particle_shader = create_shader( vertex_src, fragment_src )
    check_error("(particle) create shader", false)
    particle_loc_mtx = C.glGetUniformLocation( particle_shader, "mtx".bytes )
    check_error("(particle) getting locations", false)

    particle_qb = create_quad_batch( particle_amount )

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
    local i : int = 0
    while (i < particle_amount) do

        particle_buf[i].pos[0] = 0.0f
        -- particle_buf[i].pos[0] = (random() * 2.0f - 1.0f) * 320.0f
        particle_buf[i].pos[1] = 0.0f
        -- particle_buf[i].pos[1] = (random() * 2.0f - 1.0f) * 320.0f
        particle_buf[i].pos[2] = 0.0f

        local angle = random() * 3.14f * 2.0f
        local asd = random() * 10.0f
        particle_buf[i].vel[0] = float(C.sin(double(angle))) * asd
        particle_buf[i].vel[1] = float(C.cos(double(angle))) * asd
        particle_buf[i].vel[2] = 0.0f

        i = i + 1
    end

end

function scene_particle_draw( window : uint64, delta : double )
    local width  : [int] = [1:int]
    local height : [int] = [1:int]
    C.glfwGetFramebufferSize( window, width, height )
    local widthf : float = float(width[0])
    local heightf : float = float(height[0])

    local deltaf : float = float(delta)
    -- io.println(widthf)
    local particle_mtx = ortho_mtx( -widthf / 2.0f, widthf / 2.0f, -heightf / 2.0f, heightf / 2.0f, 0.0f, 1.0f)

    qb_begin( particle_qb )
    -- qb_add_centered( particle_qb, widthf / 2.0f, heightf / 2.09f, widthf, heightf, 0.0f, 0.0f, 1.0f, 1.0f )
    local i : int = 0
    while (i < particle_amount) do

        particle_buf[i].pos[0] = particle_buf[i].pos[0] + deltaf*particle_buf[i].vel[0]
        particle_buf[i].pos[1] = particle_buf[i].pos[1] + deltaf*particle_buf[i].vel[1]
        particle_buf[i].pos[2] = particle_buf[i].pos[2] + deltaf*particle_buf[i].vel[2]

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

    C.glUseProgram(particle_shader)
    C.glUniformMatrix4fv(particle_loc_mtx, 1, true, particle_mtx)
    qb_render( particle_qb )

end

function scene_particle_release()

    apa = ""

end

--------------------------------------------------------------
--
function setup()
    -- create shader

    -- create_quad()

end

function render( window : uint64, delta : double )
    local width  : [int] = [1:int]
    local height : [int] = [1:int]
    C.glfwGetFramebufferSize( window, width, height )
    -- C.glfwGetWindowSize( window, width, height )


    -- local ortho_mtx = ortho_mtx( 0, width, 0, height, -1.0f, 1.0f )

    C.glViewport(0,0,width[0],height[0])
    C.glClearColor(0.2f, 0.2f, 0.2f, 1.0f)
    C.glClear( GL_COLOR_BUFFER_BIT )
    C.glEnable( GL_BLEND )
    C.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    C.glDisable( GL_DEPTH_TEST )
    C.glDisable( GL_CULL_FACE )

    scene_particle_draw( window, delta )


end

function init_audio() : uint64
    local system_ptr_wrap : [@WrapPointer] = [1:@WrapPointer]
    if (C.FMOD_System_Create(system_ptr_wrap) ~= FMOD_OK) then
        log_error("could not create FMOD system")
        return 0u64
    end
    local fmod_system = system_ptr_wrap[0].ptr

    if (C.FMOD_System_Init(fmod_system, 32, 0u64, 0u64) ~= FMOD_OK) then
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
    local res : uint64 = C.FMOD_System_CreateSound( fmod_system, path.bytes, 0x40u64, 0u64, sound_ptr_wrap)

    if (res ~= FMOD_OK) then
        log_error("(" .. path .. ") could not create sound: ")
        io.println(res)
        -- log_error("(" .. path .. ") could not create sound: " .. C.FMOD_ErrorString(res))
        return 0u64
    end

    local sound_ptr = sound_ptr_wrap[0].ptr

    return sound_ptr
end

function play_sound( fmod_system : uint64, fmod_sound : uint64 )
    local channel_ptr_wrap : [@WrapPointer] = [1:@WrapPointer]
    local res : uint64 = C.FMOD_System_PlaySound( fmod_system, -1, fmod_sound, false, channel_ptr_wrap)
    if (res ~= FMOD_OK) then
        log_error("could not play sound: ")
        io.println(res)
        -- log_error("(" .. path .. ") could not create sound: " .. C.FMOD_ErrorString(res))
    end
end


local line1 : String = "SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL \x03 SOL"
local line2 : String = "awesome scroller! check it... - leet haxxxx - very lua - much types"
local line3 : String = "awesome scroller - check it"

!main
function main(): int

    create_lut()

    -- C.chdir("/Users/svenandersson/Documents/development/demo/")

    if (C.glfwInit() == 0) then
        return -1
    end

    -- get a ogl >= 3.2 context on OSX
    -- lets us use layout(location = x)
    C.glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3u32);
    C.glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2u32);
    C.glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    C.glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    local window = C.glfwCreateWindow( 320, 320, "sol".bytes, 0u64, 0u64)

    if (window ~= 0u64) then
        C.glfwShowWindow( window )

        -- init audio and load sound
        local sound_system = init_audio()
        local drum_sound = load_sound( sound_system, "data/music/skadad.mp3" )
        play_sound( sound_system, drum_sound )

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
        local last_time_stamp = C.glfwGetTime()

        -- init scenes
        scene_particle_init()

        while C.glfwWindowShouldClose( window ) <= 0 do


            local delta = C.glfwGetTime() - last_time_stamp
            last_time_stamp = C.glfwGetTime()

            render( window, delta )


            --[[
            C.glBindTexture( GL_TEXTURE_2D, tex0 )

            C.glUseProgram(shader)
            if (not check_error("shader use", false)) then
                C.glfwSetWindowShouldClose( window, 1 )
            end

            -- local ortho_mtx = ident_mtx()
            -- local ortho_mtx = ortho_mtx( -1.0f, 1.0f, -1.0f, 1.0f, -1.0f, 1.0f )
            local ortho_mtx = ortho_mtx( 0.0f, 320.0f, 0.0f, 320.0f, 0.0f, 1.0f )
            local location_mtx = C.glGetUniformLocation( shader, "mtx".bytes )
            local location_anim = C.glGetUniformLocation( shader, "anim".bytes )
            local location_offset = C.glGetUniformLocation( shader, "offset".bytes )
            local location_mode = C.glGetUniformLocation( shader, "mode".bytes )
            check_error("getting locations", false)

            -- C.glUniform4fv(2, 1, ortho_mtx)
            C.glUniformMatrix4fv(location_mtx, 1, true, ortho_mtx)
            check_error("bind mtx", false)
            C.glUniform1f(location_anim, anim)

            C.glUniform1i(location_mode, 0)
            qb_render( qb )
            C.glUniform1i(location_mode, 1)
            C.glUniform1f(location_offset, 1.0f)
            qb_render( alt_text )
            C.glUniform1f(location_offset, 2.0f)
            qb_render( alt_text )
            C.glUniform1f(location_offset, 3.0f)
            qb_render( alt_text )
            C.glUniform1f(location_offset, 4.0f)
            qb_render( alt_text )
            C.glUniform1f(location_offset, 5.0f)
            qb_render( alt_text )
            C.glUniform1f(location_offset, 6.0f)
            qb_render( alt_text )
            -- C.glBindVertexArray(quad);
            -- C.glDrawArrays( GL_TRIANGLES, 0u32, 6u32 );
            -- if (not check_error("draw arrays", false)) then
                -- C.glfwSetWindowShouldClose( window, 1 )
            -- end

            ]]

            -- anim = anim + 0.6f
            anim = anim + 60.0f * float(delta)

            if (C.glfwGetMouseButton(window, 0) == 1) then
                io.println "pressed"
            end

            C.glfwSwapBuffers(window)
            C.glfwPollEvents()
        end
    else
        io.println "could not create window!"
    end

    -- release scenes
    scene_particle_release()

    C.glfwTerminate()
    io.println "glfw terminated!"

    return 0
end
