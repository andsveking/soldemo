module glfw

require C
require io

-- TODO should be an enums
type WindowHint = uint32
type WindowHintValue = int

let RESIZABLE: WindowHint = WindowHint{ 0x00020003 }
let VISIBLE: WindowHint = WindowHint{ 0x00020004 }
let DECORATED: WindowHint = WindowHint{ 0x00020005 }
let FOCUSED: WindowHint = WindowHint{ 0x00020001 }
let AUTO_ICONIFY: WindowHint = WindowHint{ 0x00020006 }
let FLOATING: WindowHint = WindowHint{ 0x00020007 }
let MAXIMIZED: WindowHint = WindowHint{ 0x00020008 }
let RED_BITS: WindowHint = WindowHint{ 0x00021001 }
let GREEN_BITS: WindowHint = WindowHint{ 0x00021002 }
let BLUE_BITS: WindowHint = WindowHint{ 0x00021003 }
let ALPHA_BITS: WindowHint = WindowHint{ 0x00021004 }
let DEPTH_BITS: WindowHint = WindowHint{ 0x00021005 }
let STENCIL_BITS: WindowHint = WindowHint{ 0x00021006 }
let ACCUM_RED_BITS: WindowHint = WindowHint{ 0x00021007 }
let ACCUM_GREEN_BITS: WindowHint = WindowHint{ 0x00021008 }
let ACCUM_BLUE_BITS: WindowHint = WindowHint{ 0x00021009 }
let ACCUM_ALPHA_BITS: WindowHint = WindowHint{ 0x0002100A }
let AUX_BUFFERS: WindowHint = WindowHint{ 0x0002100B }
let SAMPLES: WindowHint = WindowHint{ 0x0002100D }
let REFRESH_RATE: WindowHint = WindowHint{ 0x0002100F }
let STEREO: WindowHint = WindowHint{ 0x0002100C }
let SRGB_CAPABLE: WindowHint = WindowHint{ 0x0002100E }
let DOUBLEBUFFER: WindowHint = WindowHint{ 0x00021010 }
let CLIENT_API: WindowHint = WindowHint{ 0x00022001 }
let CONTEXT_CREATION_API: WindowHint = WindowHint{ 0x0002200B }
let CONTEXT_VERSION_MAJOR: WindowHint = WindowHint{ 0x00022002 }
let CONTEXT_VERSION_MINOR: WindowHint = WindowHint{ 0x00022003 }
let CONTEXT_ROBUSTNESS: WindowHint = WindowHint{ 0x00022005 }
let CONTEXT_RELEASE_BEHAVIOR: WindowHint = WindowHint{ 0x00022009 }
let OPENGL_FORWARD_COMPAT: WindowHint = WindowHint{ 0x00022006 }
let OPENGL_DEBUG_CONTEXT: WindowHint = WindowHint{ 0x00022007 }
let OPENGL_PROFILE: WindowHint = WindowHint{ 0x00022008 }


let TRUE: WindowHintValue = WindowHintValue{ 1 }
let FALSE: WindowHintValue = WindowHintValue{ 0 }
let DONT_CARE: WindowHintValue = WindowHintValue{ -1 }

let NO_API: WindowHintValue = WindowHintValue{ 0 }
let OPENGL_API: WindowHintValue = WindowHintValue{ 0x00030001i32 }
let OPENGL_ES_API: WindowHintValue = WindowHintValue{ 0x00030002i32 }

let NATIVE_CONTEXT_API: WindowHintValue = WindowHintValue{ 0x00036001i32 }
let EGL_CONTEXT_API: WindowHintValue = WindowHintValue{ 0x00036002i32 }

let NO_ROBUSTNESS: WindowHintValue = WindowHintValue{ 0 }
let NO_RESET_NOTIFICATION: WindowHintValue = WindowHintValue{ 0x00031001i32 }
let LOSE_CONTEXT_ON_RESET: WindowHintValue = WindowHintValue{ 0x00031002i32 }

let ANY_RELEASE_BEHAVIOR: WindowHintValue = WindowHintValue{ 0 }
let RELEASE_BEHAVIOR_FLUSH: WindowHintValue = WindowHintValue{ 0x00035001i32 }
let RELEASE_BEHAVIOR_NONE: WindowHintValue = WindowHintValue{ 0x00035002i32 }

let OPENGL_ANY_PROFILE: WindowHintValue = WindowHintValue{ 0 }
let OPENGL_CORE_PROFILE: WindowHintValue = WindowHintValue{ 0x00032001i32 }
let OPENGL_COMPAT_PROFILE: WindowHintValue = WindowHintValue{ 0x00032002i32 }



fn create_window(width: int, height: int, title: String): Window
    return Window{ glfwCreateWindow(width, height, title, C.uintptr(0u32), C.uintptr(0u32)) }
end

!nogc !symbol("glfwGetTime")
extern get_time(): double

!nogc !symbol("glfwInit")
extern init(): int

!nogc !symbol("glfwTerminate")
extern terminate()

!nogc !symbol("glfwPollEvents")
extern poll_events()

!nogc !symbol("glfwWindowHint")
extern window_hint(hint: WindowHint, value: int)

!nogc !symbol("glfwWindowHint")
extern window_hint(hint: WindowHint, value: WindowHintValue)

!nogc !symbol("glfwSwapInterval")
extern swap_interval(interval: int)


type Window = C.uintptr where

    fn is_valid(): bool
        return self.alias.as_uint64() ~= 0u64
    end

    fn show()
        glfwShowWindow(self)
    end

    fn swap_buffers()
        glfwSwapBuffers(self)
    end

    fn make_context_current()
        glfwMakeContextCurrent(self)
    end

    fn window_should_close(): bool
        return glfwWindowShouldClose(self) ~= 0
    end

    fn set_window_should_close(value: int)
        glfwSetWindowShouldClose(self, value)
    end

    fn get_mouse_button(button: int): int
        return glfwGetMouseButton(self, button)
    end

    fn get_framebuffer_size(): int, int
        let width = Ptr<int>{}
        let height = Ptr<int>{}
        glfwGetFramebufferSize(self, width, height)
        return width.value, height.value
    end

    fn get_window_size(): int, int
        let width = Ptr<int>{}
        let height = Ptr<int>{}
        glfwGetWindowSize(self, width, height)
        return width.value, height.value
    end

    fn set_title(title: String)
        glfwSetWindowTitle(self, title)
    end

    fn set_position(x: int, y: int)
        glfwSetWindowPos(self, x, y)
    end

    !noinline
    fn set_key_callback(callback: *(Key, int, Action, Mods)->())
        glfwSetWindowUserPointer(self, callback)
        glfwSetKeyCallback(self, *key_callback)
    end
end

local fn key_callback(window: Window, key: Key, scancode: int, action: Action, mods: Mods)
    let callback = glfwGetWindowUserPointer(window) as *(Key, int, Action, int)->()
    callback(key, scancode, action, mods)
end


!nogc
local extern glfwSetKeyCallback(window: Window, key_callback: *(Window, Key, int, Action, Mods)->())

!nogc
local extern glfwCreateWindow(width: int, height: int, title: String, monitor: C.uintptr, share: C.uintptr): C.uintptr

!nogc
local extern glfwMakeContextCurrent(window: Window)

!nogc
local extern glfwShowWindow(window: Window)

!nogc
local extern glfwSwapBuffers(window: Window)

!nogc
local extern glfwWindowShouldClose(window: Window): int

!nogc
local extern glfwSetWindowShouldClose(window: Window, x: int)

!nogc
local extern glfwGetMouseButton(window: Window, button: int): int

!nogc
local extern glfwGetFramebufferSize(window: Window, width: Ptr<int>, height: Ptr<int>)

!nogc
local extern glfwGetWindowSize(window: Window, width: Ptr<int>, height: Ptr<int>)

!nogc
local extern glfwSetWindowTitle(window: Window, title: String)

!nogc
local extern glfwSetWindowUserPointer(window: Window, pointer: handle)

!nogc
local extern glfwGetWindowUserPointer(window: Window): handle

!nogc
local extern glfwSetWindowPos(window: Window, x: int, y: int);

struct Ptr<T>
    local value: T
end


-- TODO desperately needing enum here!
type Action = int where
    fn is_release(): bool
        return self.alias == 0
    end

    fn is_press(): bool
        return self.alias == 1
    end

    fn is_repeat(): bool
        return self.alias == 2
    end
end


type Mods = uint32 where
    fn is_shift(): bool
        return self.alias | 0x01 ~= 0
    end

    fn is_ctrl(): bool
        return self.alias | 0x02 ~= 0
    end

    fn is_alt(): bool
        return self.alias | 0x04 ~= 0
    end

    fn is_super(): bool
        return self.alias | 0x08 ~= 0
    end
end


type Key = int where
    fn x(): int
        return self.alias
    end
end

fn == (a: Key, b: Key): bool
    return a.alias == b.alias
end

let KEY_UNKNOWN: Key = Key{ -1 }
let KEY_SPACE: Key = Key{ 32 }
let KEY_APOSTROPHE: Key = Key{ 39 }
let KEY_COMMA: Key = Key{ 44 }
let KEY_MINUS: Key = Key{ 45 }
let KEY_PERIOD: Key = Key{ 46 }
let KEY_SLASH: Key = Key{ 47 }
let KEY_0: Key = Key{ 48 }
let KEY_1: Key = Key{ 49 }
let KEY_2: Key = Key{ 50 }
let KEY_3: Key = Key{ 51 }
let KEY_4: Key = Key{ 52 }
let KEY_5: Key = Key{ 53 }
let KEY_6: Key = Key{ 54 }
let KEY_7: Key = Key{ 55 }
let KEY_8: Key = Key{ 56 }
let KEY_9: Key = Key{ 57 }
let KEY_SEMICOLON: Key = Key{ 59 }
let KEY_EQUAL: Key = Key{ 61 }
let KEY_A: Key = Key{ 65 }
let KEY_B: Key = Key{ 66 }
let KEY_C: Key = Key{ 67 }
let KEY_D: Key = Key{ 68 }
let KEY_E: Key = Key{ 69 }
let KEY_F: Key = Key{ 70 }
let KEY_G: Key = Key{ 71 }
let KEY_H: Key = Key{ 72 }
let KEY_I: Key = Key{ 73 }
let KEY_J: Key = Key{ 74 }
let KEY_K: Key = Key{ 75 }
let KEY_L: Key = Key{ 76 }
let KEY_M: Key = Key{ 77 }
let KEY_N: Key = Key{ 78 }
let KEY_O: Key = Key{ 79 }
let KEY_P: Key = Key{ 80 }
let KEY_Q: Key = Key{ 81 }
let KEY_R: Key = Key{ 82 }
let KEY_S: Key = Key{ 83 }
let KEY_T: Key = Key{ 84 }
let KEY_U: Key = Key{ 85 }
let KEY_V: Key = Key{ 86 }
let KEY_W: Key = Key{ 87 }
let KEY_X: Key = Key{ 88 }
let KEY_Y: Key = Key{ 89 }
let KEY_Z: Key = Key{ 90 }
let KEY_LEFT_BRACKET: Key = Key{ 91 }
let KEY_BACKSLASH: Key = Key{ 92 }
let KEY_RIGHT_BRACKET: Key = Key{ 93 }
let KEY_GRAVE_ACCENT: Key = Key{ 96 }
let KEY_WORLD_1: Key = Key{ 161 }
let KEY_WORLD_2: Key = Key{ 162 }
let KEY_ESCAPE: Key = Key{ 256 }
let KEY_ENTER: Key = Key{ 257 }
let KEY_TAB: Key = Key{ 258 }
let KEY_BACKSPACE: Key = Key{ 259 }
let KEY_INSERT: Key = Key{ 260 }
let KEY_DELETE: Key = Key{ 261 }
let KEY_RIGHT: Key = Key{ 262 }
let KEY_LEFT: Key = Key{ 263 }
let KEY_DOWN: Key = Key{ 264 }
let KEY_UP: Key = Key{ 265 }
let KEY_PAGE_UP: Key = Key{ 266 }
let KEY_PAGE_DOWN: Key = Key{ 267 }
let KEY_HOME: Key = Key{ 268 }
let KEY_END: Key = Key{ 269 }
let KEY_CAPS_LOCK: Key = Key{ 280 }
let KEY_SCROLL_LOCK: Key = Key{ 281 }
let KEY_NUM_LOCK: Key = Key{ 282 }
let KEY_PRINT_SCREEN: Key = Key{ 283 }
let KEY_PAUSE: Key = Key{ 284 }
let KEY_F1: Key = Key{ 290 }
let KEY_F2: Key = Key{ 291 }
let KEY_F3: Key = Key{ 292 }
let KEY_F4: Key = Key{ 293 }
let KEY_F5: Key = Key{ 294 }
let KEY_F6: Key = Key{ 295 }
let KEY_F7: Key = Key{ 296 }
let KEY_F8: Key = Key{ 297 }
let KEY_F9: Key = Key{ 298 }
let KEY_F10: Key = Key{ 299 }
let KEY_F11: Key = Key{ 300 }
let KEY_F12: Key = Key{ 301 }
let KEY_F13: Key = Key{ 302 }
let KEY_F14: Key = Key{ 303 }
let KEY_F15: Key = Key{ 304 }
let KEY_F16: Key = Key{ 305 }
let KEY_F17: Key = Key{ 306 }
let KEY_F18: Key = Key{ 307 }
let KEY_F19: Key = Key{ 308 }
let KEY_F20: Key = Key{ 309 }
let KEY_F21: Key = Key{ 310 }
let KEY_F22: Key = Key{ 311 }
let KEY_F23: Key = Key{ 312 }
let KEY_F24: Key = Key{ 313 }
let KEY_F25: Key = Key{ 314 }
let KEY_KP_0: Key = Key{ 320 }
let KEY_KP_1: Key = Key{ 321 }
let KEY_KP_2: Key = Key{ 322 }
let KEY_KP_3: Key = Key{ 323 }
let KEY_KP_4: Key = Key{ 324 }
let KEY_KP_5: Key = Key{ 325 }
let KEY_KP_6: Key = Key{ 326 }
let KEY_KP_7: Key = Key{ 327 }
let KEY_KP_8: Key = Key{ 328 }
let KEY_KP_9: Key = Key{ 329 }
let KEY_KP_DECIMAL: Key = Key{ 330 }
let KEY_KP_DIVIDE: Key = Key{ 331 }
let KEY_KP_MULTIPLY: Key = Key{ 332 }
let KEY_KP_SUBTRACT: Key = Key{ 333 }
let KEY_KP_ADD: Key = Key{ 334 }
let KEY_KP_ENTER: Key = Key{ 335 }
let KEY_KP_EQUAL: Key = Key{ 336 }
let KEY_LEFT_SHIFT: Key = Key{ 340 }
let KEY_LEFT_CONTROL: Key = Key{ 341 }
let KEY_LEFT_ALT: Key = Key{ 342 }
let KEY_LEFT_SUPER: Key = Key{ 343 }
let KEY_RIGHT_SHIFT: Key = Key{ 344 }
let KEY_RIGHT_CONTROL: Key = Key{ 345 }
let KEY_RIGHT_ALT: Key = Key{ 346 }
let KEY_RIGHT_SUPER: Key = Key{ 347 }
let KEY_MENU: Key = Key{ 348 }
