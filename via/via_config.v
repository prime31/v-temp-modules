module via

struct ViaConfig {
	identity string 						// save directory name
	append_identity bool = false 			// search files in src dir before save dir

	window_title string = "V is for Via"
	window_width int = 1024
	window_height int = 768
	window_x int
	window_y int
	window_resizable bool = true
	window_fullscreen bool = false
	window_vsync bool = true
	window_highdpi bool = false
}