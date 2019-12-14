module physfs

#flag -I @VMOD/prime31/physfs/thirdparty
#flag darwin @VMOD/prime31/physfs/thirdparty/physfsrwops.o

#flag darwin -framework IOKit -framework Foundation
#flag darwin @VMOD/prime31/physfs/thirdparty/libphysfs.a

#flag linux @VMOD/prime31/physfs/thirdparty/physfsrwops.o
#flag linux @VMOD/prime31/physfs/thirdparty/libphysfs.a

#include "physfs.h"
#include "physfsrwops.h"
