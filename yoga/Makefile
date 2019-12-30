TARGET :=

CP := cp
MODULE_FOLDER := thirdparty
$(shell mkdir -p $(MODULE_FOLDER))

TARGET += fetch_and_build_yoga
TARGET += copy_headers

##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Linux) #LINUX
	TARGET += copy_static_lib
else ifeq ($(UNAME_S), Darwin) #APPLE
	TARGET += copy_static_lib
endif

TARGET += clean


##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

all: $(TARGET)
	@echo build complete

fetch_and_build_yoga:
	[ -d yoga_git ] || git clone --depth 1 https://github.com/facebook/yoga yoga_git
	( cd yoga_git ; mkdir build ; cd build ; cmake .. ; make)

copy_static_lib:
	$(CP) yoga_git/build/libyogacore.a $(MODULE_FOLDER)/

copy_headers:
	$(CP) yoga_git/yoga/*.h $(MODULE_FOLDER)/

clean:
	$(RM) -Rf yoga_git
