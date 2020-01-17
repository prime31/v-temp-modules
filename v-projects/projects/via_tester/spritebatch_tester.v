import via
import via.math
import via.graphics
import via.libs.imgui

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
	state.pip = graphics.pipeline_make_default()

	beach := via.g.new_texture('assets/beach.png')
	tile := via.g.new_texture('assets/dude.png')
	img := math.rand_choose(beach, tile)

	state.batch = via.g.new_spritebatch(tile, 20)
	for i in 0..10 {
		state.batch.add(i * 32, 0)
	}

	quad1 := math.quad_make(0, 0, 16, 16, 32, 32)
	quad2 := math.quad_make(16, 0, 16, 16, 32, 32)
	quad3 := math.quad_make(0, 16, 16, 16, 32, 32)
	quad4 := math.quad_make(16, 16, 16, 16, 32, 32)
	for i in 0..10 {
		q := math.rand_choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q_trso(q, 0 + 8, (f32(i) + 2.0) * 24 + 8, math.rand_range(20, 340), 1, 1, 8, 8)
	}
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.new_clear_pass(1.0, 0.3, 1.0, 1.0)
	w, h := via.win.get_drawable_size()
	half_w := int(f32(w) / 2)
	half_h := int(f32(h) / 2)
	trans_mat := math.mat44_ortho2d(-half_w, half_w, half_h, -half_h)

	sg_begin_default_pass(&pass_action, w, h)

	sg_apply_pipeline(state.pip)
	state.batch.draw(&trans_mat)

	sg_end_pass()
	sg_commit()
}