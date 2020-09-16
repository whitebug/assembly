;; asmgreet/greet.asm ;;
global _start			; head module
extern putstr
extern getstr
extern quit

section .data			; add messages
nmq	db	'Hi, what is your name?', 10, 0
pmy	db	'Pleased to meed you, dear ', 0
exc	db	'!', 10, 0

section .bss			; book memory for buffer
buf	resb	512
buflen	equ	$-buf

section .text
_start:	push dword nmq		; get first message
	call putstr		; call putstr with the message as param
	add esp, 4		; remove message from stack
	push dword buflen	; get buffer length
	push dword buf		; get buffer address
	call getstr		; call getstr with buf and buflen as params
	add esp, 8		; remove 2 values from stack
	push dword pmy		; get pmy
	call putstr		; call putstr with pmy
	add esp, 4		; clear stack
	push dword buf		; get buf address
	call putstr		; call putstr with buf as param
	add esp, 4		; remove buf from stack
	push dword exc		; get exc
	call putstr		; call putstr with ecx as param
	add esp, 4		; clear stack
	call quit		; quit
