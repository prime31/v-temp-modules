import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.TriangleBatch = &graphics.TriangleBatch(0)
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.batch = graphics.trianglebatch(2000)
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.new_clear_pass(0.5, 0.4, 0.8, 1.0)
	w, h := via.win.get_drawable_size()
	trans_mat := math.mat44_ortho2d_off_center(w, h)

	sg_begin_default_pass(&pass_action, w, h)
	sg_apply_pipeline(via.g.get_default_pipeline())

	state.batch.begin(trans_mat)
	state.batch.set_tri_verts(0, 0, 100, 100, 0, 100)
	state.batch.set_tri_verts(200, 200, 200, 300, 400, 200)
	state.batch.end()

	sg_end_pass()
	sg_commit()
}