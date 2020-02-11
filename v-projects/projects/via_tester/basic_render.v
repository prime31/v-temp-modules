import via
import via.math
import via.window
import via.graphics
import via.components

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
		batch: 0
		tbatch: 0
	}
	via.run(via.ViaConfig{
		win_highdpi: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.beach_tex = graphics.new_texture('assets/beach.png')
	state.batch = graphics.quadbatch(2000)
	state.tbatch = graphics.trianglebatch(2000)
}

pub fn (state &AppState) update() {}

pub fn (state mut AppState) draw() {
	// hack when testing metal which has 0 size for a frame
	w, h := window.drawable_size()
	if w == 0 {
		pass_action := sg_pass_action{}
		sg_begin_default_pass(&pass_action, 0, 0)
		sg_end_pass()
		return
	}

	scaler := graphics.get_resolution_scaler()

	trans_mat := math.mat32_translate(scaler.w/2, scaler.h/2)
	graphics.begin_pass({color:math.color_from_floats(0.1, 0.1, 0.4, 1.0) trans_mat:&trans_mat})

	state.batch.draw(state.beach_tex, {x: 0, y: 0})
	state.batch.draw(state.beach_tex, {x: -600, y: -40, rot: 45})
	state.batch.end()


	state.tbatch.draw_triangle(200, 200, 200, 300, 400, 200, {x:0})
	state.tbatch.draw_rectangle(-500, -500, 200, 100, {x:0})
	state.tbatch.draw_circle(-400, 400, 75, 6, {x:0})
	state.tbatch.draw_circle(-500, 200, 75, 16, {x:0})
	state.tbatch.draw_polygon([math.Vec2{0, 0}, math.Vec2{100, -100}, math.Vec2{200, 50}, math.Vec2{50, 200}, math.Vec2{-55, 100}]!, {x:0})
	state.tbatch.end()

	graphics.end_pass()
	graphics.blit_to_screen(math.color_red())
}