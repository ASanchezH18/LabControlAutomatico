%% Proyecto Individual 3
%Estudiante Angélica Sánchez Herrera
% EL-5409 Laboratorio de Control Automatico
%DISENO DE COMPENSADORES
clear;
clc;
close all;

disp('=============================================');
disp(' DISENO DE COMPENSADORES P, PI, PD Y PID');
disp('=============================================');

%% 1. INGRESO DE CEROS

nCeros = input('Ingrese la cantidad de ceros: ');
ceros = [];

for i = 1:nCeros
    ceros(i) = input(['Ingrese el cero ',num2str(i),': ']);
end

%% INGRESO DE POLOS

nPolos = input('Ingrese la cantidad de polos: ');
polos = [];

for i = 1:nPolos
    polos(i) = input(['Ingrese el polo ',num2str(i),': ']);
end

%% 2. FUNCION DE TRANSFERENCIA

G = tf(zpk(ceros,polos,1));
[num,den] = tfdata(G,'v');

disp(' ');
disp('Funcion de transferencia de la planta:');
G

%% 3. ECUACION CARACTERISTICA

ecuacionCaracteristica = den;

disp('Ecuacion caracteristica de la planta:');
disp([poly2str(ecuacionCaracteristica,'s'),' = 0']);

%% 4. LUGAR DE LAS RAICES

figure;
rlocus(G);
grid on;
hold on;
title('Lugar de las raices de la planta');

%% 5. DESPLAZAMIENTO DE POLOS

polosDesplazados = [];

disp(' ');
disp('=============================================');
disp(' DESPLAZAMIENTO DE POLOS');
disp('=============================================');

for i = 1:nPolos

    disp(['Polo ',num2str(i),' actual:']);
    disp(polos(i));

    entrada = input( ...
        'Ingrese m para mantenerlo o la nueva posicion: ','s');

    if strcmpi(entrada,'m')
        nuevoPolo = polos(i);
    else
        nuevoPolo = str2num(entrada); %#ok<ST2NM>

        if isempty(nuevoPolo)
            error('Polo no valido.');
        end
    end

    polosDesplazados(end+1) = nuevoPolo;
end

%% AGREGAR CONJUGADO SI HACE FALTA

i = 1;

while i <= length(polosDesplazados)

    p = polosDesplazados(i);

    if imag(p) ~= 0

        if ~any(abs(polosDesplazados-conj(p)) < 1e-6)

            polosDesplazados(end+1) = conj(p);

            disp('Se agrego el polo conjugado:');
            disp(conj(p));
        end
    end

    i = i + 1;
end

disp('Polos desplazados:');
disp(polosDesplazados.');

plot(real(polosDesplazados),imag(polosDesplazados), ...
    'rx','MarkerSize',12,'LineWidth',2);

%% 6. SELECCION DEL COMPENSADOR

ordenPlanta = length(den)-1;
cantidadPolos = length(polosDesplazados);

opciones = [];

% P y PD no agregan polos
if cantidadPolos <= ordenPlanta
    opciones = [opciones 1 3];
end

% PI y PID agregan un polo
if cantidadPolos <= ordenPlanta + 1
    opciones = [opciones 2 4];
end

if isempty(opciones)
    error('Ningun compensador permite esta cantidad de polos.');
end

disp(' ');
disp('=============================================');
disp(' COMPENSADORES DISPONIBLES');
disp('=============================================');

if ismember(1,opciones)
    disp('1. P');
end

if ismember(2,opciones)
    disp('2. PI');
end

if ismember(3,opciones)
    disp('3. PD');
end

if ismember(4,opciones)
    disp('4. PID');
end

opcion = input('Seleccione una opcion: ');

while ~ismember(opcion,opciones)
    disp('Compensador no disponible.');
    opcion = input('Seleccione otra opcion: ');
end

%% 7. COMPLETAR DISTRIBUCION DE POLOS

polosCompensados = polosDesplazados;

% PI y PID aumentan el orden en uno
if opcion == 2 || opcion == 4

    if length(polosCompensados) < ordenPlanta + 1

        disp('El compensador agrega un polo adicional.');

        poloAdicional = input( ...
            'Ingrese la ubicacion del polo adicional: ');

        polosCompensados(end+1) = poloAdicional;
    end
end

%% NUEVA ECUACION CARACTERISTICA

ecCompensada = real(poly(polosCompensados));

disp(' ');
disp('Nueva ecuacion caracteristica:');
disp([poly2str(ecCompensada,'s'),' = 0']);

%% 8. CALCULO DEL COMPENSADOR

switch opcion

    case 1
        %% P

        nombre = 'P';

        g = ganancias( ...
            den,{num},ecCompensada);

        Kp = g(1);

        C = tf(Kp,1);

        disp('Kp:');
        disp(Kp);

    case 2
        %% PI

        nombre = 'PI';

        base = conv(den,[1 0]);

        terminos = { ...
            conv(num,[1 0]), ...
            num};

        g = ganancias( ...
            base,terminos,ecCompensada);

        Kp = g(1);
        Ki = g(2);

        C = tf([Kp Ki],[1 0]);

        disp('Kp:');
        disp(Kp);

        disp('Ki:');
        disp(Ki);

    case 3
        %% PD

        nombre = 'PD';

        terminos = { ...
            num, ...
            conv(num,[1 0])};

        g = ganancias( ...
            den,terminos,ecCompensada);

        Kp = g(1);
        Kd = g(2);

        C = tf([Kd Kp],1);

        disp('Kp:');
        disp(Kp);

        disp('Kd:');
        disp(Kd);

    case 4
        %% PID

        nombre = 'PID';

        base = conv(den,[1 0]);

        terminos = { ...
            conv(num,[1 0]), ...
            num, ...
            conv(num,[1 0 0])};

        g = ganancias( ...
            base,terminos,ecCompensada);

        Kp = g(1);
        Ki = g(2);
        Kd = g(3);

        C = tf([Kd Kp Ki],[1 0]);

        disp('Kp:');
        disp(Kp);

        disp('Ki:');
        disp(Ki);

        disp('Kd:');
        disp(Kd);
end

%% 9. MOSTRAR COMPENSADOR

disp(' ');
disp(['Compensador ',nombre,':']);
C;

%% 10. PLANTA CON COMPENSADOR

L = C*G;

disp('Planta G(s):');
G

disp('Compensador C(s):');
C

disp('Planta con compensador C(s)G(s):');
L

%% 11. SISTEMA COMPENSADO

TPlanta = feedback(G,1);
TCompensado = feedback(L,1);

disp('Sistema compensado:');
TCompensado

%% ECUACION CARACTERISTICA REAL

[~,denCompensado] = tfdata(TCompensado,'v');

disp('Ecuacion caracteristica del sistema compensado:');
disp([poly2str(denCompensado,'s'),' = 0']);

%% 12. COMPARACION DE RESPUESTAS

figure;

step(TPlanta,TCompensado);
grid on;

legend('Respuesta de la planta', ...
       ['Respuesta con ',nombre], ...
       'Location','best');

title('Comparacion de respuestas');
xlabel('Tiempo');
ylabel('Respuesta');

%% =========================================================
% CALCULO DE LAS GANANCIAS
% ==========================================================

function g = ganancias(base,terminos,deseada)

    largos = cellfun(@length,terminos);

    n = max([length(base),length(deseada),largos]);

    base = [zeros(1,n-length(base)) base];
    deseada = [zeros(1,n-length(deseada)) deseada];

    A = zeros(n,length(terminos));

    for i = 1:length(terminos)

        t = terminos{i};
        t = [zeros(1,n-length(t)) t];

        A(:,i) = t(:);
    end

    g = real(A\(deseada(:)-base(:)));
end