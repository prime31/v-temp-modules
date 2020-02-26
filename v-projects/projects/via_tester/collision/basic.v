import via
import via.math
import via.input
import via.debug
import via.physics
import via.physics.arcade
import via.graphics

struct AppState {
mut:
	box physics.AabbCollider
	box2 physics.AabbCollider
	circle physics.CircleCollider
	circle2 physics.CircleCollider
	speed int = 3
}

fn main() {
	state := AppState{}

	via.run({
		win_highdpi: true
		resolution_policy: .show_all_pixel_perfect
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.box = physics.aabbcollider(40, 40, 30, 40)
	state.box2 = physics.aabbcollider(140, 140, 30, 40)
	state.circle = physics.circlecollider(180, 100, 20)
	state.circle2 = physics.circlecollider(380, 300, 30)
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
		mut mani := arcade.collide(state.box.collider, state.box2.collider, move)
		if mani.collided {
			move = move - mani.normal.scale(mani.depth)
			debug.draw_point(mani.contact_pt.x, mani.contact_pt.y, 6, math.white())
		}

		// invert move because we want aabb-to-circle
		//mani = arcade.collide(state.circle.collider, state.box.collider, move.scale(-1))
		mani = arcade.collide(state.box.collider, state.circle.collider, move)
		if mani.collided {
			// invert normal because we want aabb-to-circle
			// mani.normal = mani.normal.scale(-1)
			move = move - mani.normal.scale(mani.depth)
			debug.draw_point(mani.contact_pt.x, mani.contact_pt.y, 6, math.white())
		}

		state.box.x += move.x
		state.box.y += move.y
	}

	// circle
	mx, my := input.mouse_pos()
	state.circle2.x = f32(mx)
	state.circle2.y = f32(my)

	mut mani := arcade.collide(state.circle2.collider, state.circle.collider, math.Vec2{0, 0})
	if mani.collided {
		debug.draw_point(mani.contact_pt.x, mani.contact_pt.y, 6, math.white())
		move_back := mani.normal.scale(mani.depth)
		state.circle2.x -= move_back.x
		state.circle2.y -= move_back.y
	}

	mani = arcade.collide(state.circle2.collider, state.box2.collider, math.Vec2{0, 0})
	if mani.collided {
		debug.draw_point(mani.contact_pt.x, mani.contact_pt.y, 6, math.white())
		move_back := mani.normal.scale(mani.depth)
		state.circle2.x -= move_back.x
		state.circle2.y -= move_back.y
	}
}

pub fn (state &AppState) draw() {
	mut tribatch := graphics.tribatch()
	graphics.begin_pass({color:math.rgba(0.3, 0.1, 0.4, 1.0) trans_mat:0 pipeline:0 pass:0})
	tribatch.draw_hollow_rect(state.box.x, state.box.y, state.box.w, state.box.h, 2, math.yellow())
	tribatch.draw_hollow_rect(state.box2.x, state.box2.y, state.box2.w, state.box2.h, 2, math.red())
	tribatch.draw_hollow_circle(state.circle.r, 10, {x:state.circle.x y:state.circle.y color:math.orange()})
	tribatch.draw_hollow_circle(state.circle2.r, 10, {x:state.circle2.x y:state.circle2.y color:math.black()})
	graphics.end_pass()
}
