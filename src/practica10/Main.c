#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define SENSORS 2

extern void _setbit(unsigned char *flags,unsigned char posBit);
extern unsigned char _getbit(unsigned char,unsigned char);
void update_temp( int *temps, int *last_temps);
void update_flags( int *temps,int *last_temps, unsigned char *flags);
void print_flag(unsigned char flags);

int main(void)
{
	srand(time(NULL));
	int temps[SENSORS] = {25,25};
	int last_temps[SENSORS] = {25,25};
	unsigned char flags[SENSORS] = {0b00000001,0b00000001};

	printf("\n\r SENSOR 1: ~%d °C",temps[0]);
	print_flag(flags[0]);
	printf("\n\r SENSOR 2: ~%d °C",temps[1]);
	print_flag(flags[1]);
	
	int opcion=0;
	while(1)
	{
		printf("\n\r[1] Actualizar");
		printf("\n\r[2] Salir");
		printf("\n\rSelecciona opcion: ");
		scanf("%d", &opcion);
		switch(opcion)
		{
			case 1:
				update_temp(temps,last_temps);
				update_flags(temps, last_temps, flags);
				printf("\n\r SENSOR 1: ~%d °C",last_temps[0]);
				print_flag(flags[0]);
				printf("\n\r SENSOR 2: ~%d °C",last_temps[1]);
				print_flag(flags[1]);
				break;
			case 2:
				printf("Saliendo\n\r");
				return 0;
			break;
			default:
				printf("Opcion invalida\n\r");
			break;
		}
	}
	printf("\n\rFIN DE PROGRAMA\n\n\r");
	return 0;
}




void update_temp( int *temps, int *last_temps)
{
	int min = -5,max = 5;
	for(int i = 0 ; i < SENSORS; i++)
	{
		temps[i]=last_temps[i];
		last_temps[i]+=rand() % (max - min + 1) + min;
	}
}

void update_flags(int *temps, int *last_temps, unsigned char *flags)
{
	for(int i=0; i<=1; i++)
	{
		flags[i]=0;
		int diferencia=last_temps[i]-temps[i];
		if(diferencia==0){_setbit(&flags[i], 0);}
		else if(diferencia==1 || diferencia==-1){_setbit(&flags[i], 1);}
		else if(diferencia==2 || diferencia==-2){_setbit(&flags[i], 2);}
		else if(diferencia>=3 || diferencia<=-3){_setbit(&flags[i], 3);}
		if(diferencia<0){_setbit(&flags[i], 4);}
		else if(diferencia>0){_setbit(&flags[i], 5);}
	}
}


void print_flag(unsigned char flag)
{
	char c = _getbit(flag, 5) ? '>' : '<';

    if (_getbit(flag, 0))
        printf(" -");
    else if (_getbit(flag, 1))
	        printf(" %c", c);
    else if (_getbit(flag, 2))
        printf(" %c%c", c, c);
    else if (_getbit(flag, 3))
        printf(" %c%c%c", c, c, c);
}
