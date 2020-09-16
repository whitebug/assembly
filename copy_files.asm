%macro		kernel 1-*	; kernel macro with 1 to many parameters
%ifdef OS_FREEBSD
 %rep %0			; repeat all parameters
  %rotate -1			; make last parameter %1
		push dword %1	; save parameter %1 in stack
 %endrep			; it seems that we saving all parameters
				; in stack
		mov eax, [esp]	; save stack point in eax
		int 80h		; make syscall
		jnc %%ok	; if CF is 0 (no error) go to ok label
		mov ecx, eax	; copy to ecx stack point
		mov eax, -1	; fill eax with error message (syscall was
				; unsuccessfull
		jmp short %%q	; go to quit
  %%ok:		xor ecx, ecx	; ecx=0
  %%q:		add esp, (%0-1)*4	; remove from stack the number of
				; parameters excluding the procedure name
 %elifdef OS_LINUX
  %if %0 > 1			; check if there are more than 1 parameters
				; i.e. more than the macro name
		push ebx	; save ebx in stack
   %if %0 > 4			; check if there are more than 4 parameters
		push esi	; save esi in stack
		push edi	; save edi in stack, since we need more 
				; parameters in registers
   %endif
  %endif
  %rep %0			; loop through all the parameters
   %rotate -1			; make last parameter %1
		push dword %1	; save first parameter to stack
  %endrep
		pop eax		; add parameter to eax from stack
  %if %0 > 1			; if there are more than 1 parameters
		pop ebx		; add parameter to ebx from stack
   %if %0 > 2
		pop ecx		; add parameter to ecx from stack
    %if %0 > 3
		pop edx		; add parameter to edx from stack 
     %if %0 > 4
		pop esi		; add parameter to esi from stack
      %if %0 > 5
		pop edi		; add parameter to edi from stack
       %if %0 > 6		; there are no more available registers
        %error "Can't do Linux syscall with 6+ params"
       %endif
      %endif
     %endif
    %endif
   %endif
		int 80h		; make syscall
		mov ecx, eax	; copy result of the syscall to ecx
		and ecx, 0fffff000h	; check if there is an error
		cmp ecx, 0fffff000h	; check if result is equal to error
					; code
		jne %%ok		; if result is not error go to ok
		mov ecx, eax		; copy to ecx original value of 
					; the result of syscall
		neg ecx			; make negative result positive
		mov eax, -1		; mark the result as error
		jmp short %%q		; go to quit
 %%ok:		xor ecx, ecx		; ecx = 0
 %%q:					; quit label
 %if %0 > 1
  %if %0 > 4
		pop edi			; return original edi value
		pop esi			; return original esi value
  %endif
		pop ebx			; return original ebx value
 %endif
%else
%error Please define eigher OS_LINUX or OS_FREEBSD
%endif
%endmacro
		
%ifdef OS_FREEBSD
openwr_flags equ 601h
%else					; Linux
openwr_flags equ 241h
%endif


