import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.AtlasBatch = &graphics.AtlasBatch(0)
}

fn main() {
	state := AppState{}
	via.run({}, mut state)
}

pub fn (state mut AppState) initialize() {
	atlas := graphics.new_texture_atlas('assets/adventurer.atlas')
	state.batch = graphics.new_atlasbatch(atlas.tex, 20)

	atlas_names := atlas.get_names()
	for i in 0..10 {
		q := atlas.get_quad(atlas_names[i])
		state.batch.add_q(q, {x:i * 32 + 500 y:300})
	}

	quad1 := atlas.get_quad('adventurer-run-04')
	quad2 := atlas.get_quad('adventurer-run-03')
	quad3 := atlas.get_quad('adventurer-run-02')
	quad4 := atlas.get_quad('adventurer-run-01')
	for i in 0..10 {
		q := math.choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q(q, {x:8 + 500 y: (f32(i) + 2.0) * 24 + 308 rot:math.range(20, 340) ox:25 oy:18.5})
	}
}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.rgba(1.0, 0.3, 1.0, 1.0)})
	state.batch.draw()
	graphics.end_pass()
}