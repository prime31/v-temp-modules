import via.libs.sdl2
import via.libs.flextgl
import via.libs.sokol
import via.libs.sokol.gfx

const (
	vert = '#version 330
in vec4 position;
in vec4 color0;
out vec4 color;
void main() {
  gl_Position = position;
  color = color0;
}'
	frag = '#version 330
in vec4 color;
out vec4 frag_color;
void main() {
  frag_color = color;
}'
)

struct AppState {
mut:
	window voidptr
	pass_action sg_pass_action
	pip sg_pipeline
	bind sg_bindings
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

	C.SDL_Init(C.SDL_INIT_VIDEO)

    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 3)

	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	C.SDL_GL_SetAttribute(C.SDL_GL_DEPTH_SIZE, 24)
	C.SDL_GL_SetAttribute(C.SDL_GL_STENCIL_SIZE, 8)

	C.SDL_SetHint(C.SDL_HINT_VIDEO_HIGHDPI_DISABLED, c'1')
	window_flags := C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_RESIZABLE | C.SDL_WINDOW_ALLOW_HIGHDPI
	state.window = C.SDL_CreateWindow("V SDL2 + OpenGL3 + Sokol demo", C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED, 1024, 768, window_flags)
	gl_context := C.SDL_GL_CreateContext(state.window)

	C.SDL_GL_MakeCurrent(state.window, gl_context)
	C.SDL_GL_SetSwapInterval(1) // Enable vsync

	flextgl.flext_init()

	sg_setup(&sg_desc{})
	state.setup_triangle()

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
		println('$w, $h')

		sg_begin_default_pass(&state.pass_action, w, h)
		sg_apply_pipeline(state.pip)
		sg_apply_bindings(&state.bind)
    	sg_draw(0, 3, 1)
		sg_end_pass()
		sg_commit()

		C.SDL_GL_SwapWindow(state.window)
	}
}

fn (state mut AppState) setup_triangle() {
	verts := [
		// positions        colors
         0.0, 0.5, 0.5,  1.0, 0.0, 0.0, 1.0,
         0.5, -0.5, 0.5, 0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5, 0.0, 0.0, 1.0, 1.0]!
	state.bind.vertex_buffers[0] = sg_make_buffer(&sg_buffer_desc{
		size: sizeof(f32) * verts.len
		content: verts.data
	})

	mut shader_desc := &sg_shader_desc{
		vs: sg_shader_stage_desc{
			source: vert.str
		}
		fs: sg_shader_stage_desc{
			source: frag.str
		}
	}
	shader_desc.attrs[0] = sg_shader_attr_desc{
		name: 'position'.str
	}
	shader_desc.attrs[1] = sg_shader_attr_desc{
		name: 'color0'.str
	}

	shd := sg_make_shader(shader_desc)

	mut layout := sg_layout_desc{}
	layout.attrs[0] = sg_vertex_attr_desc{
		format: C.SG_VERTEXFORMAT_FLOAT3
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: C.SG_VERTEXFORMAT_FLOAT4
	}

	state.pip = sg_make_pipeline(&sg_pipeline_desc{
		shader: shd
		layout: layout
	})
}