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

pub fn (state mut AppState) initialize(via &via.Via) {
	state.batch = graphics.trianglebatch(2000)
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	pass_action := via.g.make_pass_action({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)})
	via.g.begin_default_pass(pass_action, {})

	state.batch.begin()
	state.batch.draw_triangle(200, 200, 200, 300, 400, 200)
	state.batch.draw_rectangle(-500, -500, 200, 100)
	state.batch.draw_circle(-400, 400, 75, 6)
	state.batch.draw_circle(-500, 200, 75, 16)
	state.batch.draw_polygon([math.Vec2{0, 0}, math.Vec2{100, -100}, math.Vec2{200, 50}, math.Vec2{50, 200}, math.Vec2{-55, 100}]!)
	state.batch.end()

	via.g.end_pass()
}