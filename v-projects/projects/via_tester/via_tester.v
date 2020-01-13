import via
import via.math
import via.graphics

const (
	frag = '
	float rand(vec2 co){
		return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	}

	vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord) {
		vec4 color = texture(tex, texcoord);
		float diff = (rand(texcoord) - 0.5) * 1.5;

		color.r += diff;
		color.g += diff;
		color.b += diff;

		// lines
		float _lineSize = 20;
		vec4 _lineColor = vec4(0, 0, 0, 1);
		vec2 screen_pos = via_PixelCoord;
		float flooredAlternate = mod(floor( screen_pos.x / _lineSize ), 2.0);
		vec4 finalColor = mix(color, _lineColor, flooredAlternate);

		return finalColor;
	}'
)

struct AppState {
mut:
	data int
	mesh &graphics.Mesh = &graphics.Mesh(0)
	pip sg_pipeline
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

fn (state mut AppState) make_pip(via &via.Via) {
	mut shader_desc := graphics.shader_get_default_desc()
	shader_desc.set_vert_uniform_block_size(1, sizeof(math.Vec4))
		.set_vert_uniform(1, 0, 'via_ScreenSize', .float4, 0)
	shader := via.graphics.new_shader(graphics.null_str, frag, shader_desc)

	pip_desc := graphics.pipeline_desc_make_default(shader)
	state.pip = via.graphics.new_pipeline(pip_desc)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	t := via.graphics.new_texture('assets/beach.png')
	println('t: $t')

	s := via.audio.new_stream('assets/skid.wav')
	_, channel := s.play(0)
	s.set_loop_count(4)
	_, name := s.get_name()
	loops := 0
	s.get_loop_count(&loops)
	println('sound name: $name, loops: $loops')

	state.make_pip(via)
	state.mesh = graphics.mesh_new_quad()
	state.mesh.bind_image(0, t.id)
}

pub fn (state mut AppState) update(via &via.Via) {

}

pub fn (state mut AppState) draw(via &via.Via) {
	for i, _ in state.mesh.verts {
		state.mesh.verts[i].pos.x += math.rand_between(-0.01, 0.01)
		state.mesh.verts[i].pos.y += math.rand_between(-0.01, 0.01)
	}
	state.mesh.update_verts()

	trans_mat := math.mat44_ortho2d(-2, 2, 2, -2)
	pass_action := via.graphics.new_clear_pass(1.0, 0.3, 1.0, 1.0)
	w, h := via.window.get_drawable_size()
	screen_size := math.Vec4{w, h, 0, 1}

	sg_begin_default_pass(&pass_action, w, h)
	sg_apply_pipeline(state.pip)

	state.mesh.apply_bindings()
	state.mesh.apply_uniforms(.vs, 0, &trans_mat, sizeof(math.Mat44))
	state.mesh.apply_uniforms(.vs, 1, &screen_size, sizeof(math.Vec4))
	state.mesh.draw()

	sg_end_pass()
	sg_commit()
}