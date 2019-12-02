TARGET :=
# use either a dylib or static lib
TARGET += cimgui.dylib
TARGET += cimgui.a
TARGET += gl3w.o
TARGET += imgui_impl_sdl.o
TARGET += imgui_impl_opengl3.o

CP := cp
MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))
CIMGUI := cimgui
IMGUI := $(CIMGUI)/imgui

LIBS :=

CFLAGS := -I.
CFLAGS += -DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1
CFLAGS += -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1
CFLAGS += -DIMGUI_IMPL_API=
CFLAGS += `sdl2-config --cflags`

## Using OpenGL loader: gl3w
CFLAGS += -Icimgui/imgui/examples/libs/gl3w


##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Linux) #LINUX
	LIBS += -lGL -ldl `sdl2-config --libs`
	CFLAGS += `sdl2-config --cflags`
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	LIBS += -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`
	LIBS += -L/usr/local/lib

	CFLAGS += `sdl2-config --cflags`
	CFLAGS += -I/usr/local/include
	CFLAGS += -DIMGUI_IMPL_OPENGL_LOADER_GL3W
endif



##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

all: $(TARGET)
	@echo build complete

cimgui.dylib: cimgui/build/cimgui.dylib
	$(CP) cimgui/cimgui.h $(MODULE_FOLDER)/cimgui.h
	$(CP) cimgui/build/cimgui.dylib $(MODULE_FOLDER)/cimgui.dylib

cimgui/build/cimgui.dylib:
	[ -d cimgui ] || git clone --recursive --depth 1 https://github.com/cimgui/cimgui.git
	(export CFLAGS= CXXFLAGS= ; cd cimgui ; mkdir build ; cd build ; cmake -DIMGUI_STATIC=OFF .. ; make)

cimgui.a: cimgui/build/cimgui.a
	$(CP) cimgui/cimgui.h $(MODULE_FOLDER)/cimgui.h
	$(CP) cimgui/build/cimgui.a $(MODULE_FOLDER)/cimgui.a

cimgui/build/cimgui.a:
	[ -d cimgui ] || git clone --recursive --depth 1 https://github.com/cimgui/cimgui.git
	(export CFLAGS= CXXFLAGS= ; cd cimgui ; mkdir build ; cd build ; cmake -DIMGUI_STATIC=ON .. ; make)

gl3w.o: cimgui/imgui/examples/libs/gl3w/GL/gl3w.c
	$(CC) $(CFLAGS) -c -o $(MODULE_FOLDER)/$@ $<
	rsync -rupE cimgui/imgui/examples/libs/gl3w $(MODULE_FOLDER)

imgui_impl_sdl.o: $(IMGUI)/examples/imgui_impl_sdl.cpp
	$(CXX) -fPIC -c -o $(MODULE_FOLDER)/$@ $^ -I$(IMGUI) `sdl2-config --cflags` -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics
	$(CP) $(IMGUI)/examples/imgui_impl_sdl.h $(MODULE_FOLDER)/imgui_impl_sdl.h
	sed -i '' "s/(SDL_Window/(struct SDL_Window/g" $(MODULE_FOLDER)/imgui_impl_sdl.h

imgui_impl_opengl3.o: $(IMGUI)/examples/imgui_impl_opengl3.cpp
	$(CXX) -fPIC -c -o $(MODULE_FOLDER)/$@ $^ -I$(IMGUI) $(CFLAGS) $(LIBS) -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics
	$(CP) $(IMGUI)/examples/imgui_impl_opengl3.h $(MODULE_FOLDER)/imgui_impl_opengl3.h
	sed -i '' "s/glsl_version = NULL/glsl_version/g" $(MODULE_FOLDER)/imgui_impl_opengl3.h

clean:
	$(RM) *.o *.so *.h $(TARGET)

clobber: clean
	$(RM) -Rf cimgui
