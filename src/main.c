#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main (int argc, char **argv)
{
    if (argc != 2) {
        goto fail_wrong_args;
    }

    int sock;
    struct sockaddr_un server;
    char buf[1024];

    sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock < 0) {
         perror("opening stream socket");
         exit(1);
    }
    server.sun_family = AF_UNIX;
    strcpy(server.sun_path, argv[1]);

    if (connect(sock, (struct sockaddr *) &server, sizeof(struct sockaddr_un)) < 0) {
        close(sock);
        perror("connecting stream socket");
        exit(1);
    }

    static const char blocknum[] = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":83}";
    if (write(sock, blocknum, sizeof(blocknum)) < 0) {
        perror("writing on stream socket");
        close(sock);
        exit(1);
    }
    if (read(sock, buf, 1024) < 0) {
        perror("reading from stream socket");
        close(sock);
        exit(1);
    }

    printf("Result: %s\n", buf);
    close(sock);
    return 0;

fail_wrong_args:
    printf("Usage: %s blocknumber", argv[0]);
    exit(1);
}
