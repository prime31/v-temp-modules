TARGET :=

# gl3w from Dear ImGui repo
# TARGET += fetch_imgui
# TARGET += gl3w.o_from_gl3w

# gl3w from source
TARGET += fetch_gl3w
TARGET += build_gl3w
TARGET += gl3w.o_from_gl3w
TARGET += clean

CP := cp
MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))

LIBS :=

## Using OpenGL loader: gl3w
CFLAGS := -I imgui_git/examples/libs/gl3w
CFLAGS := -I gl3w_git/include


##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Linux) #LINUX
	LIBS += -lGL -ldl
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	LIBS += -framework OpenGL
	LIBS += -L/usr/local/lib

	CFLAGS += -I/usr/local/include
endif



##---------------------------------------------------------------------
## BUILD RULES: we use the gl3w implementation from the imgui repo
##---------------------------------------------------------------------
all: $(TARGET)
	@echo build complete

# imgui libs folder as source
fetch_imgui:
	[ -d imgui_git ] || git clone --recursive --depth 1 https://github.com/ocornut/imgui imgui_git

gl3w.o_from_imgui:
	$(CC) $(CFLAGS) -c -o $(MODULE_FOLDER)/gl3w.o imgui_git/examples/libs/gl3w/GL/gl3w.c
	rsync -rupE imgui_git/examples/libs/gl3w/GL $(MODULE_FOLDER)


# gl3w as source
fetch_gl3w:
	[ -d gl3w_git ] || git clone --depth 1 https://github.com/skaslev/gl3w gl3w_git

build_gl3w:
	$(RM) -Rf gl3w_git/src
	# we dont need all of the extensions, so we will limit it by changing a few out
	# note that these should match what the GL generator gets as input
	sed -i '' "s/'ARB', 'EXT', 'KHR', 'OVR', 'NV', 'AMD', 'INTEL'/\'ARB', 'EXT', 'KHR'/g" gl3w_git/gl3w_gen.py
	python gl3w_git/gl3w_gen.py --root gl3w_git

gl3w.o_from_gl3w:
	$(CC) $(CFLAGS) -c -o $(MODULE_FOLDER)/gl3w.o gl3w_git/src/gl3w.c
	rsync -rupE gl3w_git/include/GL $(MODULE_FOLDER)
	rsync -rupE gl3w_git/include/KHR $(MODULE_FOLDER)

clean:
	$(RM) -Rf imgui_git
	$(RM) -Rf gl3w_git
