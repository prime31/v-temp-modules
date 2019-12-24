import prime31.sdl2
import prime31.sokol
import prime31.sokol.gfx
import metal

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

	C.SDL_SetHint(C.SDL_HINT_RENDER_DRIVER, 'metal')
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_AUDIO)
	window_flags := C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	state.window = C.SDL_CreateWindow("V SDL2 + Metal + Sokol demo", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 512, 384, window_flags)

	metal.shit(state.window)

	sg_setup(&sg_desc {
		mtl_device: C.get_metal_device()
		mtl_renderpass_descriptor_cb: C.get_render_pass_descriptor
		mtl_drawable_cb: C.get_drawable
	})

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

		sg_begin_default_pass(&state.pass_action, 512 * 2, 384 * 2)
		sg_end_pass()
		sg_commit()
	}
}