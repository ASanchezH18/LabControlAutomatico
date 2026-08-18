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
% 1. INGRESO DE PARAMETROS Y VALIDACION
% ----------------------------------------------------------

%% Kt
entrada = input('Ingrese Kt [N*m/A]: ', 's');
Kt = str2double(entrada);

while Kt <= 0 || isnan(Kt)

    fprintf('Valor invalido. Kt debe ser mayor que cero.\n');

    entrada = input('Ingrese nuevamente Kt o q para salir: ', 's');

    if strcmpi(entrada, 'q')
        fprintf('Programa finalizado por el usuario.\n');
        return;
    end

    Kt = str2double(entrada);
end


%% Ra
entrada = input('Ingrese Ra [ohm]: ', 's');
Ra = str2double(entrada);

while Ra <= 0 || isnan(Ra)

    fprintf('Valor invalido. Ra debe ser mayor que cero.\n');

    entrada = input('Ingrese nuevamente Ra o q para salir: ', 's');

    if strcmpi(entrada, 'q')
        fprintf('Programa finalizado por el usuario.\n');
        return;
    end

    Ra = str2double(entrada);
end


%% b
entrada = input('Ingrese b [N*m*s/rad]: ', 's');
b = str2double(entrada);

while b < 0 || isnan(b)

    fprintf('Valor invalido. b debe ser mayor o igual que cero.\n');

    entrada = input('Ingrese nuevamente b o q para salir: ', 's');

    if strcmpi(entrada, 'q')
        fprintf('Programa finalizado por el usuario.\n');
        return;
    end

    b = str2double(entrada);
end


%% Kb
entrada = input('Ingrese Kb [V*s/rad]: ', 's');
Kb = str2double(entrada);

while Kb <= 0 || isnan(Kb)

    fprintf('Valor invalido. Kb debe ser mayor que cero.\n');

    entrada = input('Ingrese nuevamente Kb o q para salir: ', 's');

    if strcmpi(entrada, 'q')
        fprintf('Programa finalizado por el usuario.\n');
        return;
    end

    Kb = str2double(entrada);
end


%% J
entrada = input('Ingrese J [kg*m^2]: ', 's');
J = str2double(entrada);

while J <= 0 || isnan(J)

    fprintf('Valor invalido. J debe ser mayor que cero.\n');

    entrada = input('Ingrese nuevamente J o q para salir: ', 's');

    if strcmpi(entrada, 'q')
        fprintf('Programa finalizado por el usuario.\n');
        return;
    end

    J = str2double(entrada);
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
fprintf('G(s) = %.4f / (%.4f s + 1)\n', KM, tau);

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
yline(y_final_KM, '--');

text(0.72*t_5tau, y_final_KM + 0.03*y_final_KM, ...
    sprintf('Valor final = %.4f', y_final_KM));


%% Entrada escalon unitario
yline(1, ':', 'Entrada escalon = 1');


%% Error de estado estacionario

% Solo se muestra si existe un error de estado estacionario apreciable
if abs(ess) > 0.001

    % Posicion horizontal donde se mostrara el error
    x_ess = 0.55 * t_5tau;

    % Dibuja una linea vertical entre el valor final del sistema
    % y el valor de referencia del escalon unitario
    plot([x_ess x_ess], [y_final_KM 1], ':', ...
        'LineWidth', 1.5, ...
        'HandleVisibility', 'off');

    % Coloca el valor del error en el centro de la linea
    text(x_ess, (1 + y_final_KM)/2, ...
        sprintf('  e_{ss} = %.4f', ess), ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'middle');

end


%% Banda de asentamiento del 2 %
yline(limite_superior, '--');
yline(limite_inferior, '--');

text(0.72*t_5tau, limite_superior + 0.02*y_final_KM, ...
    sprintf('Limite +2%% = %.4f', limite_superior));

text(0.72*t_5tau, limite_inferior - 0.04*y_final_KM, ...
    sprintf('Limite -2%% = %.4f', limite_inferior));


%% Punto en t = tau
plot(t_tau, y_tau, 'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 2);

xline(t_tau, '--', ...
    sprintf('tau = %.4f s', tau));

text(t_tau + 0.03*t_5tau, ...
    y_tau + 0.03*y_final_KM, ...
    sprintf('y(tau) = %.4f', y_tau), ...
    'VerticalAlignment', 'bottom');


%% Punto en t = 5*tau
plot(t_5tau, y_5tau, 'o', ...
    'MarkerSize', 8, ...
    'LineWidth', 2);

xline(t_5tau, '--', ...
    sprintf('5tau = %.4f s', t_5tau));

text(t_5tau - 0.03*t_5tau, ...
    y_5tau - 0.08*y_final_KM, ...
    sprintf('y(5tau) = %.4f', y_5tau), ...
    'VerticalAlignment', 'top', ...
    'HorizontalAlignment', 'right');


%% Tiempo de asentamiento
xline(ts, '-.', ...
    sprintf('Ts 2%% = %.4f s', ts));


%% Formato de la grafica
title('Respuesta al escalon unitario del motor DC');

xlabel('Tiempo [s]');
ylabel('Respuesta del sistema');

legend('Respuesta del sistema', ...
       'Location', 'best');

hold off;