import via
import via.math
import via.audio
import via.graphics
import via.window

struct AppState {
mut:
	fsquad &graphics.FullscreenQuad
}

fn main() {
	state := AppState{
		fsquad: 0
	}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize() {
	t := graphics.new_texture('assets/beach.png')
	state.fsquad = graphics.fullscreenquad()
	state.fsquad.bind_texture(0, t)
}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_default_pass({color:math.color_from_floats(0.1, 0.1, 0.4, 1.0)}, {})
	state.fsquad.draw()
	graphics.end_pass()
}