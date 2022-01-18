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
data = [];

% Asignacion de condicion inicial
ini_cond = [0.1 0.1 0.1 0.1]';    % Condiciones iniciales
y1(1) = ini_cond(1);
y2(1) = ini_cond(2);
y3(1) = ini_cond(3);
y4(1) = ini_cond(3);

% Algoritmo forward euler
for i = 1:100001
    % Operacioness 
    op11 = y2(i)-y1(i);         % Resta
    op12 = a*op11;              % Mult
    op13 = y2(i)*y3(i);         % Mult
    op14 = op12 + op13;         % Suma
    op15 = d*y4(i);             % Mult
    op16 = op14 + op15;         % Suma
    op17 = op16*h;              % Mult
    y1(i+1) = y1(i) + op17;     % Suma
    
    
    op21 = d*y4(i);
    op22 = op21 - y1(i);
    op23 = b*y2(i);
    op24 = y1(i)*y3(i);
    op25 = op23 - op24;
    op26 = op25 + op22;
    op27 = op26*h;
    y2(i+1) = y2(i) + op27;

    op31 = y2(i)*y2(i);
    op32 = c*y3(i); 
    op33 = op31 - op32;
    op34 = op33*h;
    y3(i+1) = y3(i) + op34;

    op41 = y2(i)*h;
    y4(i+1) = y4(i) - op41;

    data(i,:) = [y1(i+1),y2(i+1),y3(i+1),y4(i+1),op11,op12,op13,op14,op15,op16,op17,op21,op22,op23,op24,op25,op26,op27, op31,op32,op33,op34, op41];
end

% f = figure; f.Position(1:2) = [800 800]; % [right bottom]
subplot(2,2,1); plot(y1,y2); grid on; grid minor;
subplot(2,2,2); plot(y2,y3); grid on; grid minor;
subplot(2,2,3); plot(y3,y4); grid on; grid minor;
subplot(2,2,4); plot(y1,y4); grid on; grid minor;

check_max = max(data,[],'all')
check_min = min(data,[],'all')

toc
% Nota algo de suma importancia que acabo de notar es que dependiendo del 
% orden de las operaciones cambia el resultado, si realizamos primero la
% suma del parametro que tiene d y y2y3 el resultado cambia ligeeramente.
% 20,43