import emscripten
import via.libs.flextgl
import via.libs.sdl2
import via.libs.sokol
import via.libs.sokol.gfx

struct State{
mut:
	window voidptr
	quit bool
	pass_action sg_pass_action
}


fn init_sdl() &State {
	C.SDL_Init(C.SDL_INIT_VIDEO)

	$if !webgl? {
		C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
		C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
		C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
		C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 3)
	}

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	win := C.SDL_CreateWindow("V SDL2 + OpenGL3 + Sokol", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 500, 300, C.SDL_WINDOW_OPENGL)
	gl_context := C.SDL_GL_CreateContext(win)
	flextgl.flext_init()

	sg_setup(&sg_desc{})

	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 1.0
	color_action.val[1] = 0.5
	color_action.val[2] = 1.0
	color_action.val[3] = 1.0

	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = color_action

	return &State{
		window: win
		pass_action: pass_action
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

	g := state.pass_action.colors[0].val[1] + 0.01
	state.pass_action.colors[0].val[1] = if g > 1.0 { 0.0 } else { g }

	w := 0
	h := 0
	SDL_GL_GetDrawableSize(state.window, &w, &h)

	sg_begin_default_pass(&state.pass_action, w, h)
	sg_end_pass()
	sg_commit()

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
