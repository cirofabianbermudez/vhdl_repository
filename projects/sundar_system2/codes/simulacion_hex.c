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
    int entera = 15;
    int frac;
    frac = 64 - 1 - entera;
    
    // Variables y parametros de simulacion
	// Condiciones iniciales
	double z1_0 = 1.0;
	double z2_0 = 1.0;
	double z3_0 = 1.0;
	double z4_0 = 1.0;
	double z5_0 = 1.0;
	
	// Para metros
	double a = 40.0;
	double b = 90.0;
	double c = 16.0;
	double d = 15.0;
	double h = 0.0001;
	
	// Variables para algoritmo en punto fijo
	long z1_n,z2_n,z3_n,z4_n,z5_n;        	// Actual
    long z1_ni,z2_ni,z3_ni,z4_ni,z5_ni;		// Siguiente
	long apf, bpf, cpf, dpf, hpf;
    
    // Inicializacion de arq
    inicializa( entera, frac);
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
    printf(" Rango: [%30.20f,%30.20f] = \n", -pow(2.0,entera),pow(2.0,entera)-pow(2.0,-frac));
    
    // Conversion a punto fijo
	
	z1_n = setNumber( z1_0 );
	z2_n = setNumber( z2_0 );
	z3_n = setNumber( z3_0 );
	z4_n = setNumber( z4_0 );
	z5_n = setNumber( z5_0 );
	apf = setNumber( a );
	bpf = setNumber( b ); 
	cpf = setNumber( c );
	dpf = setNumber( d );
	hpf = setNumber( h );
	printf(" # z1_0:      %12.8f\n # z1_0 real: %12.8f\n", z1_0, getNumber( z1_n ) );
	printf(" # z2_0:      %12.8f\n # z2_0 real: %12.8f\n", z2_0, getNumber( z2_n ) );
	printf(" # z2_0:      %12.8f\n # z3_0 real: %12.8f\n", z3_0, getNumber( z3_n ) );
	printf(" # z4_0:      %12.8f\n # z4_0 real: %12.8f\n", z4_0, getNumber( z4_n ) );
	printf(" # z5_0:      %12.8f\n # z5_0 real: %12.8f\n", z5_0, getNumber( z5_n ) );
	printf(" # a:      %12.8f\n # a real: %12.8f\n", a, getNumber( apf ) );
	printf(" # b:      %12.8f\n # b real: %12.8f\n", b, getNumber( bpf ) );
	printf(" # c:      %12.8f\n # c real: %12.8f\n", c, getNumber( cpf ) );
	printf(" # d:      %12.8f\n # d real: %12.8f\n", d, getNumber( dpf ) );
	
	
    
	printf("z1=%.16lx\nz2=%.16lx\nz3=%.16lx\nz4=%.16lx\nz5=%.16lx\n\n", z1_n,z2_n,z3_n,z4_n,z5_n );
    printf("a=%.16lx\nb=%.16lx\nc=%.16lx\nd=%.16lx\nh=%.16lx\n", apf,bpf,cpf,dpf,hpf );
	fprintf(fpointer,"%.16lx\t%.16lx\n", z1_n , z2_n );
    for(int i = 0; i<1000; i++){

        z1_ni = z1_n  + multTrunc(hpf,multTrunc( apf, z2_n - z1_n ) + multTrunc(z2_n, z3_n) + z4_n);
        z2_ni = z2_n  + multTrunc(hpf, multTrunc( z1_n, bpf - z3_n ) + multTrunc( cpf, z4_n)  );
        z3_ni = z3_n  + multTrunc(hpf, multTrunc( z1_n , z1_n ) - multTrunc( dpf, z3_n ) + multTrunc( z1_n, z2_n) );
        z4_ni = z4_n  + multTrunc(hpf, z5_n - z2_n);
		z5_ni = z5_n  + multTrunc(hpf, -z5_n );
        
        z1_n = z1_ni;
        z2_n = z2_ni;
        z3_n = z3_ni;
        z4_n = z4_ni;   
		z5_n = z5_ni;		

        fprintf(fpointer,"%.16lx\t%.16lx\n", z1_n , z2_n );
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}