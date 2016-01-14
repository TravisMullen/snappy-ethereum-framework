#include <dbus/dbus.h>
#include <stdio.h>

DBusConnection *sl_dbus_new(const char *name)
{
    DBusConnection *connection;
    DBusError error;

    dbus_error_init(&error);
    connection = dbus_bus_get(DBUS_BUS_SESSION, &error);
    if (dbus_error_is_set(&error)) {
        printf("Error connecting to the daemon bus: %s", error.message);
        dbus_error_free(&error);
        return NULL;
    }

    dbus_bool_t ret = dbus_bus_name_has_owner(connection, name, &error);
    if (dbus_error_is_set(&error)) {
        dbus_error_free(&error);
        printf("DBus Error: %s\n", error.message);
        return NULL;
    }

    if (ret == FALSE) {
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
            return NULL;
        }

        if (request_name_reply == DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER) {
            return connection;
        } else {
            printf("Failed to reserve bus name %s\n", name);
            return NULL;
        }

    } else {
        // either our app is already running or someone stole the name
        printf("bus name %s is already reserved\n", name);
    }

    return NULL;
}
