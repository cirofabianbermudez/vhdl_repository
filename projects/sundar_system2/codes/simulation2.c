/*
    Autor:  Ciro Fabian Bermudez Marquez
    Nombre: Simulador de diseños en VHDL de 32 bits en punto fijo
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


/*
    Para un Ryzen 5 3600 en MxLinux
    
    Data type <int> tiene 4 bytes, es decir 32 bits.
    printf("int is %lu bytes.\n",sizeof(int));
    
    Data type <short> tiene 2 bytes, es decir 16 bits.
    printf("short is %lu bytes.\n",sizeof(short));
    
    Para compilar ejecutar:
        gcc -o cordic cordic.c - lm
*/

void inicializa( int a, int b ){        
    _a = a;                             // A(a,b) representacion en punto fijo, cargamos variables globables 
    _b = b;
    _power = 1L << _b;                  // Calculamos el factor para la conversion
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

    // Archivo de texto
    FILE *fpointer = fopen("salida.txt","w");
    
    int entera;                     
    int frac;
    int i;

    long y1_n,y2_n,y3_n,y4_n;        // Variables para algoritmo
    long y1_ni,y2_ni,y3_ni,y4_ni;
    long hf;
    long ap,bp,cp,dp;         		// Parametros del sistema
    
    double y1_0,y2_0,y3_0,y4_0,h;    // Variables para condiciones iniciales
    
    
    // Parametros de punto fijo
    entera = 11; // 20
    frac = 52; // 43
    inicializa( entera, frac );
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);

    // Valores iniciales
    y1_0 = 0.1;
    y2_0 = 0.1;
    y3_0 = 0.1;
    y4_0 = 0.1;
    h    = 0.001;
    
    printf(" # y1_0: %f\n", y1_0 );
    printf(" # y2_0: %f\n", y2_0 );
    printf(" # y3_0: %f\n", y3_0 );
    printf(" # y4_0: %f\n", y4_0 );
    printf(" #    h: %f\n", h );
    
    // Conversion a punto fijo
    y1_n = setNumber( y1_0 );
    y2_n = setNumber( y2_0 );
    y3_n = setNumber( y3_0 );
    y4_n = setNumber( y4_0 );
      hf = setNumber(    h );
    printf(" # y1_0 real: %2.10f\n",getNumber(y1_n) );
    printf(" # y2_0 real: %2.10f\n",getNumber(y2_n) );
    printf(" # y3_0 real: %2.10f\n",getNumber(y3_n) );
    printf(" # y4_0 real: %2.10f\n",getNumber(y4_n) );
    printf(" #    h real: %2.10f\n",getNumber(  hf) );
    
    
    // Parametros del sistema
    ap = setNumber( 40.0 );
    bp = setNumber( 28.0 );
    cp = setNumber( 4.0 );
    dp = setNumber( 7.0 );

    
    //fprintf(fpointer,"%2.20f\t%2.20f\t\t%lx\t\t%lx\n",getNumber( y1_n ), getNumber( y2_n ) , y1_n, y2_n);
    fprintf(fpointer,"%2.20f\t%2.20f\n",getNumber( y1_n ), getNumber( y2_n ));
    for(i = 0; i<10000000; i++){

        y1_ni = y1_n  + multTrunc(hf,multTrunc( ap, y2_n - y1_n ) + multTrunc(y2_n, y3_n) + multTrunc( dp, y4_n));
        y2_ni = y2_n  + multTrunc(hf, - y1_n + multTrunc( bp, y2_n ) - multTrunc( y1_n ,y3_n ) + multTrunc( dp, y4_n));
        y3_ni = y3_n  + multTrunc(hf, multTrunc( y2_n , y2_n ) - multTrunc( cp, y3_n));
        y4_ni = y4_n  + multTrunc(hf, - y2_n);
        
        
        y1_n = y1_ni;
        y2_n = y2_ni;
        y3_n = y3_ni;
        y4_n = y4_ni;     

        //fprintf(fpointer,"%2.20f\t%2.20f\t\t%lx\t\t%lx\n",getNumber( y1_ni ), getNumber( y2_ni ),y2_ni,y2_ni);
        fprintf(fpointer,"%2.20f\t%2.20f\n",getNumber( y1_n ), getNumber( y2_n ));
    }
    
    fclose(fpointer);
    return 0;
}
// gcc -o simulation simulation.c
// ./simulation 
// gnuplot -e "filename='salida.txt'" graph.gnu
