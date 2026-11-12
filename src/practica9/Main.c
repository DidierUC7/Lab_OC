#include <stdio.h>
#define MAX 5

extern int _minimo(int*,int);
extern int _maximo(int*,int);
extern int _sumatoria(int*,int);

void imprimirArreglo(int arreglo[]);

int main()
{
    int arreglo[MAX]={1,2,-21,14,-6};
    printf("Arreglo: ");
    imprimirArreglo(&arreglo[0]);

    printf("\n\r Minimo Ensamblador: %d \n", _minimo(arreglo,MAX));
    printf("\n\r Maximo Ensamblador: %d \n", _maximo(arreglo,MAX));
    printf("\n\r Sumatoria Ensamblador: %d \n", _sumatoria(arreglo,MAX));

    return 0;
}

void imprimirArreglo(int arreglo[MAX]){
    for(int i=0; i<MAX; i++){
        printf("%d ", arreglo[i]);
    }
}