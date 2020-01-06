import prime31.sdl2
import prime31.flextgl
import via.sokol
import via.sokol.gfx

struct AppState {
mut:
	window voidptr
	pass_action sg_pass_action
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 1.0
	color_action.val[1] = 1.0
	color_action.val[2] = 1.0
	color_action.val[3] = 1.0

	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = color_action

	mut state := AppState{
		pass_action: pass_action
	}

	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO)

    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 3)

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	window_flags := C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	state.window = C.SDL_CreateWindow("V SDL2 + OpenGL3 + Sokol demo", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 1024, 768, window_flags)
	gl_context := C.SDL_GL_CreateContext(state.window)

	C.SDL_GL_MakeCurrent(state.window, gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync

	flextgl.flext_init()

	sg_setup(&sg_desc{})

	mut done := false
	for !done {
		ev := SDL_Event{}
		for 0 < C.SDL_PollEvent(&ev) {
			match int(ev.@type) {
				C.SDL_QUIT {
					done = true
					break
				}
				else {}
			}
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
}