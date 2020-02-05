import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {
mut:
	batch &graphics.TriangleBatch = &graphics.TriangleBatch(0)
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.batch = graphics.trianglebatch(2000)
}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_default_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)}, {})

	state.batch.draw_triangle(200, 200, 200, 300, 400, 200, {color:math.color_red()})
	state.batch.draw_rectangle(-500, -500, 200, 100, {x:0})
	state.batch.draw_circle(-400, 400, 75, 6, {color:math.color_orange()})
	state.batch.draw_circle(-500, 200, 75, 16, {x:0})
	state.batch.draw_polygon([math.Vec2{0, 0}, math.Vec2{100, -100}, math.Vec2{200, 50}, math.Vec2{50, 200}, math.Vec2{-55, 100}]!, {x:0})
	state.batch.end()

	graphics.end_pass()
}