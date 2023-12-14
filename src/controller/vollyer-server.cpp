#include <iostream>
#include <string.h>
#include <cstring>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <errno.h>
#define PORT 9999
#define BUFFER_SIZE 9999


int main(int argc, char const* argv[]){
    std::cout << "terminate server starting" << std::endl;

    int server_fd;
    int new_socket;
    ssize_t valread;
    struct sockaddr_in address;
    int opt = 1;
    socklen_t addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = { 0 };
    //char* resp_crash = "{ type: DISCONNECT, namespace: \"/\" }";
    char* resp_crash = "crash";

    // Creating socket file descriptor
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if(server_fd < 0) {
        printf("socket descriptor creation failed errno: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }

    const int enable = 1;
    if(setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &enable, sizeof(int))) {
        printf("setsockopt failed errno: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Forcefully attaching socket to the port 9999
    if(bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
        printf("bind failed errno: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    if(listen(server_fd, 3) < 0) {
        printf("listen failed errno: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }

    while(true){
        printf("waiting for connection on 9999...\n");
        new_socket = accept(server_fd, (struct sockaddr*)&address, &addrlen);
        if(new_socket < 0) {
            printf("accept failed errno: %s\n", strerror(errno));
            exit(EXIT_FAILURE);
        }

        valread = read(new_socket, buffer, BUFFER_SIZE - 1);
        printf("%s\n", buffer);
        send(new_socket, resp_crash, strlen(resp_crash), 0);
        printf("crash sent\n");
        std::memset( buffer, 0, sizeof(buffer));
        system("/home/ubuntu/Projects/Open-Shooter/src/display/terminate.sh"); // terminate firefox because of crash request


        // closing the connected socket
        close(new_socket);
    }

    // closing the listening socket
    close(server_fd);


    return 0;
}
