%include "stud_io.inc"
global _start

section .text
_start: mov	eax, 5
	and	eax, 3
	PRINT	eax
