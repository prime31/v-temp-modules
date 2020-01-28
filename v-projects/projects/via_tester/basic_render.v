import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	atlas graphics.TextureAtlas
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	beach_tex graphics.Texture
	dude_tex graphics.Texture
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.beach_tex = via.g.new_texture('assets/beach.png')
	state.dude_tex = via.g.new_texture('assets/dude.png')
	state.batch = graphics.quadbatch(2000)
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.make_pass_action({color:math.color_from_floats(0.1, 0.1, 0.1, 1.0)})
	via.g.begin_default_pass(&pass_action, {})

	state.batch.begin()
	state.batch.draw(state.beach_tex, {x: 0, y: 0})
	state.batch.draw(state.dude_tex, {x: -300, y: -20, sx: 3, sy: 3})
	state.batch.draw(state.beach_tex, {x: -600, y: -40, rot: 45})
	state.batch.end()

	via.g.end_pass()
}