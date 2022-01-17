/*
    Autor:  Ciro Fabian Bermudez Marquez
    Nombre: Simulador de diseños en VHDL de 64 bits en punto fijo
    Agracecimientos: Dr. Luis Gerardo de la Fraga y Dr. Cuauhtemoc Mancillas López
*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* Variables globales */
int _a;                       // parte entera
int _b;                       // parte fraccionaria
long _power;


void inicializa( int a, int b ){        
    _a = a;                             // A(a,b) representacion en punto fijo, cargamos variables globables 
    _b = b;
    _power = (long)1 << _b;                  // Calculamos el factor para la conversion
}


long setNumber( double v ){              // Convierte a punto fijo con truncamiento 
    return ( (long)(v*_power) );
}

double getNumber( long r ){              // Convierte de vuelta a double
    return ( (double)r/_power);
}


long multTrunc( long x, long y ){          // Multiplicacion con truncamiento
    __int128 r;
    __int128 a=0;
    __int128 b=0;
    a = x;
    b = y;
    r = a*b;
    r = r >> _b;
    return( r );
}


int main(int argc, char *argv[]){
    int entera;                     
    int frac;
	int i;
	
    long x;        // Variables para algoritmo
    double xd;    // Variables para condiciones iniciales
    
    // Parametros de punto fijo
    entera = 1;
    frac = 62;
    inicializa( entera, frac );
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);

    // Valores iniciales
    xd = 1.6;
    printf(" # x: %f\n", xd );

    
    // Conversion a punto fijo
    x = setNumber( xd );
   
    
    // printf("%.16lx\n", x);

    //printf(" # x real: %2.10f\n",getNumber( x ) );

    
    printf("%2.20f\t%lx\n",getNumber( x ), x);


    return 0;
}
// gcc -o simulation simulation.c
// ./simulation 
// gnuplot -e "filename='salida.txt'" graph.gnu
