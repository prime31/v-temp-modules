module fmod
import prime31.fmod.core

pub struct Channel {
pub:
	ch &FMOD_CHANNEL
mut:
	s byteptr
}

pub fn (c Channel) str() string {
	return 'channel yo, with [$c.s]'
}

pub fn (c &Channel) set_pitch(pitch f32) int {
	return FMOD_Channel_SetPitch(c.ch, pitch)
}