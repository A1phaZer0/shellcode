#
# gcc -nostdlib -o list_dir-x86_64 list_dir-x86_64.s
# for i in $(objdump -d -M intel list_dir-x86_64 | grep "^ " | cut -f2); do
#     echo -n "\x$i"
# done
#
# Change line 17 and line 71 simultaneously 
#
.intel_syntax noprefix
.global _start

_start:
	jmp REL_JMP
REL_CALL:
	pop rdi
        xor rdx, rdx
	mov byte ptr [rdi + 1], dl # NULL-terminated dir name
	push 04
	pop rdx
	xor rsi, rsi
	push 0x2
	pop rax  
	syscall      # syscall open

	mov rsi, rdi # dirent
	mov rdi, rax # fd
	xor rdx, rdx
	mov dx, 0x1010
	push 78
	pop rax
	syscall      # syscall getdents

PRINT_LOOP:
	xor rax, rax
	mov al, 0xaa
	xor al, 0xa0 # get '\n'

	xor rdx, rdx
	mov dx, word ptr [rsi + 16] # len of dirent
	add rdx, rsi
	mov byte ptr [rdx - 1], al  # overwrite d_type append '\n'

	xor rdx, rdx
	mov dx, word ptr [rsi + 16] 
	sub rdx, 18  # len of string
	push rsi     # save rsi
	lea rsi, [rsi + 18]
	push 1
	pop rdi      # fd
	push 1
	pop rax
	syscall      # syscall write
	
	pop rsi      # recover rsi
	xor rdx, rdx
	mov dx, word ptr [rsi + 16]

	mov rcx, 0x7fffffffffffffff  # no next entry
	cmp qword ptr [rsi + 8], rcx # d_off of linux_dirent
	lea rsi, [rsi + rdx]         # next dirent

	jnz PRINT_LOOP
EXIT:
	xor rdi, rdi # error code 
	push 60
	pop rax
	syscall      # exit normally

REL_JMP:
	call REL_CALL
	.ascii "." # put linux_dirent here too.
