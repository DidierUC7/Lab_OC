extern canonical_off
extern canonical_on

section .data
    bskey equ 0x7F
    msg1 db ln,'Captura:',0
    nline db 10,0
    ln equ 10
    lencadena equ 255


section .bss
   cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    
_start:  
    
    ; --- IMPRIMIR CADENA  ---
    mov edx, msg1        
    call miPuts

    mov edi, cadena
    mov ecx, lencadena-1
    call capturaCadena
    mov edx, nline
    call miPuts


    mov edx, cadena
    call miPuts
    mov edx, nline
    call miPuts

    mov edi, cadena
    call mayusculas
    mov edx, cadena
    call miPuts
    mov edx, nline
    call miPuts

    mov edi, cadena
    call minusculas
    mov edx, cadena
    call miPuts
    mov edx, nline
    call miPuts

    
    ; --- FIN DE PROGRAMA ---
    .fin_programa:  
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa


    miPutchar:
        push ebx
        push ecx
        push edx
        push eax
        mov eax, 4
        mov ebx, 1
        mov ecx, esp
        mov edx, 1
        int 0x80
        pop eax
        pop edx
        pop ecx
        pop ebx
        ret

    miPuts:
        push edx
        .cicloPuts:
            cmp byte[edx], 0
            jz .esCaracterNulo
            push edx
            mov al, byte[edx]
            call miPutchar
            pop edx
            inc edx
            jmp .cicloPuts

        .esCaracterNulo:
            pop edx
            ret

    getch:
        call canonical_off
        push eax
        mov eax, 3 
        mov ebx, 0
        mov ecx, esp
        mov edx, 1 
        int 0x80 
        pop eax
        call canonical_on
        ret

    miGetche:
        call getch
        call miPutchar
        ret



    capturaCadena:
        push ebx
        mov ebx, 0
        .cicloCaptura:
            call captura    
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
            call miPutchar
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
        call miPutchar
        mov al,' '
        call miPutchar
        mov al,0x8
        call miPutchar   
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
