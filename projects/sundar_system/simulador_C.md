# Simulador VHDL con C



La idea fundamental detrás de simular los diseños digitales en C antes de realizar su descripción en VHDL es poder comprobar que las arquitecturas, ya sean de 16, 32 o 64 bits utilizando la metodología de punto fijo funcionen correctamente desde el punto de vista de diseño, esto deja unicamente la posibilidad de cometer errores de sintaxis en la descripción en VHDL los cuales se pueden analizar y solucionar por separado.



## Tipos de dato en C

El tipo de dato es el primer punto fundamental para la simulación. Existen diversos tipos de datos en lenguaje C sin embargo para arquitecturas con tamaños de bits definidos podemos reducirlo a cuatro: `__int128`, `long`, `int`, `short`. Cada uno de estos tipos dato tiene una cantidad definida de bytes asociados dependiendo de la computadora y el compilador, para revisar la cantidad de bytes podemos utilizar el siguiente código:

```c
/*
	Autor:  		Ciro Fabian Bermudez Marquez
    Descripcion: 	Checar cantidad de bytes en data types del sistema
*/
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
	// Data type <float> tiene 4 bytes, es decir 32 bits.
	printf("float is %lu bytes.\n",sizeof(float));
	
	// Data type <double> tiene 8 bytes, es decir 64 bits.
	printf("double is %lu bytes.\n",sizeof(double));
	
	// Data type <__int128> tiene 16 bytes, es decir 128 bits.
	printf("__int128 is %lu bytes.\n",sizeof(__int128));

	// Data type <long> tiene 8 bytes, es decir 64 bits.
	printf("long is %lu bytes.\n",sizeof(long));

	// Data type <int> tiene 4 bytes, es decir 32 bits.
	printf("int is %lu bytes.\n",sizeof(int));

	// Data type <short> tiene 2 bytes, es decir 16 bits.
	printf("short is %lu bytes.\n",sizeof(short));
	
	// Data type <char> tiene 1 bytes, es decir 8 bits.
	printf("char is %lu bytes.\n",sizeof(char));
	
	return 0;
}
```

El formato `%lu` es para ver la cantidad de bytes también conocida como representación unsigned long.

Para compilar y después ejecutar el programa utilizamos las siguientes lineas de código en consola:

```she
gcc -o check_data_types check_data_types.c 
./check_data_types
```

En el caso particular del sistema que estamos utilizado, tenemos un procesador Ryzen 5 3600 corriendo en el sistema operativo MX Linux y la salida del programa es la siguiente:

```shell
float is 4 bytes.
double is 8 bytes.
__int128 is 16 bytes.
long is 8 bytes.
int is 4 bytes.
short is 2 bytes.
char is 1 bytes.
```



| Tipo       | Bytes | Bits | Caracteres en HEX |
| ---------- | ----- | ---- | ----------------- |
| `char`     | 1     | 8    | 2                 |
| `short`    | 2     | 16   | 4                 |
| `int`      | 4     | 32   | 8                 |
| `long`     | 8     | 64   | 16                |
| `__int128` | 16    | 128  | 32                |



## Representación de punto fijo

La representación de punto fijo de un número $X$ es $X(a,b)$ donde $a$ es la parte entera y $b$ es la parte fraccionaria. De manera que el número de bits en la representación es $a + b + 1$, es decir la parte entera más la parte fraccionaria más el bit de signo. El rango de valores que puede tomar es   $[-2^{a},2^{a}-2^{-b}]$. Por ejemplo:



| Número  | Conversión | Formato $X(a,b)$ | Rango $[-2^{a},2^{a}-2^{-b}]$ |
| ------- | ---------- | ---------------- | ----------------------------- |
| $01110$ | $3.5$      | $X(2,2)$         | $[-4,3.75]$                   |
| $10010$ | $-3.5$     | $X(2,2)$         | $[-4,3.75]$                   |
| $00011$ | $0.75$     | $X(2,2)$         | $[-4,3.75]$                   |



## Variables y funciones para algoritmo

Lo primero es definir variables globales para la parte entera y la parte fraccionaria para la representación de punto fijo, además una variable que almacene el factor de conversión entre punto flotante y punto fijo con el método de truncamiento. Las primeras dos variables son de tipo `int` por facilidad y el factor de conversión debe ser del tamaño de la arquitectura que será de $64$ bits.

```c
/* Variables globales */
int _a;			// parte entera
int _b;			// parte fraccionaria
long _power;	// factor de conversion
```

En lenguaje C, un corrimiento a la izquierda (Left Shift) se realiza con el operador `<<`, por ejemplo para realizar un corrimiento del entero `x` dos bits a la izquierda se escribe `x << 2`.

Después creamos una función para inicializar las variables globales y el factor de conversión.

```c
// A(a,b) representacion en punto fijo
void inicializa( int a, int b ){        
	_a = a;					// _a: parte entera
    _b = b;					// _b: parte fraccionaria
    _power = (long)1 << _b;	// calculo de factor de conversion
}
```

Para convertir un número de punto flotante a uno de punto fijo unicamente es necesario multiplicarlo por el factor de conversión, para entenderlo analicemos el siguiente ejemplo:

Si tuviéramos disponibles unicamente $4$ bits y seleccionamos una representación de $A(1,2)$ tenemos un rango de $[-2,1.75]$, si elegimos el número $1.5$ para convertir y lo multiplicamos por $2^{2}$, es decir por $2^{b}$ donde $b$ es la parte fraccionaria, $1.5\times2^2 = 6$, que en binario es $0110$, el cual es precisamente $1.5$ en punto fijo. El código anterior hace el corrimiento del número $1$ a la izquierda `_b` bits lo cual resulta ser una operación muy eficiente, alternativamente se podría cambiar por `_power = (long)pow(2,_b)`. Algo de suma importancia es que $a+b+1 = 4$ para este ejemplo de lo contrario la conversión no se realizará de manera correcta. Para arquitecturas de una cantidad mayor de bits se tiene que sustituir el $4$ por el número de bits de la arquitectura y se debe cumplir que $a+b+1=\text{Bits}_{\text{arq}}$, no deben faltar ni sobrar bits.

Por lo tanto la función para convertir a punto fijo con truncamiento es la siguiente:

```c
// Convierte a punto fijo con truncamiento 
long setNumber( double v ){
    return ( (long)(v*_power) );
}
```

Para convertir de vuelta a de punto fijo a punto flotante teniendo en cuenta que en el primer proceso de conversión de punto flotante a punto fijo existe una perdida de información por el truncamiento y por la cantidad de bits disponibles. unicamente es necesario dividir el número en punto fijo por el factor de conversión. Por ejemplo si tenemos el número binario de $4$ bits $0110$ el cual es $1.5$ en punto fijo en el formato $A(1,2)$ y $6$ en decimal sin signo y lo dividimos por el factor de conversión, $6/2^2 = 1.5$.

Por lo tanto la función para convertir de punto fijo a punto flotante es la siguiente:

```c
// Convierte de vuelta a punto flotante
double getNumber( long r ){
    return ( (double)r/_power);
}
```

La suma y la resta ya están definidas en las operaciones básicas de C, como el tipo `long` es un entero no es necesario definir una nueva función para estas operaciones en punto fijo ya que estas operan de la misma manera en ambos dominios, sin embargo para realizar la multiplicación en punto fijo es necesario truncar el resultado. En aritmética binaria la multiplicación requiere el doble de bits, por lo tanto es necesario utilizar un tipo de dato con el doble de bits para almacenar el resultado y después truncar el resultado en el lugar correcto. Como ejemplo consideremos el número b inario de $4$ bits $0010$ el cual es $0.5$ en punto fijo en el formato $A(1,2)$ y $2$ en decimal sin signo, si multiplicamos $0.5\times 0.5 = 0.25$ y en decimal sin signo $2 \times 2 = 4$, sabemos de antemano que si multiplicamos dos números de $4$ bits se requieren $8$ bits para el resultado, convirtiendo a binario la representación decimal sin signo resulta $0000\:\:0100$, y para que este número binario represente $0.25$ el formato resultante de la multiplicación en punto fijo debe ser $M(3,4)$ o de manera general $M(2a+1,2b)$, finalmente como unicamente debemos tener $4$ bits debemos realizar un corrimiento a la derecha $b$ veces, en este caso $2$ veces y obtenemos $0000\;\;0001$, tomando unicamente los primeros $4$ bits resulta $0001$ el cual representa $0.25$ en el formato de punto fijo $A(1,2)$ original.

El tipo de dato `__int128` es lo que utilizaremos para almacenar el resultado y después utilizando un corrimiento a la derecha $b$ veces y convirtiendo el resultado a `long` truncamos el resultado.

Utilizado lo anterior describimos una función para multiplicación de punto fijo con truncamiento de la siguiente manera:

```c
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
```



Finalmente para mostrar en pantalla información de la simulación y poder guardar el resultado de esta en un archivo de texto utilizamos los siguientes comandos:

```c
printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
```

```c
// Archivo de texto
FILE *fpointer = fopen("salida.txt","w");
	fprintf(fpointer,"%2.20f\t%lx\n", getNumber( x ),x);
fclose(fpointer);
```

La primera línea crea un apuntador para guardar en  `salida.txt` los resultados de la simulación, `%lx` es el formato de en hexadecimal de un tipo `long` y finalmente hay que cerrar el archivo de texto en el que se esta escribiendo.

Una vez teniendo todas las herramientas anteriores podemos hacer cualquier tipo de simulación de punto fijo en las arquitecturas de 16, 32 y 64 bits, únicamente hay que tener presente que:

| Arquitectura | Tipo    | Multiplicación |
| ------------ | ------- | -------------- |
| 16           | `short` | `int`          |
| 32           | `int`   | `long`         |
| 64           | `long`  | `__int128`     |

Para ejecutar el código de las plantillas se 

```shell
gcc -o simulacion simulacion.c - lm
./simulacion
```



## Plantillas



#### Para 64 bits

```c
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
    int entera = 3;
    int frac;
    frac = 64 - 1 - entera;
    
    // Variables y parametros de simulacion
    double x = 1.0;
    double a = 1.0;
    long xpf, apf;									// xpf: x punto fijo	apf: parametro
    
    // Inicializacion de arq
    inicializa( entera, frac);
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
    printf(" Rango: [%30.20f,%30.20f] = \n", -pow(2.0,entera),pow(2.0,entera)-pow(2.0,-frac));
    
    // Conversion a punto fijo
    xpf = setNumber( x );
    printf(" # x:      %12.8f\n # x real: %12.8f\n", x, getNumber( xpf ) );
    
    apf = setNumber( a );
    printf(" # a:      %12.8f\n # a real: %12.8f\n", a, getNumber( apf ) );
    
    fprintf(fpointer,"%12.8f  %.16lx\n", getNumber( xpf ), xpf);
    for(int i = 0; i < 5; i++){
        xpf = xpf + apf;
        fprintf(fpointer,"%12.8f  %.16lx\n", getNumber( xpf ), xpf);
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}
```





#### Para 32 bits

```c
/*
    Autor: 		 Ciro Fabian Bermudez Marquez
    Descripción: Simulador de diseños en VHDL de 32 bits en punto fijo
*/
/* Librerias*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* Variables globales */
int _a;			// parte entera
int _b;			// parte fraccionaria
int _power;	    // factor de conversion

/*Funciones*/

// Inicializacion A(a,b) representacion en punto fijo
void inicializa( int a, int b ){        
	_a = a;					// _a: parte entera
    _b = b;					// _b: parte fraccionaria
    _power = (int)1 << _b;	// calculo de factor de conversion
}

// Convierte a punto fijo con truncamiento 
int setNumber( double v ){
    return ( (int)(v*_power) );
}

// Convierte de vuelta a punto flotante
double getNumber( int r ){
    return ( (double)r/_power);
}

// Multiplicacion de punto fijo con truncamiento
int multTrunc( int x, int y ){
    long r;
    long a=0;
    long b=0;
    a = x;
    b = y;
    r = a*b;
    r = r >> _b;
    return( r );
}

int main(int argc, char *argv[]){
    FILE *fpointer = fopen("salida.txt","w");	    // Archivo de texto
    
    // Arq: 64 bits entera + frac + 1 = 64
    int entera = 3;
    int frac;
    frac = 32 - 1 - entera;
    
    // Variables y parametros de simulacion
    double x = 1.0;
    double a = 1.0;
    int xpf, apf;									// xpf: x punto fijo	apf: parametro
    
    // Inicializacion de arq
    inicializa( entera, frac);
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
    printf(" Rango: [%30.21f,%30.21f] = \n", -pow(2.0,entera),pow(2.0,entera)-pow(2.0,-frac));
    
    // Conversion a punto fijo
    xpf = setNumber( x );
    printf(" # x:      %10.6f\n # x real: %10.6f\n", x, getNumber( xpf ) );
    
    apf = setNumber( a );
    printf(" # a:      %10.6f\n # a real: %10.6f\n", a, getNumber( apf ) );
    
    fprintf(fpointer,"%10.6f  %.8x\n", getNumber( xpf ), xpf);
    for(int i = 0; i < 5; i++){
        xpf = xpf + apf;
        fprintf(fpointer,"%10.6f  %.8x\n", getNumber( xpf ), xpf);
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}
```





#### Para 16 bits

```c
/*
    Autor: 		 Ciro Fabian Bermudez Marquez
    Descripción: Simulador de diseños en VHDL de 16 bits en punto fijo
*/
/* Librerias*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* Variables globales */
int _a;			// parte entera
int _b;			// parte fraccionaria
short _power;	// factor de conversion

/*Funciones*/

// Inicializacion A(a,b) representacion en punto fijo
void inicializa( int a, int b ){        
	_a = a;						// _a: parte entera
    _b = b;						// _b: parte fraccionaria
    _power = (short)1 << _b;	// calculo de factor de conversion
}

// Convierte a punto fijo con truncamiento 
short setNumber( double v ){
    return ( (short)(v*_power) );
}

// Convierte de vuelta a punto flotante
double getNumber( short r ){
    return ( (double)r/_power);
}

// Multiplicacion de punto fijo con truncamiento
short multTrunc( short x, short y ){
    int r;
    int a=0;
    int b=0;
    a = x;
    b = y;
    r = a*b;
    r = r >> _b;
    return( r );
}

int main(int argc, char *argv[]){
    FILE *fpointer = fopen("salida.txt","w");	    // Archivo de texto
    
    // Arq: 64 bits entera + frac + 1 = 64
    int entera = 3;
    int frac;
    frac = 16 - 1 - entera;
    
    // Variables y parametros de simulacion
    double x = 1.0;
    double a = 1.0;
    short xpf, apf;									// xpf: x punto fijo	apf: parametro
    
    // Inicializacion de arq
    inicializa( entera, frac);
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
    printf(" Rango: [%30.15f,%30.15f] = \n", -pow(2.0,entera),pow(2.0,entera)-pow(2.0,-frac));
    
    // Conversion a punto fijo
    xpf = setNumber( x );
    printf(" # x:      %10.6f\n # x real: %10.6f\n", x, getNumber( xpf ) );
    
    apf = setNumber( a );
    printf(" # a:      %10.6f\n # a real: %10.6f\n", a, getNumber( apf ) );
    
    fprintf(fpointer,"%10.6f  %.4x\n", getNumber( xpf ), xpf);
    for(int i = 0; i < 5; i++){
        xpf = xpf + apf;
        fprintf(fpointer,"%10.6f  %.4x\n", getNumber( xpf ), xpf);
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}
```

