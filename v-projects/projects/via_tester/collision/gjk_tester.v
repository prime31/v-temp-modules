import via
import via.math
import via.time
import via.debug
import via.input
import via.window
import via.graphics
import via.physics
import via.physics.gjk
import via.filesystem
import via.comps
import via.tilemap
import json

struct AppState {
mut:
	box physics.AabbCollider
	circle physics.CircleCollider
	poly physics.PolygonCollider
	speed int = 3
	gjk gjk.Gjk
	rot f32
}

fn main() {
	state := AppState{
		gjk: gjk.Gjk{}
	}

	via.run({
		win_highdpi: true
		resolution_policy: .show_all_pixel_perfect
		design_width: 640
		design_height: 480
		win_width: 640
		win_height: 480
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.box = physics.aabbcollider(50, 50, 50, 80)
	state.circle = physics.circlecollider(175, 75, 40)
	state.poly = physics.polygoncollider(375, 175, [math.Vec2{-20, 0}, math.Vec2{0, 30}, math.Vec2{20, 0}]!)
}

pub fn (state mut AppState) update() {
	C.igSliderInt(c'Speed', &state.speed, 1, 17, C.NULL)
	mut move := math.Vec2{}

	if input.is_key_down(.right) {
		move.x = state.speed
	} else if input.is_key_down(.left) {
		move.x = -state.speed
	}

	if input.is_key_down(.up) {
		move.y = -state.speed
	} else if input.is_key_down(.down) {
		move.y = state.speed
	}

	if move.x != 0 || move.y != 0 {
		t1 := math.rigidtransform(move)
		mut t2 := math.rigidtransform(math.Vec2{})
		if state.gjk.overlaps(state.box.collider, state.circle.collider, t1, t2) {
			intersects, penetration := state.gjk.intersects(state.box.collider, state.circle.collider, t1, t2)
			if intersects {
				move = move - penetration.normal.scale(penetration.depth)
			}
		}

		if state.gjk.overlaps(state.box.collider, state.poly.collider, t1, t2) {
			intersects, penetration := state.gjk.intersects(state.box.collider, state.poly.collider, t1, t2)
			if intersects {
				move = move - penetration.normal.scale(penetration.depth)
			}
		}

		state.box.x += move.x
		state.box.y += move.y
	}

	C.igText(c'Pos: %f, %f', state.box.x, state.box.y)


	// hackishly rotate the raw verts
	state.rot += 0.1

	mut transformer := math.rigidtransform(math.Vec2{})
	transformer.rotate(math.radians(state.rot))
	mut verts := [math.Vec2{-20, 0}, math.Vec2{0, 30}, math.Vec2{20, 0}]!
	for i in 0..verts.len {
		state.poly.verts[i] = transformer.get_transformed(verts[i])
	}
}

pub fn (state mut AppState) draw() {
	mut tribatch := graphics.tribatch()
	graphics.begin_pass({color:math.rgba(0.3, 0.1, 0.4, 1.0)})
	tribatch.draw_hollow_rect(state.box.x, state.box.y, state.box.w, state.box.h, 1, math.red())
	tribatch.draw_hollow_circle(state.circle.r, 10, {x:state.circle.x y:state.circle.y})
	tribatch.draw_polygon(state.poly.verts, {x:state.poly.x y:state.poly.y color:math.yellow()})
	graphics.end_pass()
}