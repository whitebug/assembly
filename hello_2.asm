global _start

section	.data
msg	db "Hello world", 10
msg_len equ $-msg

section .text
_start: mov	eax, 4		; write
	mov	ebx, 1		; standard output
	mov	ecx, msg	; add string's address
	mov	edx, msg_len	; add string's length
	int	80h		; program interruption
	mov	eax, 1		; _exit
	mov	ebx, 0		; success code
	int	80h		; program interrutpion
