TARGET := fetch_imgui
TARGET += gl3w.o
TARGET += clean

CP := cp
MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))

LIBS :=

## Using OpenGL loader: gl3w
CFLAGS := -I imgui/examples/libs/gl3w


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

fetch_imgui:
	[ -d imgui ] || git clone --recursive --depth 1 https://github.com/ocornut/imgui

gl3w.o: imgui/examples/libs/gl3w/GL/gl3w.c
	$(CC) $(CFLAGS) -c -o $(MODULE_FOLDER)/$@ $<
	rsync -rupE imgui/examples/libs/gl3w $(MODULE_FOLDER)

clean:
	$(RM) -Rf imgui
