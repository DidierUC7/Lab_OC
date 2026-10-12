%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 20
    ln equ 0x0A
    nulo db 0
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    
section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:   

    ; --- IMPRIMIR CADENA  ---
    mov edx, msg1        
    call puts

    mov ecx, lencadena
        .cicloCaptura call captura    

        loop .cicloCaptura


    jmp .fin_programa  
    
    
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

   
    captura:
            push ax
            call getch
            cmp al, ln
            jne .finEsln
            mov ebx, 1


            cmp al, bskey
            jne .sig
            call borrar
    .sig:   
            call putchar
            pop ax
            ret

    borrar:
        push ax 
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        ret 