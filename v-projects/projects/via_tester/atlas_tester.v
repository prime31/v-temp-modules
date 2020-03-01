import via
import via.math
import via.time
import via.debug
import via.graphics
import via.libs.imgui
import via.tweens

struct AppState {
mut:
	batch &graphics.AtlasBatch = &graphics.AtlasBatch(0)
	tween tweens.Tween
}

fn main() {
	state := AppState{
		tween: tweens.tween(0, 100, 5, .back_in_out)
	}
	via.run(via.ViaConfig{
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	atlas := graphics.new_texture_atlas('assets/adventurer.atlas')
	state.batch = graphics.new_atlasbatch(atlas.tex, 20)

	atlas_names := atlas.get_names()
	for i in 0..10 {
		q := atlas.get_quad(atlas_names[i])
		state.batch.add_q(q, {x:i * 32 + 500 y:300})
	}

	quad1 := atlas.get_quad('adventurer-run-04')
	quad2 := atlas.get_quad('adventurer-run-03')
	quad3 := atlas.get_quad('adventurer-run-02')
	quad4 := atlas.get_quad('adventurer-run-01')
	for i in 0..10 {
		q := math.choose4(quad1, quad2, quad3, quad4)
		state.batch.add_q(q, {x:8 + 500 y: (f32(i) + 2.0) * 24 + 308 rot:math.range(20, 340) ox:25 oy:18.5})
	}
}

pub fn (state mut AppState) update() {
	state.tween.tick(time.dt())
	C.igText(c'Tween: %f, %f  current: %f', state.tween.start, state.tween.end, state.tween.value())
	debug.draw_hollow_rect(state.tween.value(), 10, 50, 50, 2, math.yellow())

	if C.igSmallButton(c'Start sin') {
		state.tween = tweens.tween(0, 100, 2, .sin_in_out)
		state.tween.set_cb(state, tween_cb)
	}

	if C.igSmallButton(c'Start back_in_out') {
		state.tween = tweens.tween(0, 100, 2, .back_in_out)
	}
}

fn tween_cb(state &AppState, tween &tweens.Tween) {
	println('all done')
}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.rgba(1.0, 0.3, 1.0, 1.0)})
	state.batch.draw()
	graphics.end_pass()
}