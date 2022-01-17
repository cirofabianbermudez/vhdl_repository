clear; close all; clc;
tic
h = 0.001;     % Tamanio de paso

% Parametros
a = 40;
b = 28;
c = 4;
d = 7;

y1 = [];
y2 = [];
y3 = [];
y4 = [];

% Asignacion de condicion inicial
ini_cond = [0.1 0.1 0.1 0.1]';    % Condiciones iniciales
y1(1) = ini_cond(1);
y2(1) = ini_cond(2);
y3(1) = ini_cond(3);
y4(1) = ini_cond(3);

% Algoritmo forward euler
for i = 1:100000
    y1(i+1) = y1(i) + (a*(y2(i)-y1(i)) +  y2(i)*y3(i) + d*y4(i))*h;
    y2(i+1) = y2(i) + (-y1(i) + b*y2(i) - y1(i)*y3(i) + d*y4(i))*h;
    y3(i+1) = y3(i) + (y2(i)*y2(i) - c*y3(i))*h;
    y4(i+1) = y4(i) + (-y2(i))*h;
end

f = figure; f.Position(1:2) = [800 800]; % [right bottom]
subplot(2,2,1); plot(y1,y2); grid on; grid minor;
subplot(2,2,2); plot(y2,y3); grid on; grid minor;
subplot(2,2,3); plot(y3,y4); grid on; grid minor;
subplot(2,2,4); plot(y1,y4); grid on; grid minor;

check_max = [max(y1) max(y2) max(y3) max(y4)];
check_min = [min(y1) min(y2) min(y3) min(y4)];
check_min = min(check_min)
check_max = max(check_max)

toc