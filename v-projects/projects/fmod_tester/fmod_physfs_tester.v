import prime31.fmod.core as fmod
import prime31.fmod.physfs as fmod_physfs
import prime31.physfs
import prime31.sdl2
import time
import os


fn main() {
	physfs.initialize()
	physfs.mount(os.dir(os.realpath(os.executable())), '', true)

	sys := fmod.create(32, C.FMOD_INIT_NORMAL)

	fmod_physfs.set_physfs_file_system(sys)

	_, snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	snd.play(0)

	println('tick')
	time.sleep_ms(5000)
	physfs.deinit()
}
