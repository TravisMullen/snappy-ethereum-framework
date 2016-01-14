// examples are from here: http://linoxide.com/how-tos/d-bus-ipc-mechanism-linux/
#include <glib.h>
#include <stdio.h>

#include <dbus/dbus.h>

int main()
{
    DBusConnection *connection;
    DBusError error;

    char *name = "ethereum.listener";
    dbus_error_init(&error);
    connection = dbus_bus_get(DBUS_BUS_SESSION, &error);

    if (dbus_error_is_set(&error)) {
        printf("Error connecting to the daemon bus: %s", error.message);
        dbus_error_free(&error);
        return 1;
    }

    dbus_bool_t ret = dbus_bus_name_has_owner(connection, name, &error);
    if (dbus_error_is_set(&error)) {
        dbus_error_free(&error);
        printf("DBus Error: %s\n", error.message);
        return 1;
    }

    if (ret == FALSE) {
        printf("Bus name %s doesn't have an owner, reserving it...\n", name);

        int request_name_reply =
            dbus_bus_request_name(
                connection,
                name,
                DBUS_NAME_FLAG_DO_NOT_QUEUE,
                &error
            );

        if (dbus_error_is_set(&error)) {
            dbus_error_free(&error);
            printf("Error requesting a bus name: %s\n", error.message);
            return 1;
        }

        if ( request_name_reply == DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER ) {
            printf("Bus name %s Successfully reserved!\n",name);
            return 0;
        } else {
            printf("Failed to reserve name %s\n",name);
            return 1;
        }

    } else {
        // either our app is already running or someone stole the name
        printf("%s is already reserved\n", name);
        return 1;
    }

    return 0;

}
