OPTS := -DPHYSFS_ARCHIVE_ISO9660=OFF
OPTS += -DPHYSFS_ARCHIVE_VDF=OFF
OPTS += -DPHYSFS_ARCHIVE_SLB=OFF
OPTS += -DPHYSFS_ARCHIVE_QPAK=OFF
OPTS += -DPHYSFS_ARCHIVE_MVL=OFF
OPTS += -DPHYSFS_ARCHIVE_HOG=OFF
OPTS += -DPHYSFS_ARCHIVE_WAD=OFF
OPTS += -DPHYSFS_ARCHIVE_GRP=OFF

OPTS += -DPHYSFS_BUILD_SHARED=OFF
OPTS += -DPHYSFS_BUILD_TEST=OFF

CFLAGS := -I physfs_hg/src
CFLAGS += -I /usr/local/opt/sdl2/include/SDL2
CFLAGS += `sdl2-config --cflags`


all: physfs_hg/build/libphysfs.a physfsrwops.o

physfs_hg/build/libphysfs.a:
	[ -d physfs_hg ] || hg clone https://hg.icculus.org/icculus/physfs physfs_hg
	(cd physfs_hg ; mkdir build ; cd build ; cmake $(OPTS) .. ; make)

physfsrwops.o: physfs_hg/extras/physfsrwops.c
	$(CC) $(CFLAGS) -c -o physfs_hg/build/$@ $<

clean:
	rm -rf physfs_hg
