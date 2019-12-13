module physfs
import prime31.fmod

pub const (
	version = fmod.version
)

#flag -I @VMOD/prime31/fmod/physfs
#include "physfs_file_system.h"


fn C.set_physfs_file_system(s &FMOD_SYSTEM) int

pub fn enable_physf_filesystem(s &fmod.System) int {
	return set_physfs_file_system(s.sys)
}
