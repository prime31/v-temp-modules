import via.libs.sokol
import prime31.sokol.sapp
import via.libs.sokol.gfx
import via.libs.stb.image
import via.math
import rand

const (
	vert = '#version 330
uniform vec4 TransformMatrix[2];

layout (location=0) in vec2 VertPosition;
layout (location=1) in vec2 VertTexCoord;
layout (location=2) in vec4 VertColor;

out vec2 VaryingTexCoord;
out vec4 VaryingColor;

vec4 position(mat3x2 transMat, vec2 localPosition);

void main() {
	VaryingTexCoord = VertTexCoord;
	VaryingColor = VertColor;
	mat3x2 mat = mat3x2(TransformMatrix[0].xy, TransformMatrix[0].zw, TransformMatrix[1].xy);
	gl_Position = position(mat, VertPosition + TransformMatrix[1].zw);
}

vec4 position(mat3x2 transMat, vec2 localPosition) {
	return vec4(transMat * vec3(localPosition, 0), 0, 1);
}'
	frag = '#version 330
uniform sampler2D MainTex;

uniform mat4 TransformProjectionMatrix;
uniform vec4 via_ScreenSize;

in vec2 VaryingTexCoord;
in vec4 VaryingColor;

vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord);

layout (location=0) out vec4 frag_color;
void main() {
	frag_color = effect(VaryingColor, MainTex, VaryingTexCoord.st);
}

vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord) {
	return texture(tex, texcoord) * vcolor;
}'
)

struct AppState {
mut:
	pip sg_pipeline
	bind sg_bindings
	pass_action sg_pass_action
	rx f32
	ry f32
	trans_mat32 math.Mat32
	arr [8]f32

	checker_img C.sg_image
	beach_img C.sg_image
}

struct Vertex {
pub mut:
	pos math.Vec2
	texcoords math.Vec2
	color math.Color
}

fn main() {
	state := &AppState{
		pass_action: gfx.create_clear_pass(0.3, 0.3, 1.0, 1.0)
	}

	desc := sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		event_userdata_cb: on_event
		cleanup_cb: cleanup
		window_title: 'Jiggly Dynamic Quad'.str
	}
	sapp_run(&desc)
}

fn init(user_data voidptr) {
	mut state := &AppState(user_data)

	sg_setup(&sg_desc {
		mtl_device: C.sapp_metal_get_device()
		mtl_renderpass_descriptor_cb: sapp_metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp_metal_get_drawable
		d3d11_device: sapp_d3d11_get_device()
		d3d11_device_context: sapp_d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp_d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp_d3d11_get_depth_stencil_view
	})

	verts := [
		Vertex{ math.Vec2{-1,-1}, 	math.Vec2{0,0},		math.Color{} },
		Vertex{ math.Vec2{1,-1}, 	math.Vec2{1,0},		math.Color{} },
		Vertex{ math.Vec2{1,1}, 	math.Vec2{1,1},		math.Color{} },
		Vertex{ math.Vec2{-1,1}, 	math.Vec2{0,1},		math.Color{0xff0000ff} }
	]!

	vert_buff_desc := sg_buffer_desc{
		size: sizeof(Vertex) * verts.len
		content: verts.data
	}
	state.bind.vertex_buffers[0] = sg_make_buffer(&vert_buff_desc)

	indices := [u16(0), 1, 2, 0, 2, 3]!
	index_buff_desc := sg_buffer_desc{
        @type: .indexbuffer
        size: sizeof(u16) * indices.len
        content: indices.data
    }
	state.bind.index_buffer = sg_make_buffer(&index_buff_desc)
	state.bind.fs_images[0] = create_image()

	state.beach_img = state.bind.fs_images[0]
	state.checker_img = create_checker_image()

	// vert shader
	mut vs_desc := sg_shader_stage_desc{
		source: vert.str
	}

	vs_desc.uniform_blocks[0].size = sizeof(f32) * 8
	vs_desc.uniform_blocks[0].uniforms[0] = sg_shader_uniform_desc{
		name: 'TransformMatrix'.str
		@type: .float4
		array_count: 2
	}

	// frag shader
	mut fs_desc := sg_shader_stage_desc{
		source: frag.str
	}
	fs_desc.images[0] = sg_shader_image_desc{
		name: 'MainTex'.str // optional uniform name for single image shaders
		@type: ._2d
	}

	shader_desc := sg_shader_desc{
		vs: vs_desc
		fs: fs_desc
	}

	shd := sg_make_shader(&shader_desc)

	mut layout := sg_layout_desc{}
	layout.attrs[0] = sg_vertex_attr_desc{
		format: .float2
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: .float2
	}
	layout.attrs[2] = sg_vertex_attr_desc{
		format: .ubyte4n
	}

	state.pip = sg_make_pipeline(&sg_pipeline_desc{
		layout: layout
		shader: shd
		index_type: .uint16
		depth_stencil: sg_depth_stencil_state{
			depth_compare_func: .always
			depth_write_enabled: false
		}
		rasterizer: sg_rasterizer_state{
			cull_mode: .@none
			sample_count: 4
		}
	})

	// view-projection matrix
	state.trans_mat32 = math.mat32_ortho(-2, 2, 2, -2)
	// C.memcpy((state.arr).data, state.trans_mat32.data, state.trans_mat32.len * sizeof(f32))
	for i := 0; i < 6; i++ {
		state.arr[i] = state.trans_mat32.data[i]
	}
}

fn create_image() C.sg_image {
	img := image.load('assets/beach.png')
	mut img_desc := sg_image_desc{
		width: img.width
		height: img.height
		pixel_format: .rgba8
		min_filter: .nearest
		mag_filter: .nearest
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: img.data
		size: sizeof(u32) * img.width * img.height
    }

    sg_img := sg_make_image(&img_desc)
	img.free()
	return sg_img
}

fn create_checker_image() C.sg_image {
	/* create a checkerboard texture */
    pixels := [
        u32(0xFFFFFFFF), 0x00000000, 0xFFFFFFFF, 0x00000000,
        0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF,
        0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
        0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF,
	]!

	mut img_desc := sg_image_desc{
		width: 4
		height: 4
		pixel_format: .rgba8
		min_filter: .nearest
		mag_filter: .nearest
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: pixels.data
		size: sizeof(u32) * pixels.len
    }

    return C.sg_make_image(&img_desc)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)
	state.arr[6] = math.rand_between(-0.1, 0.1)
	state.arr[7] = math.rand_between(-0.1, 0.1)

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)
	sg_apply_bindings(&state.bind)
	sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &state.arr, sizeof(f32) * 8)
	sg_draw(0, 6, 1)
	sg_end_pass()
	sg_commit()
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	if evt.@type == .key_down {
		match evt.key_code {
			.f {
				mut state := &AppState(user_data)
				state.bind.fs_images[0] = state.beach_img
			}
			.g {
				mut state := &AppState(user_data)
				state.bind.fs_images[0] = state.checker_img
			}
			else {}
		}
	}
}

fn cleanup() {
	println('hi cleanup')
}