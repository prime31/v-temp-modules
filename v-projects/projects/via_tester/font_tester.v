import via
import via.math
import via.graphics
import via.fonts
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	font &fonts.FontStash = &fonts.FontStash(0)
	proggy int
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.batch = graphics.quadbatch(2000)
	state.font = via.g.new_fontstash(512, 512)
	state.proggy = state.font.add_font('assets/ProggyTiny.ttf')

	state.font.draw_text(0, 0, 'farting on the bed')
	state.font.set_color(math.color_blue_violet())
	state.font.draw_text(0, 20, 'in your sleep')
	state.font.iter_text(0, 20, 'in your sleep you fool')
}

pub fn (state mut AppState) update(via &via.Via) {
	state.font.draw_text(0, 20, 'in your sleep you fool')
}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.new_clear_pass(0.5, 0.4, 0.6, 1.0)
	w, h := via.win.get_drawable_size()
	trans_mat := math.mat44_ortho2d_off_center(w, h)

	sg_begin_default_pass(&pass_action, w, h)
	sg_apply_pipeline(via.g.get_default_pipeline())

	state.batch.begin(trans_mat)

	state.batch.end()

	sg_end_pass()
	sg_commit()
}