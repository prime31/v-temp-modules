VMOD := $${HOME}/.vmodules/

build:
	emcc wasm.c \
	-s ERROR_ON_UNDEFINED_SYMBOLS=0 \
	-s FORCE_FILESYSTEM=1 \
	-s ALLOW_MEMORY_GROWTH=1 \
	$(VMOD)via/libs/flextGL/thirdparty/ES20/flextGL.c \
	-s -I$(VMOD)via/libs/flextGL/thirdparty/ES20 \
	-s -I$(VMOD)via/libs/sokol/thirdparty \
	-s -I$(VMOD)via/libs/sokol/thirdparty/util \
	-s -I$(VMOD)via/libs/sokol/sdl_metal_util \
	-s -I$(VMOD)via/libs/fontstash/thirdparty \
	-s -I$(VMOD)via/libs/stb/image/thirdparty \
	-s -I$(VMOD)via/libs/physfs/thirdparty \
	-s -I$(VMOD)via/graphics/thirdparty \
	-s $(VMOD)via/libs/physfs/thirdparty/webgl/libphysfs.a \
	-s -I$(VMOD)via/libs/imgui \
	-s $(VMOD)via/libs/imgui/thirdparty/webgl/cimgui.a \
	-s -I$(VMOD)via/libs/fmod/thirdparty/core \
	-s -I$(VMOD)via/libs/fmod/thirdparty/studio \
	-s $(VMOD)via/libs/fmod/thirdparty/webgl/fmod.bc \
	-DIMGUI_IMPL_OPENGL_LOADER_CUSTOM \
	-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1 \
	-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1 \
	-DIMGUI_IMPL_API= \
	-s WASM=1 \
	-s USE_SDL=2 \
	-s USE_SDL_IMAGE=2 \
	-s USE_SDL_TTF=2 \
	-s SDL2_IMAGE_FORMATS='["png"]' \
	--preload-file ../assets \
	-DSOKOL_GLES2 \
	-o wasm.html

run:
	emrun wasm.html

open:
	emrun --no_browser --port 8080 .


build-and-run: build
	emrun --no_browser --port 8080 .
