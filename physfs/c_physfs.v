module physfs

#flag -I @VMOD/prime31/physfs/physfs_hg/src

#flag darwin -L /usr/local/lib -lSDL2
#flag darwin -I /usr/local/opt/sdl2/include/SDL2
#flag -I @VMOD/prime31/physfs/physfs_hg/extras
#flag darwin @VMOD/prime31/physfs/physfs_hg/build/physfsrwops.o

#flag darwin -framework IOKit -framework Foundation
#flag darwin @VMOD/prime31/physfs/physfs_hg/build/libphysfs.a

#include "physfs.h"
#include "physfsrwops.h"
