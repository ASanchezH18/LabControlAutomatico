# Instituto Tecnológico de Costa Rica

## Escuela de Ingeniería Electrónica

**Curso:** EL-5409 Laboratorio de Control Automático

**Profesor:** Ing. Luis C. Rosales

**Semestre:** II Semestre 2026

**Proyecto:** Proyecto Individual 2

**Estudiante:** Angélica Sánchez Herrera
**Carné:** 2021021770

---

# Proyecto Individual 2 — Routh-Hurwitz y Root Locus

## Descripción

Este proyecto consiste en un script desarrollado en MATLAB para analizar una función de transferencia a partir de la ubicación de sus polos y ceros.

El programa permite:

* Construir la función de transferencia (G(s)).
* Construir la ecuación característica de lazo cerrado (1+KG(s)=0).
* Generar la tabla de Routh-Hurwitz.
* Determinar la estabilidad del sistema mediante los cambios de signo en la primera columna de la tabla de Routh.
* Generar el gráfico del lugar de las raíces (*Root Locus*).

## Requisitos

Para ejecutar el script se requiere:

* MATLAB.
* Control System Toolbox, utilizado para las funciones `tf` y `rlocus`.

No se requiere Symbolic Math Toolbox.

## Uso del script

Ejecute el archivo `.m` desde MATLAB.

Al iniciar, el programa solicitará la cantidad y ubicación de los ceros y polos de la función de transferencia.

### Ingreso de ceros

Primero se debe indicar la cantidad de ceros:

```text
Ingrese la cantidad de ceros: 1
```

Después se ingresa cada cero individualmente:

```text
Ingrese el cero 1: -2
```

Si la función de transferencia no tiene ceros, se debe ingresar:

```text
Ingrese la cantidad de ceros: 0
```

### Ingreso de polos

Después se debe indicar la cantidad de polos:

```text
Ingrese la cantidad de polos: 4
```

Cada polo se ingresa individualmente:

```text
Ingrese el polo 1: -2+3i
Ingrese el polo 2: -2-3i
Ingrese el polo 3: -5
Ingrese el polo 4: -8
```

Los valores complejos deben escribirse utilizando `i`.

Por ejemplo:

```text
-2+3i
```

Si se utiliza un polo o cero complejo, también debe ingresarse su conjugado. Por ejemplo:

```text
-2+3i
-2-3i
```

Si los valores complejos no poseen su correspondiente conjugado, el programa solicitará nuevamente el ingreso de los polos y ceros.

## Valor de ganancia K

Después de construir la función de transferencia, el programa solicita un valor de ganancia:

```text
Ingrese el valor de K: 1
```

Este valor se utiliza para construir la ecuación característica:

[
1+KG(s)=0
]

y realizar el análisis mediante Routh-Hurwitz.

## Resultados

El programa muestra en la ventana de comandos:

1. La función de transferencia (G(s)).
2. La ecuación característica de lazo cerrado.
3. La tabla de Routh-Hurwitz identificando las filas desde (s^n) hasta (s^0).
4. La cantidad de cambios de signo en la primera columna.
5. La conclusión sobre la estabilidad del sistema.

Finalmente, se genera una figura con el lugar de las raíces (*Root Locus*) de la función de transferencia.

## Ejemplo de prueba

Se pueden utilizar los siguientes valores:

```text
Cantidad de ceros: 1
Cero 1: -2

Cantidad de polos: 4
Polo 1: -2+3i
Polo 2: -2-3i
Polo 3: -5
Polo 4: -8

K: 1
```

Con estos datos, el programa construye la función de transferencia correspondiente, genera la tabla de Routh-Hurwitz, determina la estabilidad para el valor de (K) ingresado y muestra el lugar de las raíces.
