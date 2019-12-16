module via

struct Via {
	audio &Audio
	filesystem &FileSystem
	graphics &Graphics
	timer &Timer
	window &Window
}

pub fn create_via(config ViaConfig) &Via {
	via := &Via {
		audio: create_audio(config)
		filesystem: create_filesystem(config)
		graphics: create_graphics(config)
		timer: create_timer(config)
		window: create_window(config)
	}

	return via
}

pub (v &Via) free() {
	free(v)
}