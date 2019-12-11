module fmod

#flag -I @VMOD/prime31/fmod/thirdparty/core
#flag -I @VMOD/prime31/fmod/thirdparty/studio

#flag darwin -L @VMOD/prime31/fmod/thirdparty -lfmod
#flag darwin -rpath @VMOD/prime31/fmod/thirdparty

#include "fmod.h"
#include "fmod_studio.h"