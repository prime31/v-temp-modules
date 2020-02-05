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

pub fn (state mut AppState) initialize() {
	state.beach_tex = graphics.new_texture('assets/beach.png')
	state.dude_tex = graphics.new_texture('assets/dude.png')
	state.atlas = graphics.new_texture_atlas('assets/adventurer.atlas')
	state.batch = graphics.quadbatch(2000)
}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_default_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)}, {})

	names := state.atlas.get_names()

	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad(math.choose_arr(names)), {x: 0, y: -80, sx: 2, sy: 2, ox: 25, oy: 18.5})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad(math.choose_arr(names)), {x: 0, y: -150, sx: 2, sy: 2, rot: 90, ox: 25, oy: 18.5})
	state.batch.draw(state.beach_tex, {x: 0, y: 0})
	state.batch.draw(state.beach_tex, {x: -100, y: -20})
	state.batch.draw(state.beach_tex, {x: -200, y: -40, rot: 45})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: -100, y: -200})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -100, y: -250})
	state.batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -300})
	state.batch.end()

	graphics.end_pass()
}