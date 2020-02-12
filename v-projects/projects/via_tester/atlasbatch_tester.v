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

pub fn (state mut AppState) initialize() {
	beach := graphics.new_texture('assets/beach.png')
	tile := graphics.new_texture('assets/dude.png')
	img := math.choose_t(beach, tile)

	state.batch = graphics.new_atlasbatch(tile, 20)
	for i in 0..10 {
		state.batch.add({x:i * 32 + 300 y:300})
	}

	quad1 := math.quad(0, 0, 16, 16, 32, 32)
	quad2 := math.quad(16, 0, 16, 16, 32, 32)
	quad3 := math.quad(0, 16, 16, 16, 32, 32)
	quad4 := math.quad(16, 16, 16, 16, 32, 32)
	for i in 0..10 {
		q := math.choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q(q, {x:308 y:(f32(i) + 2.0) * 24 + 308 rot:math.range(20, 340) ox:8 oy:8})
	}
}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(1.0, 0.3, 1.0, 1.0)})
	state.batch.draw()
	graphics.end_pass()
}