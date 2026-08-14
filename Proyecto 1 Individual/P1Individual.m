%% Proyecto Individual 1
%Estudiante Angélica Sánchez Herrera
% EL-5409 Laboratorio de Control Automatico
% Simulacion parametrica de un motor DC
%
% G(s) = KM / (tau*s + 1)

clear;
clc;
close all;

fprintf('=============================================\n');
fprintf(' Simulacion de motor DC - Sistema 1er orden\n');
fprintf('=============================================\n\n');

%% ---------------------------------------------------------
% 1. INGRESO DE PARAMETROS Y VALIDACIÓN
% ----------------------------------------------------------

Kt = input('Ingrese Kt [N*m/A]: ');
if Kt <= 0
    error('Kt debe ser mayor que cero.');
end

Ra = input('Ingrese Ra [ohm]: ');
if Ra <= 0
    error('Ra debe ser mayor que cero.');
end

b  = input('Ingrese b [N*m*s/rad]: ');
if b < 0
    error('b no puede ser negativo.');
end

Kb = input('Ingrese Kb [V*s/rad]: ');
if Kb <= 0
    error('Kb debe ser mayor que cero.');
end

J  = input('Ingrese J [kg*m^2]: ');
if J <= 0
    error('J debe ser mayor que cero.');
end

parametros = [Kt, Ra, b, Kb, J];

if any(~isfinite(parametros))
    error('Todos los parametros deben ser valores numericos finitos.');
end

%% ---------------------------------------------------------
% 3. CALCULO DE KM Y TAU
% ----------------------------------------------------------

denominador = Ra*b + Kt*Kb;

if denominador <= 0
    error('El denominador Ra*b + Kt*Kb debe ser mayor que cero.');
end

KM = Kt / denominador;
tau = (Ra*J) / denominador;

%% ---------------------------------------------------------
% 4. MOSTRAR RESULTADOS
% ----------------------------------------------------------

fprintf('\n=============================================\n');
fprintf(' Resultados calculados\n');
fprintf('=============================================\n');

fprintf('KM  = %.6f\n', KM);
fprintf('tau = %.6f s\n', tau);

%% ---------------------------------------------------------
% 5. FUNCION DE TRANSFERENCIA
%
%            KM
% G(s) = ------------
%          tau*s + 1
% ----------------------------------------------------------

G = tf(KM, [tau 1]);

fprintf('\nFuncion de transferencia obtenida:\n');
disp(G);

%% ---------------------------------------------------------
% 6. CALCULOS IMPORTANTES
% ----------------------------------------------------------

% Valor teorico final
y_final_KM = KM;

% Respuesta en t = tau
t_tau = tau;
y_tau = KM * (1 - exp(-1));

% Respuesta en t = 5*tau
t_5tau = 5*tau;
y_5tau = KM * (1 - exp(-5));

% Tiempo de asentamiento al 2 %
ts = -tau * log(0.02);

% Limites de la banda del 2 %
limite_superior = 1.02 * y_final_KM;
limite_inferior = 0.98 * y_final_KM;

% Error de estado estacionario respecto
% a un escalon unitario
ess = 1 - y_final_KM;

fprintf('\n=============================================\n');
fprintf(' Caracteristicas de la respuesta\n');
fprintf('=============================================\n');

fprintf('Valor final teorico       = %.6f\n', y_final_KM);
fprintf('Respuesta en t = tau      = %.6f\n', y_tau);
fprintf('Respuesta en t = 5*tau    = %.6f\n', y_5tau);
fprintf('Tiempo de asentamiento 2%% = %.6f s\n', ts);
fprintf('Error estado estacionario = %.6f\n', ess);

%% ---------------------------------------------------------
% 7. RESPUESTA AL ESCALON
% ----------------------------------------------------------

% Se simula hasta 5 constantes de tiempo
t = linspace(0, 5*tau, 1000);

[y, t] = step(G, t);

%% ---------------------------------------------------------
% 8. GRAFICA
% ----------------------------------------------------------

figure;

plot(t, y, 'LineWidth', 2);
hold on;
grid on;

%% Valor final
yline(y_final_KM, '--', ...
    sprintf('Valor final = %.4f', y_final_KM));

%% Entrada escalon unitario
yline(1, ':', 'Entrada escalon = 1');

%% Banda de asentamiento del 2 %
yline(limite_superior, '--', 'Limite +2%');
yline(limite_inferior, '--', 'Limite -2%');

%% Punto en t = tau
plot(t_tau, y_tau, 'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 2);

xline(t_tau, '--', ...
    sprintf('tau = %.4f s', tau));

text(t_tau, y_tau, ...
    sprintf('  y(tau) = %.4f', y_tau), ...
    'VerticalAlignment', 'bottom');

%% Punto en t = 5*tau
plot(t_5tau, y_5tau, 'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 2);

xline(t_5tau, '--', ...
    sprintf('5tau = %.4f s', t_5tau));

text(t_5tau, y_5tau, ...
    sprintf('  y(5tau) = %.4f', y_5tau), ...
    'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment', 'right');

%% Tiempo de asentamiento
xline(ts, '-.', ...
    sprintf('Ts 2%% = %.4f s', ts));

%% Formato
title('Respuesta al escalon unitario del motor DC');

xlabel('Tiempo [s]');
ylabel('Respuesta del sistema');

legend('Respuesta del sistema', ...
       'Location', 'best');

hold off;