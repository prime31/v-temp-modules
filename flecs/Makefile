MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))

TARGET = build
TARGET += patch_flecs_bool
TARGET += copy_static

##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Linux)
	SED := sed -i
	TARGET += copy_linux_shared
else ifeq ($(UNAME_S), Darwin)
	SED := sed -i ''
	TARGET += copy_mac_shared
endif

TARGET += clean


all: $(TARGET)

# fix flecs typedef since v has its own to int already
patch_flecs_bool:
ifdef SED
	$(SED) "s/typedef char bool;/\/\/typedef char bool;/g" flecs_git/include/flecs.h
endif

copy_static:
	cp flecs_git/build/libflecs_static.a $(MODULE_FOLDER)
	rsync -rupE flecs_git/include $(MODULE_FOLDER)

copy_mac_shared:
	cp flecs_git/build/libflecs_shared.dylib $(MODULE_FOLDER)

copy_linux_shared:
	cp flecs_git/build/libflecs_shared.so $(MODULE_FOLDER)

build:
	[ -d flecs_git ] || git clone --depth 1 https://github.com/SanderMertens/flecs flecs_git
	(cd flecs_git ; mkdir build ; cd build ; cmake .. ; make)

clean:
	rm -rf flecs_git
