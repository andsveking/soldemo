module glfw

require C

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


struct Window
    local window: uint64

    fn is_valid(): bool
        return self.window ~= 0u64
    end

    fn show()
        glfwShowWindow(self.window)
    end

    fn swap_buffers()
        glfwSwapBuffers(self.window)
    end

    fn make_context_current()
        glfwMakeContextCurrent(self.window)
    end

    fn window_should_close(): bool
        return glfwWindowShouldClose(self.window) ~= 0
    end

    fn set_window_should_close(value: int)
        glfwSetWindowShouldClose(self.window, value)
    end

    fn get_mouse_button(button: int): int
        return glfwGetMouseButton(self.window, button)
    end

    fn get_framebuffer_size(): int, int
        let width = Wrap<int>{}
        let height = Wrap<int>{}
        glfwGetFramebufferSize(self.window, width, height)
        return width.value, height.value
    end

    fn get_window_size(): int, int
        let width = Wrap<int>{}
        let height = Wrap<int>{}
        glfwGetWindowSize(self.window, width, height)
        return width.value, height.value
    end

    fn set_title(title: String)
        glfwSetWindowTitle(self.window, title)
    end
end


!nogc !symbol("glfwCreateWindow")
local extern glfwCreateWindow(width: int, height: int, title: String, monitor: C.uintptr, share: C.uintptr): uint64

!nogc
local extern glfwMakeContextCurrent(window: uint64)

!nogc
local extern glfwShowWindow(window: uint64)

!nogc
local extern glfwSwapBuffers(window: uint64)

!nogc
local extern glfwWindowShouldClose(window: uint64): int

!nogc
local extern glfwSetWindowShouldClose(window: uint64, x: int)

!nogc
local extern glfwGetMouseButton(window: uint64, button: int): int

!nogc
local extern glfwGetFramebufferSize(window: uint64, width: Wrap<int>, height: Wrap<int>)

!nogc
local extern glfwGetWindowSize(window: uint64, width: Wrap<int>, height: Wrap<int>)

!nogc
local extern glfwSetWindowTitle(window: uint64, title: String)


struct Wrap<T>
    local value: T
end
