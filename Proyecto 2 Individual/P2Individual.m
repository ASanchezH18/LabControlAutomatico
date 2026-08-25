%% Proyecto Individual 2
%Estudiante Angélica Sánchez Herrera
% EL-5409 Laboratorio de Control Automatico
% Routh-Hurwitz y Lugar de las Raices

clear;
clc;
close all;

clear;
clc;
close all;
while true

    %% Indicaciones

    fprintf('=============================================\n');
    fprintf(' INGRESO DE POLOS Y CEROS\n');
    fprintf('=============================================\n');
    fprintf('Ingrese cada polo y cero de forma individual.\n');
    fprintf('Ejemplo real: -2\n');
    fprintf('Ejemplo complejo: -1+3i\n');
    fprintf('Los valores complejos deben ingresarse con su conjugado.\n');
    fprintf('Si la funcion no tiene ceros, ingrese 0 como cantidad.\n\n');

    %% Ingreso de ceros

    nz = input('Ingrese la cantidad de ceros: ');
    ceros = zeros(1,nz);

    for a = 1:nz
        ceros(a) = input(sprintf('Ingrese el cero %d: ',a));
    end

    %% Ingreso de polos

    np = input('Ingrese la cantidad de polos: ');
    polos = zeros(1,np);

    for a = 1:np
        polos(a) = input(sprintf('Ingrese el polo %d: ',a));
    end

    %% Crear polinomios

    num = poly(ceros);
    den = poly(polos);

    %% Verificar conjugados

    if any(abs(imag(num)) > 1e-10) || any(abs(imag(den)) > 1e-10)

        fprintf('\nERROR: Los polos y ceros complejos deben ingresarse con su conjugado.\n');
        fprintf('Ingrese nuevamente los datos.\n\n');

        continue;

    end

    num = real(num);
    den = real(den);

    break;

end

%% Funcion de transferencia G(s)

G = tf(num,den);

disp(' ');
disp('Funcion de transferencia G(s):');
G

%% Ecuacion caracteristica 1 + K*G(s) = 0

K = input('Ingrese el valor de K: ');

N = max(length(num),length(den));

numK = [zeros(1,N-length(num)) num];
denK = [zeros(1,N-length(den)) den];

coef = denK + K*numK;

disp(' ');
disp('Ecuacion caracteristica:');
disp([poly2str(coef,'s') ' = 0']);

%% Tabla de Routh-Hurwitz

grado = length(coef) - 1;
columnas = ceil((grado+1)/2);

R = zeros(grado+1,columnas);

R(1,1:length(coef(1:2:end))) = coef(1:2:end);
R(2,1:length(coef(2:2:end))) = coef(2:2:end);

for a = 3:grado+1

    if R(a-1,1) == 0
        R(a-1,1) = eps;
    end

    for b = 1:columnas-1

        R(a,b) = ...
            (R(a-1,1)*R(a-2,b+1) - ...
             R(a-2,1)*R(a-1,b+1)) / R(a-1,1);

    end
end

disp(' ');
disp('Tabla de Routh-Hurwitz:');

for a = 1:grado+1
    fprintf('s^%d\t',grado-a+1);
    fprintf('%10.4f\t',R(a,:));
    fprintf('\n');
end

%% Determinar estabilidad

primeraColumna = R(:,1);
cambios = 0;

for a = 1:length(primeraColumna)-1

    if primeraColumna(a)*primeraColumna(a+1) < 0
        cambios = cambios + 1;
    end

end

disp(' ');

if cambios == 0

    disp('El sistema es ESTABLE.');
    disp('No hay cambios de signo en la primera columna de Routh.');

else

    disp('El sistema es INESTABLE.');
    fprintf('Hay %d cambios de signo en la primera columna.\n',cambios);
    fprintf('Por lo tanto, hay %d polos en el semiplano derecho.\n',cambios);

end

%% Lugar de las raices

figure;
rlocus(G);
grid on;
title('Lugar de las raices');