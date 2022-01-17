# Manual de VHDL



## 1. Introducción

En cuanto al acrónimo VHDL, la V es la abreviatura de otro acrónimo: VHSIC (Very High-Speed Integrated Circuit) o circuito integrado de muy alta velocidad. HDL (Hardware Description Language) significa lenguaje de descripción de hardware.

VHDL se inventó para describir hardware y, de hecho, VHDL es un lenguaje **concurrente**. Lo que esto significa es que, normalmente, todas las instrucciones VHDL se ejecutan al mismo tiempo (simultáneamente), independientemente del tamaño de su implementación.

Otra forma de ver esto es que los lenguajes informáticos de alto nivel se usan para describir algoritmos (ejecución secuencial) y VHDL se usa para describir hardware (ejecución paralela).

Antes de comenzar a escribir código en VHDL es necesario tener presente algunas de las características fundamentales de este lenguaje.

* Hay dos propósitos principales para los lenguajes de descripción de hardware como VHDL. 
  * Primero, VHDL se puede usar para modelar circuitos y sistemas digitales. 
  * En segundo lugar, tener algún tipo de modelo de circuito permite la posterior simulación y/o prueba del circuito. 
  * El modelo VHDL también se puede traducir a una forma que se puede usar para generar circuitos de trabajo reales.
* El modelo VHDL es interpretado por herramientas de software de tal manera que se crean circuitos digitales reales en un proceso conocido como **síntesis**.
*  Síntesis: el proceso de interpretar el código VHDL y generar una definición de la implementación del circuito físico que se programará en un dispositivo como un FPGA.
* Los intentos de escribir código VHDL con un estilo de lenguaje de alto nivel generalmente dan como resultado un código que nadie entiende. Además, las herramientas utilizadas para sintetizar este tipo de código tienden a generar circuitos que generalmente no funcionan correctamente y tienen errores que son casi imposibles de rastrear.
* El programador escribe una descripción vaga de lo que debe hacer el circuito lógico final y un compilador de lenguaje, en este caso llamado sintetizador, intenta "inferir" cuál debe ser el circuito lógico físico final real.
* VHDL es un lenguaje utilizado para implementar hardware. Una FPGA (Field Programmable Gate Array) es probablemente el dispositivo más común que puede usar para sus implementaciones de VHDL. 
* VHDL no es sensible a mayúsculas y minúsculas.
* VHDL no es sensible a espacios en blanco.
* Los comentarios en VHDL comienzan con el símbolo `--`, dos guiones.
* Aunque no es absolutamente necesario el uso de paréntesis para indicar la precedencia de operaciones resulta de mucha utilidad.
* Toda declaración o sentencia (statements) en VHDL se termina con punto y coma `;`.
* Cosas a recordar cuando se trabaje con las sentencias `if`, `case`, `loop`
  * Toda sentencia `if` debe tener su correspondiente componente `then`
  * Toda sentencia `if` se termina con `end if;`
  * Para agregar más casos en la sentencia `if ` se utiliza `elsif` en VHDL.
  * Toda sentencia `case` se termina con un `end case;`
  * Toda sentencia `loop` se termina con un `end loop;`
* Los identificadores son los nombres que se le dan a variables o funciones y deben seguir las siguientes reglas:
  * Los identificadores deben ser auto-descriptivos.
  * Los identificadores no deben ser excesivamente largos ni cortos. Deben ser de un tamaño razonable.
  * Los identificadores solo pueden contener una combinaciones de letras (`A-Z` y `a-z`), números (`0-9`) y guiones bajos (`_`).
  * Los identificadores no deben terminar con un guion bajo y nunca deben tener dos guiones bajos consecutivos.
  * El mejor identificador para una variable que almacena la edad de su auto es `AgeMyCar` o `age_my _car`. Trate de ser consistente.
  * Elecciones inteligentes para los identificadores hacen que su código VHDL sea más legible, comprensible y más impresionante para sus compañeros de trabajo, superiores, familiares y amigos.

___

## 2. Palabras reservadas y estilo de codificación

La siguiente tabla contiene todas las palabras reservadas en VHDL. Estas palabras no pueden ser utilizadas como identificadores.

|          |            |            |            |             |         |
| -------- | ---------- | ---------- | ---------- | ----------- | ------- |
| `access` | `after`    | `alias`    | `all`      | `attribute` | `block` |
| `body`   | `buffer`   | `bus`      | `constant` | `exit`      | `file`  |
| `for`    | `function` | `generic`  | `group`    | `in`        | `is`    |
| `label`  | `loop`     | `mod`      | `new`      | `next`      | `null`  |
| `of`     | `on`       | `open`     | `out`      | `range`     | `rem`   |
| `return` | `signal`   | `shared`   | `then`     | `to`        | `type`  |
| `until`  | `use`      | `variable` | `wait`     | `while`     | `with`  |



A continuación se enlistan algunas buenas  practicas al momento de estar codificando algún diseño en VHDL:

* Agregar autor y descripción breve diseño en la parte superior del cada documento.
* Respetar un estilo de codificación para identificadores y funciones en todos los documentos.
* Utilizar indentación para hacer el código más legible.
* Comentar el código con breves descripciones de funcionamiento cuando se necesite.



## 3. Conceptos básicos

Cuando vamos a crear un diseño en VHDL una buena manera de comenzar es pensarlo como una **caja negra** la cual tiene ciertas entradas y ciertas salidas y su funcionamiento se esconde dentro de la caja. El enfoque de caja negra para cualquier tipo de diseño implica una estructura jerárquica en la que se encuentran disponibles cantidades variables de detalles en cada uno de los diferentes niveles de la jerarquía.

Una vez hecho esto, se hace referencia al módulo por su representación de caja negra inherentemente más simple en lugar de por los detalles del circuito que realmente realiza esa funcionalidad. Este enfoque tiene dos ventajas principales. Primero, simplifica el diseño desde el punto de vista de los sistemas. Examinar un diagrama de circuito que contiene cajas negras con nombres apropiados es mucho más comprensible que mirar un circuito que contiene un número incontable de puertas lógicas. En segundo lugar, el enfoque de caja negra permite la reutilización de código escrito previamente.

No es sorprendente que las descripciones VHDL de circuitos se basen en el enfoque de caja negra. Las dos partes principales de cualquier diseño jerárquico son la caja negra y las cosas que van dentro de la caja negra (que, por supuesto, pueden ser otras cajas negras).

En VHDL, la caja negra se denomina **entidad** (`entity`) y el contenido que contiene se denomina **arquitectura** (`architecture`). Por esta razón, la entidad y la arquitectura VHDL están estrechamente relacionadas. Como probablemente pueda imaginar, la creación de la entidad es relativamente simple, mientras que una buena parte del tiempo de codificación de VHDL se dedica a escribir correctamente la arquitectura.

La construcción de entidad VHDL proporciona un método para abstraer la funcionalidad de una descripción de circuito a un nivel superior. Proporciona un envoltorio simple para el circuito de nivel inferior. Este envoltorio describe efectivamente cómo la caja negra interactúa con el mundo exterior. Dado que VHDL describe circuitos digitales, la entidad simplemente enumera las diversas entradas y salidas de los circuitos subyacentes. En términos de VHDL, la caja negra se describe mediante una declaración de entidad.

Analicemos el siguiente ejemplo:

```vhdl
entity my_entity is
	port(
		port_name_1 : in  	std_logic;
    	port_name_2 : out 	std_logic;
		port_name_3 : inout std_logic); -- No olvidar el punto y coma
	end my_entity;                      -- No olvidar este punto y coma tampoco
```

`my_entity` define el nombre de la entidad. La siguiente sección no es más que la lista de señales del circuito subyacente que están disponibles para el mundo exterior, por lo que a menudo se la denomina especificación de interfaz. El nombre `port_name_x` es un identificador que se utiliza para diferenciar las distintas señales.

La palabra clave `port` da inicio a la declaración de las entradas y salidas de la entidad. Cada entrada y salida es un puerto y debe nombrarse con un identificador, su dirección y su tipo.

Las palabras clave `in`, `out`, `inout `especifican la dirección de la señal en relación con la entidad donde las señales pueden entrar, salir o hacer ambas cosas.  

La palabra clave `std_logic` se refiere al tipo de datos que manejará el puerto. Hay varios tipos de datos disponibles en VHDL, pero trataremos principalmente con el tipo de `std_logic` y las versiones derivadas.

Cuando un varias entradas o salidas estan relaciones entre si a este conjunto comunmente se le llama **bus** en el lenguaje de computadoras. Las lineas de un bus están formadas por más de una señal que se diferencian en el nombre por solo un carácter numérico. Desafortunadamente, la palabra bus también se refiere a los protocolos de transferencia de datos establecidos. Para eliminar la ambigüedad de la palabra bus, usaremos la palabra **bundle** para referirnos a un conjunto de señales similares y bus para referirnos a un protocolo.

Para describir un bundle en VHDL se utiliza el tipo de dato `std_logic_vector`. Hay dos metodos posibles para describir las señales en el bundle. Si queremos que el bit más significativo se encuentra a la izquierda utilizamos la pabra reservada `downto`, y si queremos que el bit más significativo este a la derecha utillizamos la palabra reservada `to`, es importante no olvidar la orientación para evitar errores.

Tanto el tipo de dato `std_logic` como el `std_logic_vector` son representaciones de señales digitales que la IEEE ha estandarizado. Estos tipos de dato tienen 9 valores diferentes posibles, los cuales son:

| Tipo | Significado                       |
| ---- | --------------------------------- |
| `0`  | Logic zero                        |
| `1`  | Logic ones                        |
| `U`  | Uninitialized                     |
| `X`  | Unknown logic value, strong drive |
| `Z`  | High impedance                    |
| `W`  | Unknown logic value, weak drive   |
| `L`  | Weak drive, logic zero            |
| `H`  | Weak drive, logic one             |
| `-`  | don't care                        |

El tipo de dato `std_logic` se encuentra disponible despues de las siguientes declaraciones:

```vhdl
library IEEE;
use IEEE.std_logic_1164.all;
```

Al igual que en otros lenguajes, VHDL ha evolucionado mucho y se han creado librerias que aumentan su funcionalidad, una de las más importantes es la libreria:

```vhdl
use IEEE.numeric_std.all;
```

 la cual nos da acceso al tipo de dato `unsigned` y a la función `to_unsigned` entre muchas otras.

La declaración de entidad VHDL, presentada anteriormente, describe la interfaz o la representación externa del circuito. La arquitectura describe lo que realmente hace el circuito. En otras palabras, la arquitectura VHDL describe la implementación interna de la entidad asociada.

Una arquitectura se puede escribir mediante tres técnicas de modelado más cualquier combinación de estas tres. Existe el modelo de **data flow**, el modelo **behavioral**, el modelo **structural** y los modelos **híbridos**.

En VHDL hay varios tipos de objetos. Entre los más utilizados mencionaremos el tipo de objeto **signal**, el tipo de objeto **variable** y el tipo de objeto **constant**.

El tipo **signal** es la representación en software de un cable. El tipo de **variable**, como en C o Java, se utiliza para almacenar información local, **contant** es un tipo de objeto variable cuyo valor no se puede cambiar. Un objeto de **signal** puede ser de diferentes tipos por ejemplo, que un objeto de señal puede ser de tipo `std_logic` o de otros tipos como `integer`, tipos personalizados, etc. Lo mismo aplica para objetos **variable**. Antes de utilizar cualquier señal o variable, es obligatorio declararlas.

Las señales se declaran en la parte superior del cuerpo de la arquitectura, justo antes de la palabra clave `begin`. Las variables deben declararse dentro de la construcción`process` y son locales.

Cuando se quiere asignar un nuevo valor a un objeto de tipo señal se utiliza el operador `<=`. Alternativamente, cuando se quiere asignar un nuevo valor a un objeto de tipo variable se utiliza el operador `:=`.

Es importante comprender la diferencia entre variables y señales, específicamente cuando cambia su valor. Una variable cambia su valor poco después de ejecutar la asignación de la variable. En cambio, una señal cambia su valor "algún tiempo" después de que se evalúa la expresión de asignación de señal. Esto tiene consecuencias importantes para los valores actualizados de variables y señales. Esto significa que nunca debe asumir que una asignación de señal puede ocurrir instantáneamente y también significa que puede aprovechar las variables cada vez que necesite implementar un contador o almacenar valores dentro de un proceso.

Para poder introducir el uso de una variable tenemos que emplear la construcción de un `process`.Cada vez que necesitemos un entorno de ejecución no concurrente donde las líneas de código se ejecuten una tras otra (como en C o Java), usaremos la construcción un `process`.

Dentro de un `process`, todas las instrucciones se ejecutan consecutivamente de arriba a abajo. Sin embargo, el `process` en sí se ejecutará al mismo tiempo que el resto del código.

Recuerde siempre que la asignación y la ejecución del proceso, no se ejecutan consecutivamente sino concurrentemente (todos al mismo tiempo).

El operador `<=` se conoce oficialmente como operador de asignación de señales para resaltar su verdadero propósito. El operador de asignación de señal especifica una relación entre señales. En otras palabras, la señal del lado izquierdo del operador de asignación de señal depende de las señales del lado derecho del operador. 

Los operadores lógicos son los siguientes:

|        |        |
| ------ | ------ |
| `and`  | `or`   |
| `nand` | `nor`  |
| `xor`  | `xnor` |
| `not`  |        |

estos operadores lógicos se consideran operadores binarios con la excepción de `not` el cual es unario.

Hay cuatro tipos de sentencias concurrentes basicas, asignación directa, la declaración de proceso, la asignación de señal condicional y la asignación de señal seleccionada.

**Directa**

```vhdl
<target> <= <expression>;
```

**Condicional** `when else`

```vhdl
<target> <= <expression> when <condition> else
			<expression> when <condition> else
			<expression>;
```

**Seleccionada** `with select`

```vhdl
with <choose_expression> select
	target <= <expression> when <choices>,
    		  <expression> when <choices>;
    		  <expression> when others;
```

Los operadores de relación son los siguientes:

|      |      |
| ---- | ---- |
| `=`  | `/=` |
| `>`  | `<`  |
| `>=` | `<=` |

las comillas simples se utilizan para describir valores de señales individuales, mientras que las comillas dobles se utilizan para describir valores asociados con múltiples señales o paquetes.



## Códigos

### LUT (Look Up Table)

Toda LUT es una funcion booleana la cual se puede implementar de la siguiente manera:

```vhdl
-- Librerias
library IEEE;
use IEEE.std_logic_1164.all;
-- Entidad
entity boolean_function is
    port(
        A,B,C	: in  std_logic;
        X		: out std_logic
    );
end boolean_function;
-- Arquitectura    
architecture arch of boolean_function is
begin
	X <= not( (A and B) or (B and C) );
end arch;
```

podemos utilizar asignaciones auxiliares de la siguiene manera

```vhdl
library IEEE;
use IEEE.std_logic_1164.all;

entity boolean_function is
    port(
        A,B,C	: in  std_logic;
        X		: out std_logic
    );
end boolean_function;
    
architecture arch of boolean_function is
    signal T1, T2 : std_logic;  -- Seniales auxiliares
begin
    T1 <= A and B;
	T2 <= B and C;
	X <= not( T1 or T2 );
end arch;
```

Si solo conocemos los lugares donde la función booleana es verdadera podemos hacer la siguiente descipción:

```vhdl
library IEEE;
use IEEE.std_logic_1164.all;

entity boolean_function3 is
    port(
        A,B,C	: in  std_logic;
        X		: out std_logic
    );
end boolean_function3;
    
architecture arch of boolean_function3 is
    signal t_sig : std_logic_vector(2 downto 0);  -- Senial temporal
begin
    t_sig <= (A & B & C);  -- Operador de concatenacion
	with t_sig select
        X <= '1' when "000"|"001"|"010"|"100"|"101",
        	 '0' when others;
end arch;
```



### Multiplexor

Para implementar el multiplexor hay muchas maneras de hacerlo, las más comunes son las siguientes cuatro

```vhdl
-- Librerias
library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4_1 is
	generic(n : integer := 8); 		-- Tamanio de bundle
	port(
		I0,I1,I2,I3 : in  std_logic_vector(n-1 downto 0);
		SEL 		: in  std_logic_vector(1   downto 0); 
		MUX_OUT		: out std_logic_vector(n-1 downto 0)
	);
end mux_4_1;

-- Arquitectura
architecture arch_mux of mux_4_1 is
	constant zero : std_logic_vector(n-1 downto 0) := (others => '0');
begin 
	-- Conditional signal assignment
	MUX_OUT <=	I0	when SEL = "00" else
				I1	when SEL = "01" else
				I2	when SEL = "10" else
				I3	when SEL = "11" else
				zero;		 				-- Cambia dinamicamente dependiendo de 		
end	arch_mux;
```

Alternativamente se puede modificar dentro entre `begin` y `end arch_much;` lo siguiente y todas son validas.

```vhdl
	with SEL select
		MUX_OUT <=  I0	when "00",
					I1	when "01",
					I2	when "10",
					I3	when "11",
					zero when others;		-- Cambia dinamicamente dependiendo de 		
```

```vhdl
	-- Case syntax 
	con_case: process(SEL,I0,I1,I2,I3) is
	begin
		case SEL is
			when "00"	=> 	MUX_OUT <=	I0;
		 	when "01" 	=>	MUX_OUT <=	I1;
		  	when "10" 	=>	MUX_OUT <=	I2;
		  	when "11" 	=>	MUX_OUT <=	I3;
			when others	=>	MUX_OUT <=	zero; -- Cambia dinamicamente dependiendo de
		end case;
	end process con_case;		 		
```

```vhdl
	-- if elsif else syntax	 
	con_if: process(SEL,I0,I1,I2,I3) is
	begin
		if 	   SEL = "00" then 
			MUX_OUT <=	I0;
		elsif  SEL = "01" then
			MUX_OUT <=	I1;
		elsif  SEL = "10" then
			MUX_OUT <=	I2;
		elsif  SEL = "11" then
			MUX_OUT <=	I3;
		else
			MUX_OUT <=	zero;
		end if;		
	end process con_if;
```



### Decodificador

```vhdl
-- Librerias
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is
	port(
		D_IN  : in  std_logic_vector(3 downto 0);
        D_OUT : out std_logic_vector(2 downto 0)
	);
end decoder;

architecture arch_mux of mux_4_1 is
begin 
	with D_IN select
		D_OUT <= "100" when "0000"|"0001"|"0010"|"0011",
				 "010" when "0100"|"0101"|"0111"|"1000"|"1001",
    		     "001" when "1010"|"1011"|"1100"|"1110"|"1111",
				 "000" when others;
end	arch_mux;
```



## Bibliografía



## Links de referencia

