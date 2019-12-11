module fmod
import prime31.fmod.core

pub struct Channel {
pub:
	ch &FMOD_CHANNEL
}

pub fn (c &Channel) set_pitch(pitch f32) core.Result {
	return FMOD_Channel_SetPitch(c.ch, pitch)
}