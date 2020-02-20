import via
import via.math
import via.time
import via.debug
import via.input
import via.window
import via.graphics
import via.physics.gjk
import via.filesystem
import via.comps
import via.tilemap
import json

struct AppState {
mut:
	renderer tilemap.MapRenderer
	layer_batch &graphics.AtlasBatch
	square math.Rect
	map tilemap.Map
}

fn main() {
	state := AppState{
		layer_batch: 0
	}

	via.run({
		win_highdpi: true
		resolution_policy: .show_all_pixel_perfect
		design_width: 640
		design_height: 480
		win_width: 640 * 2
		win_height: 480 * 2
		imgui: true
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	filesystem.mount('assets', '', true)

	now0s := time.now()
	state.map = tilemap.load(filesystem.read_bytes_c(c'assets/platformer.json'))
	now0e := time.now()

	now1s := time.now()
	map := json.decode(tilemap.Map, filesystem.read_text_c(c'assets/platformer.json')) or { panic('could not load map') }
	now1e := time.now()

	state.renderer = tilemap.maprenderer(state.map)
	state.layer_batch = state.renderer.tilelayer_atlasbatch(state.map.tile_layers[0])

	obj_layer := state.map.object_layers[0]
	spawn := obj_layer.get_object('spawn')
	state.square = math.Rect{int(spawn.x), int(spawn.y), int(spawn.w), int(spawn.h)}

	// t1 := state.map.tilesets[0].tileset_tile(2)
	// println('$t1.props')

	jsmnt := now0e - now0s
	jst := now1e - now1s
	debug.warn('-- jsmn: ${f32(jsmnt) / 1000}, jst: ${f32(jst) / 1000} --')
}

pub fn (state mut AppState) update() {
	speed := 5
	mut move := math.Vec2{}

	if input.is_key_down(.right) {
		move.x = speed
	} else if input.is_key_down(.left) {
		move.x = -speed
	}

	if input.is_key_down(.up) {
		move.y = -speed
	} else if input.is_key_down(.down) {
		move.y = speed
	}

	if move.x != 0 || move.y != 0 {
		tilemap.move(state.map, state.square, mut move)
		state.square.x += move.x
		state.square.y += move.y
	}

	C.igText(c'Pos: %d, %d, right: %d, bottom: %d', state.square.x, state.square.y, state.square.right(), state.square.bottom())
}

pub fn (state mut AppState) draw() {
	mut tribatch := graphics.tribatch()
	graphics.begin_pass({color:math.color_from_floats(0.3, 0.1, 0.4, 1.0)})
	// state.renderer.render()
	tribatch.draw_hollow_rect(state.square.x, state.square.y, state.square.w, state.square.h, 1, math.color_red())
	state.layer_batch.draw()
	graphics.end_pass()
}