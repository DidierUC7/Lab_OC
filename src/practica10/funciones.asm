%macro PROTOENTRADA 0
	push ebp
	mov ebp,esp
%endmacro

%macro PROTOSALIDA 0
	mov esp,ebp
	pop ebp
%endmacro


section	.text
    global _setbit   
    global _getbit  
	
    _setbit:
        PROTOENTRADA
		pusha

		mov ebx, dword[ebp+8] ;guardo el puntero a las banderas
		mov cl, byte[ebp+12] ;guardo la posicion del bit
		mov edx, 1

		shl edx, cl
		or byte[ebx], dl

		popa
		PROTOSALIDA
		ret

    _getbit:
        PROTOENTRADA
		sub esp, 4
		pusha

		mov bl, byte[ebp+8] ;guardo las banderas
		mov cl, byte[ebp+12] ;guardo la posicion del bit
		mov edx, 1

		shl edx, cl
		and ebx, edx
		shr ebx, cl
		mov dword[ebp-4], ebx 

		popa
		mov eax, dword[ebp-4]
		PROTOSALIDA
		ret
