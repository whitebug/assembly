%include "stud_io.inc"
global _start

section	.text
_start:
string	db 'Hello'		; string
	mov eax, 4		; syscall write
	mov ebx, 1		; standard output
	mov ecx, [string]	; add string's address
	mov edx, 4		; provide length
	int 80h
	FINISH	
