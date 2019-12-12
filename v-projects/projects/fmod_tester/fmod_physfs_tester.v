import prime31.fmod
import prime31.physfs
import prime31.sdl2
import time
import os


fn C.set_physfs_file_system(s FMOD_SYSTEM)

fn main() {
	physfs.initialize()
	physfs.mount(os.dir(os.realpath(os.executable())), '', 1)

	sys := fmod.create(32, C.FMOD_INIT_NORMAL)

	set_physfs_file_system(sys.sys)

	snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	_, _ := snd.play(0)

	println('tick')
	time.sleep_ms(5000)
	physfs.deinit()
}
