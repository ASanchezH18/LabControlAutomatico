%Estudiante Angélica Sánchez Herrera
% EL-5409 Laboratorio de Control Automatico
% Diseño de compensador proporcional mediante Root Locus

clear;
clc;
close all;

fprintf('=============================================\n');
fprintf(' Proyecto 3 - Compensador por Root Locus\n');
fprintf('=============================================\n\n');

%% ---------------------------------------------------------
% 1. INGRESO DE CEROS
% ----------------------------------------------------------

nc = input('Ingrese la cantidad de ceros: ');

ceros = zeros(1,nc);

for a = 1:nc
    ceros(a) = input(sprintf('Ingrese el cero %d: ',a));
end

%% ---------------------------------------------------------
% 2. INGRESO DE POLOS
% ----------------------------------------------------------

np = input('Ingrese la cantidad de polos: ');

fprintf('\n---------------------------------------------\n');
fprintf(' INDICACIONES PARA INGRESAR LOS POLOS\n');
fprintf('---------------------------------------------\n');
fprintf('Polos reales:    -2\n');
fprintf('Polos complejos: -2+3i\n');
fprintf('\n');
fprintf('Los polos complejos deben ingresarse en pares conjugados.\n');
fprintf('Ejemplo:\n');
fprintf('   Polo 1: -2+3i\n');
fprintf('   Polo 2: -2-3i\n');
fprintf('---------------------------------------------\n\n');

% Repetir el ingreso hasta que los polos sean validos
polos_validos = false;

while ~polos_validos

    polos = zeros(1,np);

    for a = 1:np
        polos(a) = input(sprintf('Ingrese el polo %d: ',a));
    end

    polos_validos = true;

    % Verificacion de polos complejos conjugados
    for a = 1:np

        if imag(polos(a)) ~= 0

            conjugado = conj(polos(a));

            % Verificar si el conjugado se encuentra en el vector
            if ~any(abs(polos - conjugado) < 1e-10)

                fprintf('\nERROR:\n');
                fprintf('El polo %.4f %+.4fi no tiene su conjugado.\n', ...
                    real(polos(a)),imag(polos(a)));

                fprintf('Debe existir tambien el polo %.4f %+.4fi.\n\n', ...
                    real(conjugado),imag(conjugado));

                polos_validos = false;
                break;

            end
        end
    end

    if ~polos_validos
        fprintf('Ingrese nuevamente todos los polos.\n\n');
    end

end

fprintf('\nPolos ingresados correctamente.\n\n');

%% ---------------------------------------------------------
% 3. FUNCION DE TRANSFERENCIA
% ----------------------------------------------------------

G = tf(zpk(ceros,polos,1));

[num,den] = tfdata(G,'v');

fprintf('\nFuncion de transferencia de la planta:\n');
G

%% ---------------------------------------------------------
% 4. ECUACION CARACTERISTICA ORIGINAL
% ----------------------------------------------------------

fprintf('Ecuacion caracteristica original:\n');
fprintf('%s = 0\n\n',poly2str(den,'s'));

%% ---------------------------------------------------------
% 5. ROOT LOCUS
% ----------------------------------------------------------

figure;
rlocus(G);
grid on;

title('Root Locus de la planta');

fprintf('Polos originales:\n');
disp(polos.');

%% ---------------------------------------------------------
% 6. SELECCION DEL DESPLAZAMIENTO
% ----------------------------------------------------------

respuesta = input('Desea desplazar los polos? (s/n): ','s');

if strcmpi(respuesta,'s')

    fprintf('\nSeleccione con un clic la nueva ubicacion deseada\n');
    fprintf('sobre el Root Locus.\n\n');

    [Kp, polos_nuevos] = rlocfind(G);

else

    Kp = 0;
    polos_nuevos = polos.';

end

%% ---------------------------------------------------------
% 7. RESULTADOS
% ----------------------------------------------------------

fprintf('\nGanancia del compensador:\n');
fprintf('Kp = %.4f\n\n',Kp);

fprintf('Polos del sistema compensado:\n');
disp(polos_nuevos);

%% ---------------------------------------------------------
% 8. SISTEMA COMPENSADO
% ----------------------------------------------------------

T = feedback(Kp*G,1);

[num_comp,den_comp] = tfdata(T,'v');

fprintf('Funcion de transferencia del sistema compensado:\n');
T

fprintf('Nueva ecuacion caracteristica:\n');
fprintf('%s = 0\n\n',poly2str(den_comp,'s'));

%% ---------------------------------------------------------
% 9. COMPENSADOR
% ----------------------------------------------------------

C = tf(Kp,1);

fprintf('Funcion de transferencia del compensador:\n');
C