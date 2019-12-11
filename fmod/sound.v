module fmod
import prime31.fmod.core

struct Sound {
	sound &FMOD_SOUND
mut:
	sys &System
}

pub fn (s &Sound) get_length(unit FmodTimeUnit) u32 {
	len := u32(0)
	FMOD_Sound_GetLength(s.sound, &len, u32(unit))
	return len
}

pub fn (s &Sound) release() core.Result {
	return FMOD_Sound_Release(s.sound)
}

pub fn (s &Sound) play(channelgroup voidptr /* &FMOD_CHANNELGROUP */, paused int, channel mut Channel /* **FMOD_CHANNEL */) core.Result {
	return s.sys.play_sound(s.sound, channelgroup, paused, mut channel)
}