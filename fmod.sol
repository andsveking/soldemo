module fmod

fn system_create(): {Result, System}
    let system = Wrap<handle>{}
    let res = system_create(system)
    return {Result{res}, System{system.value}}
end


type System = handle where
    fn init(maxchannels: int, flags: uint64, extradriverdata: uint64): Result
        let res = system_init(self, maxchannels, flags, extradriverdata)
        return Result { res }
    end

    fn create_sound(path: String, mode: uint64, exinfo: uint64): {Result, Sound}
        let sound = Wrap<handle>{}
        let res = system_create_sound(self, path, mode, exinfo, sound)
        return {Result{res}, Sound{sound.value}}
    end

    fn play_sound(channelid: int, sound: Sound, paused: bool): {Result, Channel}
        let channel = Wrap<handle>{}
        let play_result = system_play_sound(self, channelid, sound, paused, channel)
        return {Result{play_result}, Channel{channel.value}}
    end
end


type Result = uint64

type Sound = handle

type Channel = handle where
    fn get_position(timeunit: uint64): uint32
        let tm = Wrap<uint32>{}
        channel_get_position(self, tm, 1u64)
        return tm.value
    end
end


let OK: Result = Result{ 0u64 }

let ERR_ALREADYLOCKED: Result = Result{ 1u64 }
let ERR_BADCOMMAND: Result = Result{ 2u64 }
let ERR_CDDA_DRIVERS: Result = Result{ 3u64 }
let ERR_CDDA_INIT: Result = Result{ 4u64 }
let ERR_CDDA_INVALID_DEVICE: Result = Result{ 5u64 }
let ERR_CDDA_NOAUDIO: Result = Result{ 6u64 }
let ERR_CDDA_NODEVICES: Result = Result{ 7u64 }
let ERR_CDDA_NODISC: Result = Result{ 8u64 }
let ERR_CDDA_READ: Result = Result{ 9u64 }
let ERR_CHANNEL_ALLOC: Result = Result{ 10u64 }
let ERR_CHANNEL_STOLEN: Result = Result{ 11u64 }
let ERR_COM: Result = Result{ 12u64 }
let ERR_DMA: Result = Result{ 13u64 }
let ERR_DSP_CONNECTION: Result = Result{ 14u64 }
let ERR_DSP_FORMAT: Result = Result{ 15u64 }
let ERR_DSP_NOTFOUND: Result = Result{ 16u64 }
let ERR_DSP_RUNNING: Result = Result{ 17u64 }
let ERR_DSP_TOOMANYCONNECTIONS: Result = Result{ 18u64 }
let ERR_FILE_BAD: Result = Result{ 19u64 }
let ERR_FILE_COULDNOTSEEK: Result = Result{ 20u64 }
let ERR_FILE_DISKEJECTED: Result = Result{ 21u64 }
let ERR_FILE_EOF: Result = Result{ 22u64 }
let ERR_FILE_NOTFOUND: Result = Result{ 23u64 }
let ERR_FILE_UNWANTED: Result = Result{ 24u64 }
let ERR_FORMAT: Result = Result{ 25u64 }
let ERR_HTTP: Result = Result{ 26u64 }
let ERR_HTTP_ACCESS: Result = Result{ 27u64 }
let ERR_HTTP_PROXY_AUTH: Result = Result{ 28u64 }
let ERR_HTTP_SERVER_ERROR: Result = Result{ 29u64 }
let ERR_HTTP_TIMEOUT: Result = Result{ 30u64 }
let ERR_INITIALIZATION: Result = Result{ 31u64 }
let ERR_INITIALIZED: Result = Result{ 32u64 }
let ERR_INTERNAL: Result = Result{ 33u64 }
let ERR_INVALID_ADDRESS: Result = Result{ 34u64 }
let ERR_INVALID_FLOAT: Result = Result{ 35u64 }
let ERR_INVALID_HANDLE: Result = Result{ 36u64 }
let ERR_INVALID_PARAM: Result = Result{ 37u64 }
let ERR_INVALID_POSITION: Result = Result{ 38u64 }
let ERR_INVALID_SPEAKER: Result = Result{ 39u64 }
let ERR_INVALID_SYNCPOINT: Result = Result{ 40u64 }
let ERR_INVALID_VECTOR: Result = Result{ 41u64 }
let ERR_MAXAUDIBLE: Result = Result{ 42u64 }
let ERR_MEMORY: Result = Result{ 43u64 }
let ERR_MEMORY_CANTPOINT: Result = Result{ 44u64 }
let ERR_MEMORY_SRAM: Result = Result{ 45u64 }
let ERR_NEEDS2D: Result = Result{ 46u64 }
let ERR_NEEDS3D: Result = Result{ 47u64 }
let ERR_NEEDSHARDWARE: Result = Result{ 48u64 }
let ERR_NEEDSSOFTWARE: Result = Result{ 49u64 }
let ERR_NET_CONNECT: Result = Result{ 50u64 }
let ERR_NET_SOCKET_ERROR: Result = Result{ 51u64 }
let ERR_NET_URL: Result = Result{ 52u64 }
let ERR_NET_WOULD_BLOCK: Result = Result{ 53u64 }
let ERR_NOTREADY: Result = Result{ 54u64 }
let ERR_OUTPUT_ALLOCATED: Result = Result{ 55u64 }
let ERR_OUTPUT_CREATEBUFFER: Result = Result{ 56u64 }
let ERR_OUTPUT_DRIVERCALL: Result = Result{ 57u64 }
let ERR_OUTPUT_ENUMERATION: Result = Result{ 58u64 }
let ERR_OUTPUT_FORMAT: Result = Result{ 59u64 }
let ERR_OUTPUT_INIT: Result = Result{ 60u64 }
let ERR_OUTPUT_NOHARDWARE: Result = Result{ 61u64 }
let ERR_OUTPUT_NOSOFTWARE: Result = Result{ 62u64 }
let ERR_PAN: Result = Result{ 63u64 }
let ERR_PLUGIN: Result = Result{ 64u64 }
let ERR_PLUGIN_INSTANCES: Result = Result{ 65u64 }
let ERR_PLUGIN_MISSING: Result = Result{ 66u64 }
let ERR_PLUGIN_RESOURCE: Result = Result{ 67u64 }
let ERR_PRELOADED: Result = Result{ 68u64 }
let ERR_PROGRAMMERSOUND: Result = Result{ 69u64 }
let ERR_RECORD: Result = Result{ 70u64 }
let ERR_REVERB_INSTANCE: Result = Result{ 71u64 }
let ERR_SUBSOUND_ALLOCATED: Result = Result{ 72u64 }
let ERR_SUBSOUND_CANTMOVE: Result = Result{ 73u64 }
let ERR_SUBSOUND_MODE: Result = Result{ 74u64 }
let ERR_SUBSOUNDS: Result = Result{ 75u64 }
let ERR_TAGNOTFOUND: Result = Result{ 76u64 }
let ERR_TOOMANYCHANNELS: Result = Result{ 77u64 }
let ERR_UNIMPLEMENTED: Result = Result{ 78u64 }
let ERR_UNINITIALIZED: Result = Result{ 79u64 }
let ERR_UNSUPPORTED: Result = Result{ 80u64 }
let ERR_UPDATE: Result = Result{ 81u64 }
let ERR_VERSION: Result = Result{ 82u64 }
let ERR_EVENT_FAILED: Result = Result{ 83u64 }
let ERR_EVENT_INFOONLY: Result = Result{ 84u64 }
let ERR_EVENT_INTERNAL: Result = Result{ 85u64 }
let ERR_EVENT_MAXSTREAMS: Result = Result{ 86u64 }
let ERR_EVENT_MISMATCH: Result = Result{ 87u64 }
let ERR_EVENT_NAMECONFLICT: Result = Result{ 88u64 }
let ERR_EVENT_NOTFOUND: Result = Result{ 89u64 }
let ERR_EVENT_NEEDSSIMPLE: Result = Result{ 90u64 }
let ERR_EVENT_GUIDCONFLICT: Result = Result{ 91u64 }
let ERR_EVENT_ALREADY_LOADED: Result = Result{ 92u64 }
let ERR_MUSIC_UNINITIALIZED: Result = Result{ 93u64 }
let ERR_MUSIC_NOTFOUND: Result = Result{ 94u64 }
let ERR_MUSIC_NOCALLBACK: Result = Result{ 95u64 }

fn == (a: Result, b: Result): bool
    return a.alias == b.alias
end

fn ~= (a: Result, b: Result): bool
    return a.alias ~= b.alias
end


!symbol("FMOD_System_Create") !nogc
local extern system_create(system : Wrap<handle>): uint64

!symbol("FMOD_System_Init") !nogc
local extern system_init(system: System, maxchannels: int, flags: uint64, extradriverdata: uint64): uint64

!symbol("FMOD_System_CreateSound") !nogc
local extern system_create_sound(system: System, path: String, mode: uint64, exinfo: uint64, sound: Wrap<handle>): uint64

!symbol("FMOD_System_PlaySound") !nogc
local extern system_play_sound(system: System, channelid: int, sound: Sound, paused: bool, channel: Wrap<handle>): uint64

!symbol("FMOD_Channel_GetPosition") !nogc
local extern channel_get_position(channelid: Channel, ms : Wrap<uint32>, timeunit: uint64)

local struct Wrap<T>
    local value: T
end



-- Not used!!

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
