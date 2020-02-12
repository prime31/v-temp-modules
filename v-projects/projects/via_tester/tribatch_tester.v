import via
import via.math
import via.graphics
import via.libs.imgui

struct AppState {}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state &AppState) initialize() {}

pub fn (state &AppState) update() {}

pub fn (state &AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)})

	mut tb := graphics.tribatch()
	tb.draw_triangle(200, 200, 200, 300, 400, 200, {color:math.color_red()})
	tb.draw_rectangle(200, 100, {x:150 y:100})
	tb.draw_circle(75, 6, {x:100 y:600 color:math.color_orange()})
	tb.draw_circle(75, 16, {x:400 y:500})
	tb.draw_polygon([math.Vec2{500, 200}, math.Vec2{600, 100}, math.Vec2{700, 250}, math.Vec2{550, 400}, math.Vec2{450, 300}]!, {x:200 y:200 color:math.color_blue()})
	tb.draw_line(10, 10, 100, 100, 4, math.color_black())
	tb.draw_hollow_rect(500, 200, 200, 75, 2, math.color_purple())
	graphics.end_pass()
}