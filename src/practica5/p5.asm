%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena

    ;Inciso a
    mov byte[msg], 'Z'
    call puts

    ;Inciso b
    mov edi, msg
    add edi, 23
    mov byte[edi], 'X'
    call puts

    

    ;Inciso c
    mov edi, msg
    mov byte[edi+26], '@'
    call puts

    ;Inciso d
    mov edi, msg
    mov esi, 25
    mov byte[edi+esi], 'Z'
    call puts

    ;Inciso e
    mov edi, msg
    mov esi, 10
    mov byte[edi+esi+5], 'P'
    call puts

    ;Inciso f
    mov edi, msg-1
    mov esi, 5
    mov byte[edi+esi*4], '%'
    call puts

    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa,0xa, 0
    salto db 0xa