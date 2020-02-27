import via
import via.math
import via.input
import via.debug
import via.physics
import via.physics.catto
import via.physics.arcade
import via.graphics

struct AppState {
mut:
	box physics.AabbCollider
	box2 physics.AabbCollider
	circle physics.CircleCollider
	circle2 physics.CircleCollider
	speed int = 3

	poly1 catto.Polygon = catto.Polygon{}
	poly2 catto.Polygon = catto.Polygon{}
	input catto.Input
	angle f32
	position math.Vec2 = math.Vec2{2, 0}
	output catto.Output
	simplex_index u32 = u32(0)
	draw_simplex bool = true
}

fn main() {
	state := AppState{}

	via.run({
		win_highdpi: true
		design_width: 640
		design_height: 480
		win_width: 640
		win_height: 480
		resolution_policy: .show_all_pixel_perfect
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.box = physics.aabbcollider(40, 40, 30, 40)
	state.box2 = physics.aabbcollider(140, 140, 30, 40)
	state.circle = physics.circlecollider(180, 100, 20)
	state.circle2 = physics.circlecollider(380, 300, 30)

	state.demo1()
}

pub fn (state mut AppState) update() {
	state.keys()

	state.input = catto.Input{}
	state.input.polygon1 = state.poly1
	state.input.polygon2 = state.poly2
	state.input.trans2.p = state.position
	state.input.trans2.r.set_angle(state.angle)

	state.output = catto.distance(state.input)

	if state.simplex_index >= state.output.simplices.len {
		state.simplex_index = state.output.simplices.len - 1
	}

	if state.draw_simplex {

	}
}

pub fn (state mut AppState) keys() {
	if input.is_key_down(.d1) { state.demo1() }
	if input.is_key_down(.d2) { state.demo2() }
	if input.is_key_down(.d3) { state.demo3() }
	if input.is_key_down(.d4) { state.demo4() }
	if input.is_key_down(.d5) { state.demo5() }
	if input.is_key_down(.d6) { state.demo6() }

	if input.is_key_down(.up) { state.position.y -= 0.05 }
	if input.is_key_down(.down) { state.position.y += 0.05 }
	if input.is_key_down(.left) { state.position.x -= 0.05 }
	if input.is_key_down(.right) { state.position.x += 0.05 }

	if input.is_key_down(.w) { state.angle += 0.005 * math.pi }
	if input.is_key_down(.r) { state.angle -= 0.005 * math.pi }

	if input.is_key_pressed(.i) { state.simplex_index++ }
	if input.is_key_pressed(.k) { state.simplex_index-- }

	if C.igCheckbox('Draw Simplex', &state.draw_simplex) {
		state.simplex_index = 0
	}

	C.igText(c'Position: %.2f, %.2f', state.position.x, state.position.y)
	C.igText(c'Angle: %.2f', state.angle)
	C.igText(c'Simplex Index: %d', state.simplex_index)
}

pub fn (state &AppState) draw() {
	mut tribatch := graphics.tribatch()
	trans_mat := math.mat32_translate(320, 240)
	graphics.begin_pass({color:math.rgba(0.1, 0.1, 0.1, 1.0) trans_mat:&trans_mat pipeline:0 pass:0})

	draw_poly(state.input.polygon1, state.input.trans1)
	draw_poly(state.input.polygon2, state.input.trans2)

	graphics.end_pass()
}

fn draw_poly(poly catto.Polygon, trans catto.Transform) {
	scaler := 50
	mut tribatch := graphics.tribatch()

	if poly.points.len == 1 {
		pt := trans.mul(poly.points[0]).scale(scaler)
		tribatch.draw_point(pt.x, pt.y, 1, math.red())
	} else if poly.points.len == 2 {
		pt1 := trans.mul(poly.points[0]).scale(scaler)
		pt2 := trans.mul(poly.points[1]).scale(scaler)
		tribatch.draw_line(pt1.x, pt1.y, pt2.x, pt2.y, 2, math.yellow())
	} else {
		tribatch.draw_hollow_polygon(0, 0, poly.points, math.yellow())
	}
}

fn (state mut AppState) demo1() {
	state.poly1.points.clear()
	state.poly1.points << math.Vec2{}

	state.poly2.points.clear()
	state.poly2.points << math.Vec2{0, -1}
	state.poly2.points << math.Vec2{0, 1}
}

fn (state mut AppState) demo2() {
	state.poly1.points.clear()
	state.poly1.points << math.Vec2{}

	state.poly2.points.clear()
	state.poly2.points << math.Vec2{0, -1}
	state.poly2.points << math.Vec2{0, 1}
}

fn (state mut AppState) demo3() {
	state.poly1.points.clear()
	state.poly1.points << math.Vec2{}

	state.poly2.points.clear()
	state.poly2.points << math.Vec2{0, -1}
	state.poly2.points << math.Vec2{0, 1}
}

fn (state mut AppState) demo4() {
	state.poly1.points.clear()
	state.poly1.points << math.Vec2{}

	state.poly2.points.clear()
	state.poly2.points << math.Vec2{0, -1}
	state.poly2.points << math.Vec2{0, 1}
}

fn (state mut AppState) demo5() {
	state.poly1.points.clear()
	state.poly1.points << math.Vec2{}

	state.poly2.points.clear()
	state.poly2.points << math.Vec2{0, -1}
	state.poly2.points << math.Vec2{0, 1}
}

fn (state mut AppState) demo6() {
	state.poly1.points.clear()
	state.poly1.points << math.Vec2{}

	state.poly2.points.clear()
	state.poly2.points << math.Vec2{0, -1}
	state.poly2.points << math.Vec2{0, 1}
}