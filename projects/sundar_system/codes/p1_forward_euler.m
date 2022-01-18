clear; close all; clc;
tic
h = 0.001;     % Tamanio de paso
t = 0:h:100;   % Vector de tiempo

% Parametros
a = 40;
b = 28;
c = 4;
d = 7;

y1 = zeros(size(t));   % Inicializacion de los vectores
y2 = zeros(size(t));
y3 = zeros(size(t));
y4 = zeros(size(t));

% Asignacion de condicion inicial
ini_cond = [0.1 0.1 0.1 0.1]';    % Condiciones iniciales
y1(1) = ini_cond(1);
y2(1) = ini_cond(2);
y3(1) = ini_cond(3);
y4(1) = ini_cond(3);

% Algoritmo forward euler
for i = 2:size(y1,2)
    y1(i) = y1(i-1) + y1_state(y1(i-1),y2(i-1),y3(i-1),y4(i-1),a,b,c,d)*h;
    y2(i) = y2(i-1) + y2_state(y1(i-1),y2(i-1),y3(i-1),y4(i-1),a,b,c,d)*h;
    y3(i) = y3(i-1) + y3_state(y1(i-1),y2(i-1),y3(i-1),y4(i-1),a,b,c,d)*h;
    y4(i) = y4(i-1) + y4_state(y1(i-1),y2(i-1),y3(i-1),y4(i-1),a,b,c,d)*h;
end

% f = figure; f.Position(1:2) = [800 800]; % [right bottom]
subplot(2,2,1); plot(y1,y2); grid on; grid minor;
subplot(2,2,2); plot(y2,y3); grid on; grid minor;
subplot(2,2,3); plot(y3,y4); grid on; grid minor;
subplot(2,2,4); plot(y1,y4); grid on; grid minor;

check_max = max( [max(y1) max(y2) max(y3) max(y4)] )
check_min = min( [min(y1) min(y2) min(y3) min(y4)] )
toc

% Descripcion de sistema dinamico
function R = y1_state(y1,y2,y3,y4,a,b,c,d)
    R = a*(y2-y1) + y2*y3 + d*y4;
end

function R = y2_state(y1,y2,y3,y4,a,b,c,d)
    R = -y1 + b*y2 - y1*y3 + d*y4;
end

function R = y3_state(y1,y2,y3,y4,a,b,c,d)
    R = y2*y2 - c*y3;
end

function R = y4_state(y1,y2,y3,y4,a,b,c,d)
    R = -y2;
end