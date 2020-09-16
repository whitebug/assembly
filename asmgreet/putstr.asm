;; asmgreet/putstr.asm ;;
%include "kernel.inc"		; we need kernel macro
global putstr			; make putstr global
extern strlen			; the unit would use strlen

section		.text
; procedure putstr
; [ebp+8] = address of the string
putstr: push ebp		; save ebp in stack
	mov ebp, esp		; copy stack top to ebp
	push dword [ebp+8]	; get the string
	call strlen		; call procedure
	add esp, 4		; the result in eax, remove parameter from
				; the stack
	kernel 4, 1, [ebp+8], eax	; write string
	mov esp, ebp		; return stack point 
	pop ebp			; return ebp value
	ret			; return control to the program
	
