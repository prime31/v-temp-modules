import via
import via.math
import via.time
import via.fonts
import via.input
import via.graphics
import via.filesystem
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.TextBatch
	font &fonts.FontStash
	proggy int
	roboto int
	rot f32
	scale f32
}

fn main() {
	state := AppState{
		batch: 0
		font: 0
	}
	via.run(via.ViaConfig{
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	filesystem.mount('../assets', 'assets', true)

	state.batch = graphics.textbatch(2000)
	state.font = via.g.new_fontstash(512, 512)
	state.proggy = state.font.add_font('assets/ProggyTiny.ttf')
	state.roboto = state.font.add_font('assets/RobotoMono-Regular.ttf')
}

pub fn (state mut AppState) update(via &via.Via) {
	state.rot += 0.5
	state.scale = 1.0 + math.ping_pong(time.get_seconds() as f32, 5)
}

pub fn (state mut AppState) draw(via mut via.Via) {
	via.g.begin_default_pass({color:math.color_from_floats(0.5, 0.4, 0.6, 1.0)}, {pipeline:via.g.get_default_text_pipeline()})

	state.batch.begin()
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
	state.font.set_blur(1)
	state.batch.draw_text(state.font, 'centered BLURRY text', {x: -400, y: 0, rot: state.rot, sx: 4, sy: 4})
	state.batch.end()

	via.g.end_pass()
}