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
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	atlas := via.g.new_texture_atlas('assets/adventurer.atlas')
	state.batch = via.g.new_atlasbatch(atlas.tex, 20)

	atlas_names := atlas.get_names()
	for i in 0..10 {
		q := atlas.get_quad(atlas_names[i])
		state.batch.add_q(q, {x: i * 32, y: 0})
	}

	quad1 := atlas.get_quad('adventurer-run-04')
	quad2 := atlas.get_quad('adventurer-run-03')
	quad3 := atlas.get_quad('adventurer-run-02')
	quad4 := atlas.get_quad('adventurer-run-01')
	for i in 0..10 {
		q := math.rand_choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q(q, {x: 8, y: (f32(i) + 2.0) * 24 + 8, rot: math.rand_range(20, 340), sx: 1, sy: 1, ox: 25, oy: 18.5})
	}
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via mut via.Via) {
	via.g.begin_default_pass({color:math.color_from_floats(1.0, 0.3, 1.0, 1.0)}, {})
	state.batch.draw()
	via.g.end_pass()
}