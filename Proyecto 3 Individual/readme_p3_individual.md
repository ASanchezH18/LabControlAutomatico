# Proyecto Individual 3 - Diseño de Compensadores

**Instituto Tecnológico de Costa Rica**  
**Escuela de Ingeniería Electrónica**  
**Curso:** EL-5409 Laboratorio de Control Automático  
**Profesor:** Ing. Luis C. Rosales  
**Semestre:** II Semestre 2026  

**Estudiante:** Angélica Sánchez Herrera  
**Carnet:** 2021021770  

---

## Descripción

Este proyecto implementa en MATLAB una herramienta para el diseño y análisis de compensadores **P, PI, PD y PID** a partir de una función de transferencia definida mediante sus ceros y polos.

El programa permite construir la planta, obtener su ecuación característica, visualizar el lugar de las raíces, desplazar los polos del sistema y calcular las ganancias necesarias para un compensador seleccionado.

Finalmente, se obtiene el sistema compensado y se compara su respuesta al escalón con la respuesta de la planta original.

---

## Funcionalidades

El programa realiza las siguientes operaciones:

1. Solicita la cantidad de ceros de la planta.
2. Permite ingresar cada cero individualmente.
3. Solicita la cantidad de polos.
4. Permite ingresar cada polo individualmente.
5. Construye la función de transferencia de la planta:

$$
G(s)=\frac{N(s)}{D(s)}
$$

6. Extrae y muestra la ecuación característica:

\[
D(s)=0
\]

7. Genera el lugar de las raíces mediante `rlocus`.
8. Permite mantener o desplazar individualmente los polos del sistema.
9. Agrega automáticamente el conjugado cuando se introduce un polo complejo y este no se encuentra en la distribución.
10. Determina cuáles compensadores pueden utilizarse según el orden del sistema.
11. Permite seleccionar entre:
    - P
    - PI
    - PD
    - PID
12. Para PI y PID permite agregar el polo adicional asociado al aumento del orden del sistema.
13. Construye la nueva ecuación característica a partir de los polos desplazados.
14. Calcula las ganancias correspondientes:
   - $K_p$
   - $K_i$
   - $K_d$
15. Construye la función de transferencia del compensador $$C(s) $$.
16. Obtiene la combinación:

$$
C(s)G(s)
$$

17. Obtiene el sistema compensado con realimentación unitaria.
18. Extrae la ecuación característica del sistema compensado.
19. Compara mediante una respuesta al escalón:
    - Planta original.
    - Planta con compensador.

---

## Requisitos

Para ejecutar el programa se necesita:

- MATLAB.
- Control System Toolbox.

El script utiliza funciones como:

```matlab
tf
zpk
tfdata
rlocus
feedback
step
