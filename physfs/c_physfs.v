module physfs

#flag -I @VMOD/prime31/physfs/thirdparty
#flag darwin @VMOD/prime31/physfs/physfs_hg/build/physfsrwops.o

#flag darwin -framework IOKit -framework Foundation
#flag darwin @VMOD/prime31/physfs/physfs_hg/build/libphysfs.a

#include "physfs.h"
#include "physfsrwops.h"
