import rand
import prime31.kinc

fn main() {
	C.kinc_run(start)
}

fn start() {
	kinc_init('kinc live via library'.str, 640, 480, C.NULL, C.NULL)
	kinc_set_update_callback(update)
	kinc_start()
}

fn update() {
	kinc_g4_begin(0)
	kinc_g4_clear(C.KINC_G4_CLEAR_COLOR, 0xffffffff, 0.0, 0)

	kinc_g4_end(0)
	kinc_g4_swap_buffers()
}
