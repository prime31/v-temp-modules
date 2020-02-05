import via
import via.math
import via.time
import via.input
import via.debug
import via.graphics
import via.filesystem
import via.collections
import via.libs.imgui

struct Sprite {
pub mut:
	col collections.Collider = collections.Collider{
		w: 32.0
		h: 32.0
	}
	vx f32
	vy f32
	id int
}

struct AppState {
mut:
	batch &graphics.QuadBatch = &graphics.QuadBatch(0)
	dude_tex graphics.Texture
	sprites []&Sprite
	space &collections.SpatialHash = &collections.SpatialHash(0)
}

const (
	width = 512.0
	height = 384.0
	sprite_cnt = 200
)

fn main() {
	state := AppState{
		space: collections.spatialhash(150)
	}

	filesystem.mount('../assets', 'assets', true)
	via.run(via.ViaConfig{
		win_resizable: false
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.dude_tex = graphics.new_texture('assets/dude.png')
	state.batch = graphics.quadbatch(sprite_cnt)

	for i in 0..sprite_cnt {
		state.add_sprite(math.range(-width, width), math.range(-height, height))
	}
}

fn (state mut AppState) add_sprite(x, y f32) {
	mut sprite := &Sprite {
		vx: math.range(-150, 150)
		vy: math.range(-150, 150)
	}
	sprite.col.x = x
	sprite.col.y = y
	sprite.id = state.space.add(sprite.col)
	state.sprites << sprite
}

pub fn (state mut AppState) update() {
	dt := time.dt()
	for i, sprite in state.sprites {
		mut s := state.sprites[i]
		s.col.x += s.vx * dt
		s.col.y += s.vy * dt

		if s.col.x + s.col.w > width {
			s.vx *= -1
			s.col.x = width - s.col.w
		} else 	if s.col.x < -width {
			s.vx *= -1
			s.col.x = -width
		}
		if s.col.y + s.col.h > height {
			s.vy *= -1
			s.col.y = height - s.col.h
		} else if s.col.y < -height {
			s.vy *= -1
			s.col.y = -height
		}

		state.space.update(s.id, s.col)
	}
}

pub fn (state mut AppState) draw() {
	graphics.begin_default_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0)}, {})

	state.batch.begin()
	for s in state.sprites {
		state.batch.draw(state.dude_tex, {x:s.col.x, y:s.col.y})
	}
	state.batch.end()

	state.space.debug_draw()
	debug.draw_text(-width, -height, 'FPS: $time.fps()', {align:.top scale:3 color:math.color_black()})
	graphics.end_pass()
}