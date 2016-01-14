OUT_NAME=listener

listener:
	gcc main.c -o $(OUT_NAME)  -I/usr/include/dbus-1.0 -I/usr/lib/x86_64-linux-gnu/dbus-1.0/include -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include/ -ldbus-1 -ldbus-glib-1 -Wall -Wextra -lglib-2.0 -lgio-2.0 -lgobject-2.0 -lgthread-2.0

listener-arm:
	arm-linux-gnueabihf-gcc main.c -o $(OUT_NAME) -I/usr/include/dbus-1.0  -I/usr/lib/arm-linux-gnueabihf/dbus-1.0/include -I/usr/include/glib-2.0 -I/usr/lib/arm-linux-gnueabihf/glib-2.0/include/ -ldbus-1 -ldbus-glib-1 -Wall -Wextra -lglib-2.0 -lgio-2.0 -lgobject-2.0 -lgthread-2.0


.PHONY: clean

clean:
	rm -f listener
