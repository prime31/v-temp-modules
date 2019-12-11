import prime31.fmod
import time

fn main() {
	sys := fmod.create(32, 0, C.NULL)
	println('fmod version=${sys.get_version()}')

	snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	len := snd.get_length(.ms)
	println('snd len=$len')

	channel := fmod.Channel{}
	snd.play(voidptr(0), 0, mut channel)
	println('${channel.ch}')
	channel.set_pitch(1.5)


	println('tick')
	time.sleep_ms(5000)
}