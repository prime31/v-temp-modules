import via
import via.math
import via.window
import via.graphics
import via.filesystem
import via.comps
import via.comps.tilemaps
import json

struct AppState {
mut:
	renderer tilemaps.MapRenderer
}

fn main() {
	state := AppState{}
	via.run(via.ViaConfig{
		win_highdpi: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	filesystem.mount('assets', '', true)
	map := json.decode(tilemaps.Map, filesystem.read_text_c(c'assets/platformer.json')) or { panic('could not load map') }
	state.renderer = tilemaps.maprenderer(map)
}

pub fn (state &AppState) update() {}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.color_from_floats(0.3, 0.1, 0.4, 1.0)})
	state.renderer.render()
	graphics.end_pass()
}