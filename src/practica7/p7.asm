%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 32
    ln equ 0x0A
    nulo db 0
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Cadena: ', 0
    
section .bss
    cadena resb lencadena
    numero resb 8

section .text
    global _start         ; referencia para inicio de programa
    
_start:   

    mov edi, cadena
    mov cx, lencadena

    call capturaCadena



    
    
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

    
    ; --- capturaNumero ---
    capturaNumero:
        

    ; --- capturaCadena ---
    capturaCadena:

        push bx
        mov bx, 0

        .cicloCapturaCadena:
            call capturaCaracter
            add edi, 1
            sub cx, 1

            cmp bx, 0
            jz .cicloCapturaCadena
        
        pop bx
        ret



    ; --- capturaCaracter ---
    capturaCaracter:

        push ax
        
        call getch
        cmp al, 10
        jnz .noEsln
        mov bx, 1
        jmp .finCapturaCaracter
        .noEsln:
            mov byte[edi], al
            call putchar
        
        .finCapturaCaracter:
            pop ax
            ret