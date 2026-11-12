%include "../../lib/pc_io.inc"

%macro PROTOENTRADA 0
    push ebp
    mov ebp, esp
%endmacro

%macro PROTOSALIDA 0
    mov esp, ebp
    pop ebp
%endmacro

%macro WHILE 3
    push ebx
    push ecx
    push edx
.cicloWhile:
    mov ecx, %1
    mov edx, %2
    cmp ecx, edx
    jge .finWhile
    call %3   ;cuerpo del ciclo
    inc %1
    jmp .cicloWhile
.finWhile:
    pop edx
    pop ecx
    pop ebx
%endmacro


section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa,0xa, 0
    salto db 0xa

section .bss
    

section .text
    global _minimo
    global _maximo
    global _sumatoria
    

    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

    _minimo:
        PROTOENTRADA
        sub esp, 4
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, dword[ebp+8]  ;arreglo
        mov edx, dword[ebx]
        mov dword[ebp-4], edx  ;min = arreglo[0]
        mov esi, 0 ;i = 0

        WHILE esi, dword[ebp+12], .cuerpoMin

        pop esi
        pop edx
        pop ecx
        pop ebx
        mov eax, dword[ebp-4]  ;return min
        PROTOSALIDA
        ret ;ret al main

    .cuerpoMin:
        mov edx, dword[ebx+esi*4]
        cmp edx, dword[ebp-4]
        jge .finMin
        mov dword[ebp-4], edx  ;min = arreglo[i]
    .finMin:
        ret ;ret al WHILE


    _maximo:
        PROTOENTRADA
        sub esp, 4
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, dword[ebp+8] ;arreglo
        mov edx, dword[ebx]
        mov dword[ebp-4], edx  ;min = arreglo[0]
        mov esi, 0  ;i = 0

        WHILE esi, dword[ebp+12], .cuerpoMaximo  ;while (i < len)

        pop esi
        pop edx
        pop ecx
        pop ebx
        mov eax, dword[ebp-4]  ;return min
        PROTOSALIDA
        ret ;es el ret dentro del WHILE

    .cuerpoMaximo:
        mov edx, dword[ebx+esi*4]
        cmp edx, dword[ebp-4]
        jle .finMax
        mov dword[ebp-4], edx  ;min = arreglo[i]
    .finMax:
        ret ;ret al while


    _sumatoria:
        PROTOENTRADA
        sub esp, 4
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, dword[ebp+8]  ;arreglo
        mov dword[ebp-4], 0   ;suma = 0
        mov esi, 0  ;i = 0

        WHILE esi, dword[ebp+12], .cuerpoSumatoria

        pop esi
        pop edx
        pop ecx
        pop ebx
        mov eax, dword[ebp-4] ;return suma
        PROTOSALIDA
        ret

    .cuerpoSumatoria:
        mov edx, dword[ebx+esi*4]
        add dword[ebp-4], edx  ;suma += arreglo[i]
        ret