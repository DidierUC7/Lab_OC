%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 255
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

    mov edi, cadena
    mov ecx, lencadena-1
    call capturaCadena
    mov edx, nline
    call puts

    mov edx, cadena
    call puts
    mov edx, nline
    call puts

    mov edi, cadena
    call mayusculas
    mov edx, cadena
    call puts
    mov edx, nline
    call puts

    mov edi, cadena
    call minusculas
    mov edx, cadena
    call puts
    mov edx, nline
    call puts

    jmp .fin_programa  
    
    
    
    ; --- FIN DE PROGRAMA ---
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa


    capturaCadena:
        push ebx
        mov ebx, 0
        .cicloCaptura call captura    
            cmp ebx, 1
            jne .ciclo
            mov ecx, 1
            mov byte [edi-1], 0
        .ciclo: 
            loop .cicloCaptura
            mov byte [edi], 0
            pop ebx
            ret

   
    captura:
            push ax
            call getch
            cmp al, ln
            jne .finEsln
            mov ebx, 1
    .finEsln:        
            cmp al, bskey
            jne .sig
            call borrar
            jmp .finBorrar
    .sig:   
            call putchar
            mov byte[edi], al
            add edi, 1
    .finBorrar:
            pop ax
            ret

    borrar:
        push ax
        inc ecx
        cmp edi, cadena
        jle .esCadenaOriginal
        sub edi, 1
        mov al,0x8
        call putchar
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        .esCadenaOriginal: 
            pop ax
            ret 

    mayusculas:
        
        .cicloMayus:
            cmp byte[edi], 0
            je .finMayus 
            cmp byte[edi], 97
            jl .noEsMinus
            cmp byte[edi], 122
            jg .noEsMinus
            add byte[edi], -32

        .noEsMinus:
            add edi, 1
            jmp .cicloMayus

        .finMayus:
            ret

    minusculas:
        
        .cicloMinus:
            cmp byte[edi], 0
            je .finMinus 
            cmp byte[edi], 65
            jl .noEsMayus
            cmp byte[edi], 90
            jg .noEsMayus
            add byte[edi], 32

        .noEsMayus:
            add edi, 1
            jmp .cicloMinus

        .finMinus:
            ret
