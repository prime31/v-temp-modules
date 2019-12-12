module fmod
import prime31.fmod.core

pub struct System {
pub:
	sys &FMOD_SYSTEM
}

pub fn create(maxchannels int, flags int) System {
	fmod := System{}
	FMOD_System_Create(&fmod.sys)
	FMOD_System_Init(fmod.sys, maxchannels, flags, C.NULL /*extradriverdata*/)
	return fmod
}

pub fn (s &System) get_version() u32 {
	ver := u32(0)
	FMOD_System_GetVersion(s.sys, &ver)
	return ver
}

pub fn (s &System) create_sound(name_or_data byteptr, mode int /* exinfo &FMOD_CREATESOUNDEXINFO */) Sound {
	mut snd := Sound{}
	snd.sys = s
	FMOD_System_CreateSound(s.sys, name_or_data, mode, C.NULL, &snd.sound)
	return snd
}

pub fn (s &System) play_sound(sound &FMOD_SOUND, channelgroup voidptr /* &FMOD_CHANNELGROUP */, paused int, channel mut Channel /* **FMOD_CHANNEL */) Result {
	return FMOD_System_PlaySound(s.sys, sound, channelgroup, paused, &channel.ch)
}

pub fn (s &System) update() Result {
	return FMOD_System_Update(s.sys)
}

/*
	mut data := &fmod.Channel{}
	sys.set_user_data(data)
	println('sent: ${data}')
	data = 0
	sys.get_user_data(&data)
	println('received: ${data}')
*/
pub fn (s &System) set_user_data(userdata voidptr) Result {
	return FMOD_System_SetUserData(s.sys, userdata)
}

pub fn (s &System) get_user_data(userdata voidptr) Result {
	return FMOD_System_GetUserData(s.sys, userdata)
}