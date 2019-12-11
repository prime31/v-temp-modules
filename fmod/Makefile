MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))

FMOD_FOLDER := FMOD Programmers API

all: remove_unused_folders copy_files clean

remove_unused_folders:
	rm -rf '$(FMOD_FOLDER)/api/core/examples'
	rm -rf '$(FMOD_FOLDER)/api/studio/examples'

copy_files:
	[ -d $(MODULE_FOLDER)/core ] || mkdir $(MODULE_FOLDER)/core
	[ -d $(MODULE_FOLDER)/studio ] || mkdir $(MODULE_FOLDER)/studio
	cp '$(FMOD_FOLDER)/api/core/lib/libfmod.dylib' $(MODULE_FOLDER)
	cp '$(FMOD_FOLDER)/api/core/lib/libfmodL.dylib' $(MODULE_FOLDER)
	cp '$(FMOD_FOLDER)/api/studio/lib/libfmodstudio.dylib' $(MODULE_FOLDER)
	cp '$(FMOD_FOLDER)/api/studio/lib/libfmodstudioL.dylib' $(MODULE_FOLDER)
	rsync -rupE --include="*/" --include="*.h" --exclude="*" '$(FMOD_FOLDER)/api/core/inc/' $(MODULE_FOLDER)/core
	rsync -rupE --include="*/" --include="*.h" --exclude="*" '$(FMOD_FOLDER)/api/studio/inc/' $(MODULE_FOLDER)/studio

clean:
	rm -rf '$(FMOD_FOLDER)'
