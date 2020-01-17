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

	frag_noise = '
	uniform float noise;

	float rand(vec2 co){
		return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	}

	vec4 effect(vec4 vcolor, sampler2D tex, vec2 texcoord) {
		vec4 color = texture(tex, texcoord);
		float diff = (rand(texcoord) - 0.5) * noise;

		color.r += diff;
		color.g += diff;
		color.b += diff;

		return color;
	}'
)

struct AppState {
mut:
	data int
	mesh &graphics.Mesh = &graphics.Mesh(0)
	batch &graphics.SpriteBatch = &graphics.SpriteBatch(0)
	pip sg_pipeline
	default_pip sg_pipeline
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

fn make_pip(via &via.Via) sg_pipeline {
	mut shader_desc := graphics.shader_get_default_desc()
	shader_desc.set_frag_uniform_block_size(0, sizeof(math.Vec4))
		.set_frag_uniform(0, 0, 'via_ScreenSize', .float4, 0)
	shader := via.g.new_shader(graphics.null_str, frag, shader_desc)

	pip_desc := graphics.pipeline_desc_make_default(shader)
	return via.g.new_pipeline(pip_desc)
}

fn make_pip_noise(via &via.Via) sg_pipeline {
	mut shader_desc := graphics.shader_get_default_desc()
	shader_desc.set_frag_uniform_block_size(0, sizeof(f32))
		.set_frag_uniform(0, 0, 'noise', .float, 0)
	shader := via.g.new_shader(graphics.null_str, frag_noise, shader_desc)

	pip_desc := graphics.pipeline_desc_make_default(shader)
	return via.g.new_pipeline(pip_desc)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	t := via.g.new_texture('assets/beach.png')
	println('t: $t')

	s := via.audio.new_stream('assets/skid.wav')
	_, channel := s.play(0)
	s.set_loop_count(4)
	_, name := s.get_name()
	loops := 0
	s.get_loop_count(&loops)
	println('sound name: $name, loops: $loops')

	state.default_pip = graphics.pipeline_make_default()
	state.pip = make_pip(via)
	// state.pip = make_pip_noise(via)

	state.mesh = graphics.mesh_new_quad()
	state.mesh.bind_texture(0, t)

	tile := via.g.new_texture('assets/dude.png')
	state.batch = via.g.new_spritebatch(tile, 10)
	state.batch.add(-2, -2)
	state.batch.add(-1, -1)
	state.batch.add(0, 0)
	state.batch.add(1, 1)
	state.batch.add(-2, -1)
	state.batch.add(-2, 0)
	state.batch.add(-2, 1)
}

pub fn (state mut AppState) update(via &via.Via) {

}

pub fn (state mut AppState) draw(via &via.Via) {
	for i, _ in state.mesh.verts {
		state.mesh.verts[i].x += math.rand_between(-0.03, 0.03)
		state.mesh.verts[i].y += math.rand_between(-0.03, 0.03)
	}
	state.mesh.update_verts()

	trans_mat := math.mat44_ortho2d(-2, 2, 2, -2)
	pass_action := via.g.new_clear_pass(1.0, 0.3, 1.0, 1.0)
	w, h := via.win.get_drawable_size()
	screen_size := math.Vec4{w, h, 0, 1}
	noise := 2.0

	sg_begin_default_pass(&pass_action, w, h)

	sg_apply_pipeline(state.default_pip)
	state.batch.draw(&trans_mat)

	sg_apply_pipeline(state.pip)
	state.mesh.apply_bindings()
	state.mesh.apply_uniforms(.vs, 0, &trans_mat, sizeof(math.Mat44))
	state.mesh.apply_uniforms(.fs, 0, &screen_size, sizeof(math.Vec4))
	// state.mesh.apply_uniforms(.fs, 0, &noise, sizeof(f32))
	state.mesh.draw()

	sg_end_pass()
	sg_commit()
}