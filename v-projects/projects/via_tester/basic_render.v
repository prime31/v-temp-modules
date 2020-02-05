import via
import via.math
import via.window
import via.graphics

struct AppState {
mut:
	atlas graphics.TextureAtlas
	batch &graphics.QuadBatch
	tbatch &graphics.TriangleBatch = &graphics.TriangleBatch(0)
	beach_tex graphics.Texture
	dude_tex graphics.Texture
}

fn main() {
	state := AppState{
		// atlas: &graphics.TextureAtlas(0)
		batch: 0
		tbatch: 0
	}
	via.run(via.ViaConfig{}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.beach_tex = graphics.new_texture('assets/beach.png')
	state.batch = graphics.quadbatch(2000)
	state.tbatch = graphics.trianglebatch(2000)
}

pub fn (state &AppState) update() {}

pub fn (state mut AppState) draw() {
	w, _ := window.drawable_size()
	if w == 0 {
		pass_action := sg_pass_action{}
		sg_begin_default_pass(&pass_action, 0, 0)
		sg_end_pass()
		return
	}

	graphics.begin_default_pass({color:math.color_from_floats(0.1, 0.1, 0.4, 1.0)}, {})

	state.batch.draw(state.beach_tex, {x: 0, y: 0})
	state.batch.draw(state.beach_tex, {x: -600, y: -40, rot: 45})
	state.batch.end()


	state.tbatch.draw_triangle(200, 200, 200, 300, 400, 200)
	state.tbatch.draw_rectangle(-500, -500, 200, 100)
	state.tbatch.draw_circle(-400, 400, 75, 6)
	state.tbatch.draw_circle(-500, 200, 75, 16)
	state.tbatch.draw_polygon([math.Vec2{0, 0}, math.Vec2{100, -100}, math.Vec2{200, 50}, math.Vec2{50, 200}, math.Vec2{-55, 100}]!)
	state.tbatch.end()

	graphics.end_pass()
}