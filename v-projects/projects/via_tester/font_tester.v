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
	batch &graphics.QuadBatch
	font &fonts.FontBook
	proggy int
	roboto int
	rot f32
	scale f32
}

fn main() {
	filesystem.mount('../assets', 'assets', true)
	state := AppState{
		batch: 0
		font: 0
	}
	via.run(via.ViaConfig{
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.batch = graphics.quadbatch(2000)
	state.font = graphics.new_fontbook(512, 512)
	state.proggy = state.font.add_font('assets/ProggyTiny.ttf')
	state.roboto = state.font.add_font('assets/RobotoMono-Regular.ttf')
}

pub fn (state mut AppState) update() {
	state.rot += 0.5
	state.scale = 1.0 + math.ping_pong(time.seconds(), 5)
}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(0.5, 0.4, 0.6, 1.0)})

	state.font.clear_state()
	state.font.set_size(10)
	state.font.set_align(.left_middle)
	state.batch.draw_text(state.font, 'left aligned', {x:512 + 300, y:384 - 300, rot: 0, sx: state.scale, sy: state.scale})
	state.batch.draw_text(state.font, 'left aligned', {x:512 + -300, y:384 - 300, rot: state.rot, sx: 4, sy: 4})
	state.font.set_align(.right_middle)
	state.batch.draw_text(state.font, 'right aligned', {x:512 + 300, y:384 - 300, rot:0, sx:state.scale, sy:state.scale, color:math.color_cornflower_blue()})
	state.batch.draw_text(state.font, 'right aligned', {x:512 + -300, y:384 + 300, rot: state.rot, sx: 4, sy: 4})

	state.font.set_size(24)
	state.font.set_align(.center_middle)
	state.font.set_font(state.roboto)
	state.batch.draw_text(state.font, 'centered text', {x:512 + 300, y:384, rot: 0, sx: state.scale, sy: state.scale, color:math.color_orange()})
	state.font.set_blur(1)
	state.batch.draw_text(state.font, 'centered BLURRY text', {x:512 - 300, y:384, rot: state.rot, sx: 4, sy: 4, color:math.color_orange()})
	state.batch.end()

	graphics.end_pass()
}