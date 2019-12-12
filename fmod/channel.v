module fmod
import prime31.fmod.core

pub struct Channel {
pub:
	ch &FMOD_CHANNEL
}

pub fn (c &Channel) set_pitch(pitch f32) Result {
	return FMOD_Channel_SetPitch(c.ch, pitch)
}

pub fn (c &Channel) add_dsp(index int, dsp Dsp) Result {
	return FMOD_Channel_AddDSP(c.ch, index, dsp.dsp)
}

pub fn (c &Channel) remove_dsp(dsp Dsp) Result {
	return FMOD_Channel_RemoveDSP(c.ch, dsp.dsp)
}