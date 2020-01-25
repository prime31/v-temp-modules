import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.AtlasBatch = &graphics.AtlasBatch(0)
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	beach := via.g.new_texture('assets/beach.png')
	tile := via.g.new_texture('assets/dude.png')
	img := math.rand_choose(beach, tile)

	state.batch = via.g.new_atlasbatch(tile, 20)
	for i in 0..10 {
		state.batch.add({x: i * 32, y: 0})
	}

	quad1 := math.quad(0, 0, 16, 16, 32, 32)
	quad2 := math.quad(16, 0, 16, 16, 32, 32)
	quad3 := math.quad(0, 16, 16, 16, 32, 32)
	quad4 := math.quad(16, 16, 16, 16, 32, 32)
	for i in 0..10 {
		q := math.rand_choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q(q, {x: 8, y: (f32(i) + 2.0) * 24 + 8, rot: math.rand_range(20, 340), sx: 1, sy: 1, ox: 8, oy: 8})
	}
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.make_clear_pass(1.0, 0.3, 1.0, 1.0)
	w, h := via.win.get_drawable_size()
	trans_mat := math.mat32_ortho_off_center(w, h)

	sg_begin_default_pass(&pass_action, w, h)

	sg_apply_pipeline(via.g.get_default_pipeline().pip)
	state.batch.draw(&trans_mat)

	sg_end_pass()
	sg_commit()
}