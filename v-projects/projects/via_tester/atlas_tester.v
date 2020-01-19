import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.AtlasBatch
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	atlas := via.g.new_texture_atlas('assets/adventurer.atlas')
	state.batch = via.g.new_atlasbatch(atlas.tex, 20)

	atlas_names := atlas.get_names()
	for i in 0..10 {
		q := atlas.get_quad(atlas_names[i])
		state.batch.add_q_trso(q, i * 32, 0, 0, 1, 1, 0, 0)
	}

	quad1 := atlas.get_quad('adventurer-run-04')
	quad2 := atlas.get_quad('adventurer-run-03')
	quad3 := atlas.get_quad('adventurer-run-02')
	quad4 := atlas.get_quad('adventurer-run-01')
	for i in 0..10 {
		q := math.rand_choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q_trso(q, 0 + 8, (f32(i) + 2.0) * 24 + 8, math.rand_range(20, 340), 1, 1, 25, 18.5)
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

	sg_apply_pipeline(via.g.get_default_pipeline())
	state.batch.draw(&trans_mat)

	sg_end_pass()
	sg_commit()
}