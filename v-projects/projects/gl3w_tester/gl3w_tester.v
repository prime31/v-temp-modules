import prime31.sdl2
import prime31.gl3w

fn main() {
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_JOYSTICK)

    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 2)

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	window_flags := C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	window := C.SDL_CreateWindow("V gl3w", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 1024, 768, window_flags)
	gl_context := C.SDL_GL_CreateContext(window)

	C.SDL_GL_MakeCurrent(window, gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync

	C.gl3wInit()

	mut alive := true
	for alive {
		ev := sdl2.Event{}
		for 0 < C.SDL_PollEvent(&ev) {
			match int(ev._type) {
				C.SDL_QUIT {
					alive = false
					break
				}
			}
		}
	}

    C.SDL_GL_DeleteContext(gl_context)
    C.SDL_DestroyWindow(window)
    C.SDL_Quit()
}