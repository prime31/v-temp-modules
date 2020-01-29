import via
import via.math
import via.graphics
import via.libs.imgui
import via.libs.sokol.sdl_metal_util

struct AppState {
mut:
	atlas graphics.TextureAtlas
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	tbatch &graphics.TriangleBatch = &graphics.TriangleBatch(0)
	beach_tex graphics.Texture
	dude_tex graphics.Texture
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize(via &via.Via) {
	state.beach_tex = via.g.new_texture('assets/beach.png')
	state.batch = graphics.quadbatch(2000)
	state.tbatch = graphics.trianglebatch(2000)
}

pub fn (state mut AppState) update(via &via.Via) {}

pub fn (state mut AppState) draw(via &via.Via) {
	w, h := via.win.get_drawable_size()
	pass_action := via.g.make_pass_action({color:math.color_from_floats(0.1, 0.1, 0.1, 1.0)})

	if w == 0 {
		sg_begin_default_pass(&pass_action.pass, 0, 0)
		sg_end_pass()
		return
	}

	via.g.begin_default_pass(&pass_action, {})

	state.batch.begin()
	state.batch.draw(state.beach_tex, {x: 0, y: 0})
	state.batch.draw(state.beach_tex, {x: -600, y: -40, rot: 45})
	state.batch.end()


	state.tbatch.begin()
	state.tbatch.draw_triangle(200, 200, 200, 300, 400, 200)
	state.tbatch.draw_rectangle(-500, -500, 200, 100)
	state.tbatch.draw_circle(-400, 400, 75, 6)
	state.tbatch.draw_circle(-500, 200, 75, 16)
	state.tbatch.draw_polygon([math.Vec2{0, 0}, math.Vec2{100, -100}, math.Vec2{200, 50}, math.Vec2{50, 200}, math.Vec2{-55, 100}]!)
	state.tbatch.end()

	via.g.end_pass()
}