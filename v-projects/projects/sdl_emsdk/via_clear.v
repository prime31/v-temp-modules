import via
import via.math
import via.graphics

struct AppState {
mut:
	data int
	mesh &graphics.Mesh
	batch &graphics.AtlasBatch
	custom_pipe graphics.Pipeline
	pipe graphics.Pipeline
	pip_trans_index int
	pip_screen_index int
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{
		window_width: 500
		window_height: 300
	}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.pipe = graphics.pipeline_new_default()
	state.pip_trans_index = state.pipe.get_uniform_index(.vs, 0)
	trans_mat := math.mat44_ortho(-2, 2, 2, -2)
	state.pipe.set_uniform(state.pip_trans_index, &trans_mat)
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	trans_mat := math.mat32_ortho_off_center(4, 4)
	pass_action := via.g.make_pass_action({color:math.rgba(0.7, 0.3, 0.7, 1.0)})
	w, h := via.win.get_drawable_size()
	screen_size := math.Vec4{w, h, 0, 1}
	noise := 2.0

	sg_begin_default_pass(&pass_action, w, h)
	sg_end_pass()
	sg_commit()
}