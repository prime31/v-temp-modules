module kinc
import prime31.kinc.c

#flag darwin -DKORE_G1 -DKORE_G2 -DKORE_G3 -DKORE_A1 -DKORE_A2 -DKORE_MACOS -DKORE_METAL -DKORE_POSIX
#flag darwin -DKORE_G4 -DKORE_G5 -DKORE_G4ONG5 -DKORE_A3
#flag darwin -framework Foundation -framework CoreGraphics -framework Metal -framework MetalKit -framework CoreVideo
#flag darwin -framework IOKit -framework Cocoa

#flag -I@VMOD/prime31/kinc/thirdparty/Kinc/Sources
#flag -I@VMOD/prime31/kinc/thirdparty/Kinc/Backends/Graphics4/G4onG5/Sources
#flag darwin -I@VMOD/prime31/kinc/thirdparty/Kinc/Backends/Graphics5/Metal/Sources

#flag -L@VMOD/prime31/kinc/thirdparty
#flag -lkinc -lm -lc++

#include "Kore/pch.h"
#include <kinc/io/filereader.h>
#include <kinc/system.h>
#include <kinc/window.h>
#include <kinc/image.h>
#include <kinc/display.h>
#include <kinc/graphics4/graphics.h>
#include <kinc/graphics4/indexbuffer.h>
#include <kinc/graphics4/pipeline.h>
#include <kinc/graphics4/shader.h>
#include <kinc/graphics4/vertexbuffer.h>