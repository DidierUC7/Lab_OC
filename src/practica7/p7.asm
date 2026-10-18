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
    cadenaNumero resb lencadena
    numeroAtoi resb 4
    numeroItoa resb 4
    cadenaNumeroItoa resb lencadena
    cantNumero resb 4
    signo resb 4
    bandera0 resb 1

section .text
    global _start         ; referencia para inicio de programa
    
_start:   

    mov edx, msg1
    call puts
    mov edi, cadena
    mov esi, cadenaNumero
    mov cx, lencadena-1

    call capturaCadena

    mov byte[cantNumero], 0
    mov edi, cadena
    mov esi, cadenaNumero
    call atoi

    mov edx, nline
    call puts

    mov edx, cadenaNumero
    call puts

    mov edx, nline
    call puts

    add byte[cantNumero], '0'
    mov al, byte[cantNumero]
    call putchar

    mov edx, nline
    call puts

    mov edx, numeroAtoi
    call puts

    mov edx, dword[numeroAtoi]
    mov dword[numeroItoa], edx 


    mov edx, nline
    call puts

    mov byte[bandera0], 1
    call itoa
    mov edx, cadenaNumeroItoa
    call puts


    
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

            cmp bx, 0
            jnz .finCicloCapturaCadena
            loop .cicloCapturaCadena

        .finCicloCapturaCadena:
            mov byte[edi], 0
            pop bx
            ret



    ; --- capturaCaracter ---
    capturaCaracter:

        push ax
        
        call getch
        cmp al, bskey
        jnz .noEsBackSpace
        call borrar
        jmp .finCapturaCaracter
        .noEsBackSpace:
            cmp al, 10
            jnz .noEsln
            mov bx, 1
            jmp .finCapturaCaracter
            cmp al, 0

        .noEsln:
            mov byte[edi], al
            add edi, 1
            call putchar
        
        .finCapturaCaracter:
            pop ax
            ret

    ; --- borrar ---
    borrar:
        push ax
        inc cx
        cmp edi, cadena
        jle .finalBorrar
        sub edi, 1
        inc cx
        mov al, 8
        call putchar
        mov al, " "
        call putchar
        mov al, 8
        call putchar
        .finalBorrar:
            pop ax
            ret


    ; --- atoi ---
    atoi:
        mov dword[signo], 1
        .cicloInicioAtoi:
            cmp byte[edi], 0
            jz .finAtoi
            call verificarEsNumero
            cmp bx, 1
            jz .signo
            inc edi
            jmp .cicloInicioAtoi
            .signo cmp byte[edi-1], '-'
                jnz .cicloNumero
                mov dword[signo], -1
            .cicloNumero:
                call verificarEsNumero
                cmp bx, 1
                jnz .conversionAtoi
                mov byte[esi], al
                inc edi
                inc esi
                inc byte[cantNumero]
                jmp .cicloNumero
                
            .conversionAtoi:
                mov byte[esi+1], 0
                mov esi, cadenaNumero
                mov edi, numeroAtoi
                mov dword[edi], 0
                mov ecx, 0
                mov cl, byte[cantNumero]
                .cicloConversionAtoi:
                    mov ebx, 10
                    mov edx, ecx
                    dec edx
                    call potencia
                    mov ebx, eax
                    mov eax, 0
                    mov al, byte[esi]
                    sub eax, '0'
                    mul ebx
                    add dword[edi], eax
                    inc esi
                    loop .cicloConversionAtoi
        
            .finAtoi:
                mov eax, dword[edi]
                imul dword[signo]
                mov dword[edi], eax
            ret
        
        
    verificarEsNumero:
        cmp byte[edi], '0'
        jl .noEsNumero
        cmp byte[edi], '9'
        jg .noEsNumero
        mov ebx, 1
        mov al, byte[edi]
        jmp .finVerificarEsNumero
        .noEsNumero:
            mov ebx, 0
        .finVerificarEsNumero ret


    ; --- potencia ---
    potencia:
        push ecx
        push edx
        mov eax, 1              ; base^0 = 1
        mov ecx, edx            ; contador propio
        .cicloPotencia:
            test ecx, ecx
            jz .finPotencia
            mul ebx             ; edx:eax = eax * ebx (edx se pisa, pero ya está guardado)
            dec ecx
            jmp .cicloPotencia
        .finPotencia:
            pop edx
            pop ecx
            ret

    
    ; --- itoa ---
    itoa:
        mov ebx, dword[numeroItoa]
        mov edi, cadenaNumeroItoa
        cmp ebx, 0
        jge .NoEsNeg
        mov byte[edi], '-'
        inc edi
        neg ebx
        .NoEsNeg mov ax, bx
        shr ebx, 16
        mov dx, bx
        mov ebx, 10000
        .cicloItoa:
            div bx
            cmp byte[bandera0], 0
            jz .esPermitidoXd
            cmp al, 0
            jz .es0malo
            .esPermitidoXd mov byte[edi], al
            add byte[edi], '0'
            inc edi
            mov byte[bandera0], 0
            .es0malo mov ax, 0
            push dx
            mov dx, 0
            mov ax, bx
            mov bx, 10
            div bx
            mov bx, ax
            pop ax
            cmp bx, 0
            jnz .cicloItoa
        
        ret