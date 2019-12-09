MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))

# fix flecs typedef since v has its own to int already
libflecs_shared.dylib: flecs_git/build/libflecs_shared.dylib
	sed -i '' "s/typedef char bool;/\/\/typedef char bool;/g" flecs_git/include/flecs.h
	cp flecs_git/build/libflecs_shared.dylib $(MODULE_FOLDER)
	cp flecs_git/build/libflecs_static.a $(MODULE_FOLDER)
	rsync -rupE flecs_git/include $(MODULE_FOLDER)

flecs_git/build/libflecs_shared.dylib:
	[ -d flecs_git ] || git clone --depth 1 https://github.com/SanderMertens/flecs flecs_git
	(cd flecs_git ; mkdir build ; cd build ; cmake .. ; make)

clean:
	rm -rf flecs_git
