import via
import via.math
import via.graphics
import via.fonts
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.TextBatch = &graphics.TextBatch(0)
	font &fonts.FontStash = &fonts.FontStash(0)
	proggy int
	roboto int
	rot f32
	pos math.Vec2 = math.Vec2{0,0}
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{
		imgui_enabled: true
	}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	via.fs.mount('../assets', 'assets', true)

	state.batch = graphics.textbatch(2000)
	state.font = via.g.new_fontstash(512, 512)
	state.proggy = state.font.add_font('assets/ProggyTiny.ttf')
	state.roboto = state.font.add_font('assets/RobotoMono-Regular.ttf')
}

pub fn (state mut AppState) update(via &via.Via) {
	state.rot += 0.5

	C.igSliderFloat('x', &state.pos.x, -200, 200, C.NULL, 1)
	C.igSliderFloat('y', &state.pos.y, -200, 200, C.NULL, 1)
}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.new_clear_pass(0.5, 0.4, 0.6, 1.0)
	w, h := via.win.get_drawable_size()
	trans_mat := math.mat44_ortho2d_off_center(w, h)

	sg_begin_default_pass(&pass_action, w, h)
	sg_apply_pipeline(via.g.get_default_text_pipeline())

	state.batch.begin(trans_mat)
	state.font.clear_state()
	state.font.set_size(10)
	state.batch.draw_text(state.font, 'in your sleep you fool', {x: 0, y: -150, sx: 4, sy: 4})
	state.batch.draw_text(state.font, 'IN YOUR SLEEP YOU FOOL', {x: 0, y: -250, sx: 1, sy: 1})

	state.font.set_color(math.color_orange())
	state.font.set_size(24)
	// state.font.set_align(.center)
	state.font.set_font(state.roboto)
	state.batch.draw_text(state.font, 'Rotate me', {x: state.pos.x, y: state.pos.y, rot: state.rot, sx: 4, sy: 4})
	state.batch.end()

	sg_end_pass()
	sg_commit()
}