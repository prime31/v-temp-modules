module via

struct Via {
pub:
	audio &Audio
	filesystem &FileSystem
	graphics &Graphics
	timer &Timer
	window &Window
}

pub fn create(config ViaConfig) &Via {
	filesystem := create_filesystem(config)
	via := &Via {
		audio: create_audio(config)
		filesystem: filesystem
		graphics: create_graphics(config, filesystem)
		timer: create_timer(config)
		window: create_window(config)
	}

	return via
}

pub fn (v &Via) free() {
	v.audio.free()
	v.filesystem.free()
	v.graphics.free()
	v.timer.free()
	v.window.free()

	free(v)
}