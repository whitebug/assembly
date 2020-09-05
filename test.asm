	xor ebx, ebx		; zero ebx
	xor ecx, ecx		; zero ecx
lp:	mov bl, [exi+ecx]	; another byte from the string
	cmp bl, 0		; is the string over?
	je lpquit		; end the loop if so
