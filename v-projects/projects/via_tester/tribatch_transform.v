import via
import via.math
import via.time
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
	graphics.begin_pass({color:math.rgba(0.5, 0.4, 0.6, 1.0)})

	mut tb := graphics.tribatch()
	tb.draw_triangle(-50, 50, 0, -170, 50, 50, {x:800 y:600 rot:-f32(time.ticks() / 12) color:math.red()})
	tb.draw_rectangle(200, 100, {x:150 y:150 rot:-f32(time.ticks() / 10)})
	tb.draw_circle(75, 6, {x:512 y:384 rot:f32(time.ticks() / 10) color:math.color_orange()})
	tb.draw_circle(75, 16, {x:800 y:150})
	tb.draw_polygon([math.Vec2{-50, -50}, math.Vec2{0, -100}, math.Vec2{100, 50}, math.Vec2{70, 100}, math.Vec2{0, 150}]!, {x:150 y:600 rot:f32(time.ticks() / 5) color:math.color_blue()})

	graphics.end_pass()
}