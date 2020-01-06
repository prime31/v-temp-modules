import via.libs.fmod.core as fmod
import time

fn main() {
	sys := fmod.create(32, C.FMOD_INIT_NORMAL)
	println('fmod version=${sys.get_version()}')


	_, snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	len := snd.get_length(.ms)
	println('snd len=$len')

	_, snd_group := sys.create_sound_group("snd grouper")
	println('snd_group=$snd_group.group')

	_, group := sys.create_channel_group("tester")
	_, channel := snd.play_in_group(group, 0)
	_, _ := snd.play(0)
	channel.set_pitch(1.2)
	println('group=${group.group}, channel=${channel.ch}')

	_, master_group := sys.get_master_channel_group()
	println('master_group=${master_group.group}')

	_, dsp := sys.create_dsp_by_type(.flange)
	master_group.add_dsp(0, dsp)
	// master_group.remove_dsp(dsp)

	active := -1
	act_res := FMOD_DSP_GetActive(dsp.dsp, &active)
	println('dsp active=$active, res=$act_res')

	res, state, percent_buffered, starving, diskbusy := snd.get_open_state()
	println('state=$state, res=$res, buff=$percent_buffered')

	_, name := snd.get_name()
	println('name=$name')

	println('tick')
	time.sleep_ms(5000)
}
