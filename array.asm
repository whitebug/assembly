section	.bss
array	resb 256	; char array 256 bytes

section	.text

	mov ecx, 256	; put number of elements to the counter
	mov edi, array	; put the array's address to EDI - destination index
	mov al, '@'	; the symbol to fill the array to al
again:	mov [edi], al	; put the symbol to array element
	inc edi		; select the next element of the array
	dec ecx		; decrease the counter
	jnz again	; if there is not null, fire the loop again
	
		
