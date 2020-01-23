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
	scale f32
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
	state.scale = 1.0 + math.ping_pong(via.clock.get_seconds() as f32, 5)
}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.make_clear_pass(0.5, 0.4, 0.6, 1.0)
	w, h := via.win.get_drawable_size()
	trans_mat := math.mat44_ortho2d_off_center(w, h)

	sg_begin_default_pass(&pass_action, w, h)
	sg_apply_pipeline(via.g.get_default_text_pipeline())

	state.batch.begin(trans_mat)
	state.font.clear_state()
	state.font.set_size(10)
	state.font.set_align(.left_middle)
	state.batch.draw_text(state.font, 'left aligned', {x: 400, y: -400, rot: 0, sx: state.scale, sy: state.scale})
	state.batch.draw_text(state.font, 'left aligned', {x: -400, y: -400, rot: state.rot, sx: 4, sy: 4})
	state.font.set_align(.right_middle)
	state.font.set_color(math.color_cornflower_blue())
	state.batch.draw_text(state.font, 'right aligned', {x: 400, y: -400, rot: 0, sx: state.scale, sy: state.scale})
	state.batch.draw_text(state.font, 'right aligned', {x: -400, y: 400, rot: state.rot, sx: 4, sy: 4})

	state.font.set_color(math.color_orange())
	state.font.set_size(24)
	state.font.set_align(.center_middle)
	state.font.set_font(state.roboto)
	state.batch.draw_text(state.font, 'centered text', {x: 400, y: 0, rot: 0, sx: state.scale, sy: state.scale})
	state.batch.draw_text(state.font, 'centered text', {x: -400, y: 0, rot: state.rot, sx: 4, sy: 4})
	state.batch.end()

	sg_end_pass()
	sg_commit()
}