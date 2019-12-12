import prime31.fmod
import time

fn main() {
	sys := fmod.create(32, C.FMOD_INIT_NORMAL)
	println('fmod version=${sys.get_version()}')

	snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	len := snd.get_length(.ms)
	println('snd len=$len')

	_, group := sys.create_channel_group("tester")
	_, channel := snd.play(group, 0)
	channel.set_pitch(1.2)
	println('group=${group.group}, channel=${channel.ch}')

	sys.get_master_channel_group(mut group)
	println('group=${group.group}')

	dsp := fmod.Dsp{}
	sys.create_dsp_by_type(.echo, mut dsp)
	group.add_dsp(0, dsp)

	active := -1
	act_res := FMOD_DSP_GetActive(dsp.dsp, &active)
	println('dsp active=$active, res=$act_res')

	res, state, percent_buffered, starving, diskbusy := snd.get_open_state()
	println('state=$state, res=$res, buff=$percent_buffered')

	println('name=${snd.get_name()}')

	println('tick')
	time.sleep_ms(5000)
}