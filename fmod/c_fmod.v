module fmod
import prime31.fmod.core.c as c_core
import prime31.fmod.studio.c as c_studio

#flag -I @VMOD/prime31/fmod/thirdparty/core
#flag -I @VMOD/prime31/fmod/thirdparty/studio

#flag darwin -L @VMOD/prime31/fmod/thirdparty -lfmod -lfmodstudio
#flag darwin -rpath @VMOD/prime31/fmod/thirdparty

#flag linux -L @VMOD/prime31/fmod/thirdparty
#flag linux -Wl,-rpath,@VMOD/prime31/fmod/thirdparty
#flag linux -lfmod -lfmodstudio

#include "fmod.h"
#include "fmod_studio.h"
#include "fmod_errors.h"


pub const (
	version = 1
)


fn C.FMOD_ErrorString(errcode int) byteptr

pub fn error_string(errcode int) string {
	return tos2(FMOD_ErrorString(errcode))
}