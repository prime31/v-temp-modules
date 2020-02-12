import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize() {}

pub fn (state mut AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)})

	mut tb := graphics.tribatch()
	tb.draw_triangle(200, 200, 200, 300, 400, 200, {color:math.color_red()})
	tb.draw_rectangle(400, 300, 200, 100, {x:0})
	tb.draw_circle(300, 300, 75, 6, {color:math.color_orange()})
	tb.draw_circle(400, 500, 75, 16, {x:0})
	tb.draw_polygon([math.Vec2{500, 200}, math.Vec2{600, 100}, math.Vec2{700, 250}, math.Vec2{550, 400}, math.Vec2{450, 300}]!, {x:0 color:math.color_blue()})

	graphics.end_pass()
}