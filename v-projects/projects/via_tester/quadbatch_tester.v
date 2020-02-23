import via
import via.math
import via.window
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	atlas graphics.TextureAtlas
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
}

pub fn (state &AppState) update() {}

pub fn (state &AppState) draw() {
	w, h := window.drawable_size()
	trans_mat := math.mat32_translate(w/2, h/2)
	graphics.begin_pass({color:math.rgba(0.5, 0.4, 0.8, 1.0) trans_mat:&trans_mat})

	names := state.atlas.get_names()

	mut batch := graphics.spritebatch()
	batch.draw_q(state.atlas.tex, state.atlas.get_quad(math.choose_arr(names)), {x: 0, y: -80, sx: 2, sy: 2, ox: 25, oy: 18.5})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad(math.choose_arr(names)), {x: 0, y: -150, sx: 2, sy: 2, rot: 90, ox: 25, oy: 18.5})
	batch.draw(state.beach_tex, {x: 0, y: 0})
	batch.draw(state.beach_tex, {x: -100, y: -20})
	batch.draw(state.beach_tex, {x: -200, y: -40, rot: 45})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-04'), {x: -100, y: -200})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-03'), {x: -100, y: -250})
	batch.draw_q(state.atlas.tex, state.atlas.get_quad('adventurer-run-02'), {x: -100, y: -300})

	graphics.end_pass()
}