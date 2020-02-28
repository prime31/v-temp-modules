import via
import via.math
import via.time
import via.debug
import via.input
import via.window
import via.graphics
import via.physics
import via.comps
import via.physics.verlet

struct AppState {
mut:
	box physics.AabbCollider
	world verlet.World
	speed int = 3
	rot f32
}

fn main() {
	state := AppState{}

	via.run({
		win_highdpi: true
		resolution_policy: .show_all_pixel_perfect
		design_width: 640
		design_height: 480
		win_width: 640
		win_height: 480
		imgui: true
		max_tris: 1000
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.box = physics.aabbcollider(50, 50, 50, 80)
	state.world = verlet.world(math.RectF{0, 0, 640, 480})

	mut comp := verlet.composite()
	comp.add_particle(verlet.particle(math.Vec2{10, 10}))
	comp.add_particle(verlet.particle(math.Vec2{20, 20}))
	comp.add_particle(verlet.particle(math.Vec2{20, 20}))
	state.world.composites << comp

	state.world.composites << verlet.ball(math.Vec2{40, 15}, 10)
	state.world.composites << verlet.ball(math.Vec2{80, 25}, 15)
	state.world.composites << verlet.box(math.Vec2{300, 240}, 50, 50, 0.9, 0.8)
	state.world.composites << verlet.rope(math.Vec2{150, 10}, 250, 10, 0.6)
	state.world.composites << verlet.rope(math.Vec2{200, 10}, 250, 20, 0.3)
	state.world.composites << verlet.cloth(math.Vec2{350, 40}, 250, 200, 10, 0.75, 5.0)
}

pub fn (state mut AppState) update() {
	C.igSliderInt(c'Speed', &state.speed, 1, 17, C.NULL)
	state.world.tick()

	mut move := math.Vec2{}

	if input.key_down(.right) {
		move.x = state.speed
	} else if input.key_down(.left) {
		move.x = -state.speed
	}

	if input.key_down(.up) {
		move.y = -state.speed
	} else if input.key_down(.down) {
		move.y = state.speed
	}

	if move.x != 0 || move.y != 0 {
		state.box.x += move.x
		state.box.y += move.y
	}
}

pub fn (state mut AppState) draw() {
	state.world.render()

	mut tribatch := graphics.tribatch()
	graphics.begin_pass({color:math.rgba(0.01, 0.0, 0.0, 1.0)})
	// tribatch.draw_hollow_rect(state.box.x, state.box.y, state.box.w, state.box.h, 1, math.red())
	graphics.end_pass()
}