/*
    Autor: 		 Ciro Fabian Bermudez Marquez
    Descripción: Simulador de diseños en VHDL de 64 bits en punto fijo
*/
/* Librerias*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* Variables globales */
int _a;			// parte entera
int _b;			// parte fraccionaria
long _power;	// factor de conversion

/*Funciones*/

// Inicializacion A(a,b) representacion en punto fijo
void inicializa( int a, int b ){        
	_a = a;					// _a: parte entera
    _b = b;					// _b: parte fraccionaria
    _power = (long)1 << _b;	// calculo de factor de conversion
}

// Convierte a punto fijo con truncamiento 
long setNumber( double v ){
    return ( (long)(v*_power) );
}

// Convierte de vuelta a punto flotante
double getNumber( long r ){
    return ( (double)r/_power);
}

// Multiplicacion de punto fijo con truncamiento
long multTrunc( long x, long y ){
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
    FILE *fpointer = fopen("salida.txt","w");	    // Archivo de texto
    
    // Arq: 64 bits entera + frac + 1 = 64
    int entera = 11;
    int frac;
    frac = 64 - 1 - entera;
    
    // Variables y parametros de simulacion
	// Condiciones iniciales
	double y1_0 = 0.1;
	double y2_0 = 0.1;
	double y3_0 = 0.1;
	double y4_0 = 0.1;
	
	// Para metros
	double a = 40.0;
	double b = 28.0;
	double c = 4.0;
	double d = 7.0;
	double h = 0.001;
	
	// Variables para algoritmo en punto fijo
	long y1_n,y2_n,y3_n,y4_n;        	// Actual
    long y1_ni,y2_ni,y3_ni,y4_ni;		// Siguiente
	long apf, bpf, cpf, dpf, hpf;
    
    // Inicializacion de arq
    inicializa( entera, frac);
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
    printf(" Rango: [%30.20f,%30.20f] = \n", -pow(2.0,entera),pow(2.0,entera)-pow(2.0,-frac));
    
    // Conversion a punto fijo
	
	y1_n = setNumber( y1_0 );
	y2_n = setNumber( y2_0 );
	y3_n = setNumber( y3_0 );
	y4_n = setNumber( y4_0 );
	apf = setNumber( a );
	bpf = setNumber( b ); 
	cpf = setNumber( c );
	dpf = setNumber( d );
	hpf = setNumber( h );
	printf(" # y1_0:      %12.8f\n # y1_0 real: %12.8f\n", y1_0, getNumber( y1_n ) );
	printf(" # y2_0:      %12.8f\n # y2_0 real: %12.8f\n", y2_0, getNumber( y2_n ) );
	printf(" # y2_0:      %12.8f\n # y3_0 real: %12.8f\n", y3_0, getNumber( y3_n ) );
	printf(" # y4_0:      %12.8f\n # y4_0 real: %12.8f\n", y4_0, getNumber( y4_n ) );
	printf(" # a:      %12.8f\n # a real: %12.8f\n", a, getNumber( apf ) );
	printf(" # b:      %12.8f\n # b real: %12.8f\n", b, getNumber( bpf ) );
	printf(" # c:      %12.8f\n # c real: %12.8f\n", c, getNumber( cpf ) );
	printf(" # d:      %12.8f\n # d real: %12.8f\n", d, getNumber( dpf ) );
	
	printf("y1=%.16lx\ny2=%.16lx\ny3=%.16lx\ny4=%.16lx\n\n", y1_n,y2_n,y3_n,y4_n );
    printf("a=%.16lx\nb=%.16lx\nc=%.16lx\nd=%.16lx\nh=%.16lx\n", apf,bpf,cpf,dpf,hpf );
	fprintf(fpointer,"%.16lx\t%.16lx\n", y1_n , y2_n );
    for(int i = 0; i<100; i++){

        y1_ni = y1_n  + multTrunc(hpf,multTrunc( apf, y2_n - y1_n ) + multTrunc(y2_n, y3_n) + multTrunc( dpf, y4_n));
        y2_ni = y2_n  + multTrunc(hpf, - y1_n + multTrunc( bpf, y2_n ) - multTrunc( y1_n ,y3_n ) + multTrunc( dpf, y4_n));
        y3_ni = y3_n  + multTrunc(hpf, multTrunc( y2_n , y2_n ) - multTrunc( cpf, y3_n));
        y4_ni = y4_n  + multTrunc(hpf, - y2_n);
        
        y1_n = y1_ni;
        y2_n = y2_ni;
        y3_n = y3_ni;
        y4_n = y4_ni;     

        fprintf(fpointer,"%.16lx\t%.16lx\n", y1_n , y2_n );
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}