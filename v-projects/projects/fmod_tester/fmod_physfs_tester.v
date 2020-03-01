import via.libs.fmod.core as fmod
import via.libs.fmod.physfs as fmod_physfs
import via.libs.physfs
import via.libs.sdl2
import time
import os
import filepath


fn main() {
	physfs.initialize()
	physfs.mount(filepath.dir(os.realpath(os.executable())), '', true)

	sys := fmod.create(32, C.FMOD_INIT_NORMAL)

	fmod_physfs.set_physfs_file_system(sys)

	_, snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	snd.play(0)

	println('tick')
	time.sleep_ms(5000)
	physfs.deinit()
}
