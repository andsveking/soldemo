module glfw

CONTEXT_VERSION_MAJOR : uint32 = 0x00022002u32
CONTEXT_VERSION_MINOR : uint32 = 0x00022003u32
OPENGL_FORWARD_COMPAT : uint32 = 0x00022006u32
OPENGL_PROFILE        : uint32 = 0x00022008u32
OPENGL_CORE_PROFILE   : uint32 = 0x00032001u32

fn create_window(width: int, height: int, title: String, monitor: uint64, share: uint64): Window
    return Window{ glfwCreateWindow(width, height, title, monitor, share) }
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
extern window_hint(target: uint32, hint: uint32)


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
        return glfwWindowShouldClose(self.window) <= 0
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
end


!nogc !symbol("glfwCreateWindow")
local extern glfwCreateWindow(width : int, height : int, title: String, monitor: uint64, share: uint64): uint64

!nogc
local extern glfwMakeContextCurrent(window : uint64)

!nogc
local extern glfwShowWindow(window : uint64)

!nogc
local extern glfwSwapBuffers(window : uint64)

!nogc
local extern glfwWindowShouldClose(window : uint64): int

!nogc
local extern glfwSetWindowShouldClose(window : uint64, x: int)

!nogc
local extern glfwGetMouseButton(window: uint64, button: int): int

!nogc
local extern glfwGetFramebufferSize(window: uint64, width: Wrap<int>, height: Wrap<int>)

!nogc
local extern glfwGetWindowSize(window : uint64, width: Wrap<int>, height: Wrap<int>)


struct Wrap<T>
    local value: T
end
