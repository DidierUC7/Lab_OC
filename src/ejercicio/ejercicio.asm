%include "../../lib/pc_io.inc"

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa,0xa, 0
    salto db 0xa

section .bss
    

section .text
    global _start
    
_start:   


    esPrimo:
        



    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa