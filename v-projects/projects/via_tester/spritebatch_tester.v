import via
import via.math
import via.graphics

struct AppState {
mut:
	batch &graphics.SpriteBatch
	pip sg_pipeline
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	t := via.graphics.new_texture('assets/beach.png')

	state.pip = graphics.pipeline_make_default()

	tile := via.graphics.new_texture('assets/dude.png')
	state.batch = via.graphics.new_spritebatch(tile, 20)
	for i in 0..10 {
		state.batch.add(i * 32, 0)
	}

	for i in 0..10 {
		state.batch.add(0, (i + 1) * 32)
	}
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.graphics.new_clear_pass(1.0, 0.3, 1.0, 1.0)
	w, h := via.window.get_drawable_size()
	half_w := int(f32(w) / 2)
	half_h := int(f32(h) / 2)
	trans_mat := math.mat44_ortho2d(-half_w, half_w, half_h, -half_h)

	sg_begin_default_pass(&pass_action, w, h)

	sg_apply_pipeline(state.pip)
	state.batch.draw(&trans_mat)

	sg_end_pass()
	sg_commit()
}