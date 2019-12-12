module fmod
import prime31.fmod.core

pub struct ChannelGroup {
pub:
	group &FMOD_CHANNELGROUP
}

pub fn (cg &ChannelGroup) add_dsp(index int, dsp Dsp) Result {
	return FMOD_ChannelGroup_AddDSP(cg.group, index, dsp.dsp)
}