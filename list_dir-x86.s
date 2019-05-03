# 
# gcc -nostdlib -m32 -o list_dir-x86 list_dir-x86.s
# for i in $(objdump -d -M intel list_dir-x86 | grep "^ " | cut -f2); do
#     echo -n "\x$i"
# done
#
# Change line 17 and line 70 simultaneously 
#
.intel_syntax noprefix
.global _start

_start:
	jmp REL_JMP
REL_CALL:
	pop ebx
        xor edx, edx
	mov byte ptr [ebx + 1], dl # NUL to terminated string
	push 04
	pop edx
	xor ecx, ecx
	push 5
	pop eax  
	int 0x80      # syscall open

	mov ecx, ebx # dirent
	mov esi, ecx
	mov ebx, eax # fd
	xor edx, edx
	mov dx, 0x1010
	push 141
	pop eax
	int 0x80     # syscall getdents

PRINT_LOOP:
	xor eax, eax
	mov al, 0xaa
	xor al, 0xa0 # get '\n'

	xor edx, edx
	mov dx, word ptr [esi + 8] # len of dirent
	add edx, esi
	mov byte ptr [edx - 1], al  # overwrite d_type append '\n'

	xor edx, edx
	mov dx, word ptr [esi + 8] 
	sub edx, 10  # len of string
	lea ecx, [esi + 10]
	push 1
	pop ebx      # fd
	push 4
	pop eax
	int 0x80      # syscall write
	
	xor edx, edx
	mov dx, word ptr [esi + 8]

	mov ecx, 0x7fffffff  # no next entry
	cmp dword ptr [esi + 4], ecx # d_off of linux_dirent
	lea esi, [esi + edx]         # next dirent

	jnz PRINT_LOOP
EXIT:
	xor ebx, ebx # error code 
	push 1
	pop eax
	int 0x80      # exit normally

REL_JMP:
	call REL_CALL
	.ascii "." # put linux_dirent here too.
