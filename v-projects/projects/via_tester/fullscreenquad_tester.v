import via
import via.math
import via.audio
import via.graphics
import via.filesystem
import via.window

struct AppState {
mut:
	t graphics.Texture
	tex graphics.Texture
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{
		win_highdpi: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	filesystem.mount('../assets', 'assets', true)

	state.tex = graphics.new_texture('assets/v-logo_30_30.png')
	state.t = graphics.new_texture('assets/beach.png')
}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_default_offscreen_pass({color:math.color_from_floats(0.1, 0.1, 0.4, 1.0)}, {})
	graphics.spritebatch().draw(state.t, {x:0 y:0 sx:9 sy:9})
	graphics.flush()
	graphics.end_pass()

	graphics.blit_default_offscreen(math.color_from_floats(0.3, 0.0, 0.3, 1.0))
}