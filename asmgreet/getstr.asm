;; asmgreet/getstr.asm ;;
%include "kernel.inc"		; include kernel macro
global getstr			; global name for the procedure
section .text			; command section
getstr:				; arg1 - buffer address, arg2 - buffer length
	push ebp		; save ebp
	mov ebp, esp		; get stack top to ebp
	xor ecx, ecx		; ecx=0. ECX is reading counter
	mov edx, [ebp+8]	; EDX is current address in buffer
.again:	inc ecx			; increase counter
	cmp ecx, [ebp+12]	; compare current number of read symbols with
				; the buffer length
	jae .quit		; if more or equal to buffer - quit
	push ecx		; save ecx
	push edx		; save edx
	kernel 3, 0, edx, 1	; read from standard input to buffer 1 symbol
	pop edx			; restore edx
	pop ecx			; restore ecx
	cmp eax, 1		; check if result is 1 (1 byte)
	jne .quit		; if no - quit
	mov al, [edx]		; place to al the read symbol code
	cmp al, 10		; if the symbol is code 10
	je .quit		; if yes - quit
	inc edx			; increase butter address
	jmp .again		; loop
.quit:	mov [edx], byte 0	; write zero to the end of the string
	mov esp, ebp		; restore stack point
	pop ebp			; restore ebp
	ret			; return control to the main program
