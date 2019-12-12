module fmod

#flag -I @VMOD/prime31/fmod/file_system
#flag -I @VMOD/prime31/fmod/thirdparty/core
#flag -I @VMOD/prime31/fmod/thirdparty/studio

#flag darwin -L @VMOD/prime31/fmod/thirdparty -lfmod
#flag darwin -rpath @VMOD/prime31/fmod/thirdparty

#include "fmod.h"
#include "fmod_studio.h"
#include "fmod_errors.h"
#include "c_file_system.h"
#include "physfs_file_system.h"


fn C.FMOD_ErrorString(errcode int) byteptr

pub fn error_string(errcode int) string {
	return tos2(FMOD_ErrorString(errcode))
}