;; asmgreet/strlen.asm ;;
global strlen

section .text
; procedure strlen
; [ebp+8 == address of the string
strlen: push ebp		; save ebp in stack
	mov ebp, esp		; copy stack point to ebp
	xor eax, eax		; eax = 0
	mov ecx, [ebp+8]	; copy parameter 1 to ecx
.lp:	cmp byte [eax+ecx], 0	; repeat until we met zero
	jz .quit		; if we have met zero, go to quit
	inc eax			; increase counter
	jmp short .lp		; loop
.quit:	pop ebp			; return ebp value
	ret			; give control to the main program
