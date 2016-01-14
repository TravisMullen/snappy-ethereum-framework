# Pssibled parameters:
#
# WITH_DBUS [ 1 | 0 ]
# ARCH      [ x86 | armhf ]
#    -x86 is basically the local machine
#    -armhf will only work for cross compiling to arm with the ubuntu cross compile toolchain
#
OUT_NAME=listener

ARCH=x86
CC=gcc
INCLUDES=
LIBRARIES=
CCFLAGS=-Wall -Wextra

# Set the compiler
ifeq ($(ARCH),armhf)
	CC=arm-linux-gnueabihf-gcc
endif

# Set our includes
ifeq ($(WITH_DBUS),1)
	ifeq ($(ARCH),x86)
		INCLUDES+=$(shell pkg-config dbus-1 --cflags)
	else ifeq ($(ARCH),armhf)
		INCLUDES+=-I/usr/include/dbus-1.0  -I/usr/lib/arm-linux-gnueabihf/dbus-1.0/include
	else
		$(error Unrecognized value for ARCH variable)
	endif
endif

# Set Libraries
ifeq ($(WITH_DBUS),1)
	LIBRARIES+=-ldbus-1
endif

SOURCES=main.c
ifeq ($(WITH_DBUS),1)
	SOURCES+=dbus.c
endif

listener: $(SOURCES)
	$(CC) $(SOURCES) -o $(OUT_NAME)  $(INCLUDES) $(CCFLAGS) $(LIBRARIES)


.PHONY: clean

clean:
	rm -f listener
