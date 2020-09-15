;; cmdl.asm ;;
global	_start

section	.text

nlstr	db	10, 0
				

;; the main goal of strlen is to find out the length of the string

strlen:				; arg1 == address of the string
	push ebp		; save ebp. We would use ebp to store stack
				; point to restor it at the end 
	mov ebp, esp		; copy stack point to ebp
	xor eax, eax		; using eax as a counter. eax = 0
	mov ecx, [ebp+8]	; arg1. esp+8 is the string address
.lp:	cmp byte [eax+ecx], 0	; check if current symbol is zero, which
				; means that the string is over
	jz .quit		; string is over, exit the procedure
	inc eax			; if current symbol is not zero, take 
				; the next symbol
	jmp short .lp		; cycle
.quit:	pop ebp			; return ebp to original value
	ret			; return control to the main program
				; since eax is our counter, the result 
				; would be in eax

;; print_str would get one parameter which is string address and write it
;; in standard output. We would save string address in EBX

print_str:			; arg1 == address of the string
	push ebp		; save ebp in stack
	mov ebp, esp		; copy stack point value to ebp
	push ebx		; save stack point in stack
	mov ebx, [ebp+8]	; copy to ebx the string address
	push ebx		; make a parameter for strlen (string addr)
	call strlen		; get string length
	add esp, 4		; clean parameter for strlen in stack
				; the result of strlen work in eax
%ifdef OS_FREEBSD
	push eax		; length
	push ebx		; arg1
	push dword 1		; stdout
	mov eax, 4		; write
	push eax		; extra dword
	int 80h			; syscall
	add esp, 16		; clean 4 entries from stack

%elifdef OS_LINUX
	mov edx, eax		; string length
	mov ecx, ebx		; string address
	mov ebx, 1		; standard output code (1)
	mov eax, 4		; write syscall code (4)
	int 80h			; syscall
%else
%error please define eigher OS_FREEBSD or OS_LINUX
%endif
	pop ebx			; return ebx value
	mov esp, ebp		; return stackpoint value
	pop ebp			; return ebp value
	ret			; return control to the program

_start:
	mov ebx, [esp]		; copy the number of parameters to ebx. ECX
				; is more natural for a counter role, but
				; ECX would be spoiled. We would start from
				; the last parameter
	mov esi, esp		; copy current value of stack point to esi
	add esi, 4		; parameters that starts with program name
again:	push dword [esi]	; argv[i]. Save parameter in stack
	call print_str		; print parameter
	add esp, 4		; clean stack from the parameter
	push dword nlstr	; add 10 symbol to stack
	call print_str		; print symbol 10 and 0
	add esp, 4		; clean 10th symbol from the stack
	add esi, 4		; choose the next parameter address
	dec ebx			; decrease parameter counter
	jnz again		; if we have more parameters do it again
%ifdef OS_FREEBSD
	push dword 0		; success
	mov eax, 1		; _exit
	push eax		; extra dword
	int 80h			; syscall
%else
	mov ebx, 0		; success
	mov eax, 1		; _exit
	int 80h			; syscall
%endif
	
	
