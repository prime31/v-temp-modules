import emscripten
import via.libs.flextgl
import via.libs.sdl2

struct State{
mut:
	window voidptr
	quit bool
}


fn init_sdl() &State {
	C.SDL_Init(C.SDL_INIT_VIDEO)

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	win := C.SDL_CreateWindow("V SDL2 + OpenGL3", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 500, 300, C.SDL_WINDOW_OPENGL)
	gl_context := C.SDL_GL_CreateContext(win)
	flextgl.flext_init()

	return &State{
		window: win
	}
}

fn main() {
	mut state := init_sdl()

	$if webgl? {
		emscripten_set_main_loop_arg(main_loop, voidptr(state), -1, 0)
	}

	$if !webgl? {
		for !state.quit {
			main_loop(voidptr(state))
		}
	}
}

fn main_loop(context voidptr) {
	mut state := &State(context)
	if poll_events() {
		state.quit = true
		C.SDL_Quit()
	}


	C.glClearColor(0.8, 0.5, 0.6, 1)
    C.glClear(C.GL_COLOR_BUFFER_BIT)
	C.SDL_GL_SwapWindow(state.window)
}

fn poll_events() bool {
	ev := SDL_Event{}
	for 0 < C.SDL_PollEvent(&ev) {
		match int(ev.@type) {
			C.SDL_QUIT {
				return true
			}
			C.SDL_WINDOWEVENT {
				if ev.window.event == C.SDL_WINDOWEVENT_CLOSE {
					return true
				}
			}
			else {}
		}
	}

	return false
}
