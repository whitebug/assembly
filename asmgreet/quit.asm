;; asmgreet/quit.asm ;;
%include "kernel.inc"
global quit
section .text
quit: kernel 1, 0	; quit with success code
