
build: 
	gcc -m32 -c Main.c
	nasm -f elf funciones.asm
	gcc -m32 funciones.o Main.o -L ../../lib -lpc_io -no-pie -z noexecstack -o ../../bin/practica9.exe
run:
	./../../bin/practica9.exe
