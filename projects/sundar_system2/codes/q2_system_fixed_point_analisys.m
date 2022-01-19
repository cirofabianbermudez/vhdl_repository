clear; close all; clc;
tic
h = 0.0001;     % Tamanio de paso

% Parametros
a = 40.0;
b = 90.0;
c = 16.0;
d = 15.0;

z1 = [];
z2 = [];
z3 = [];
z4 = [];
z5 = [];
data = [];

% Asignacion de condicion inicial
ini_cond = [1.0 1.0 1.0 1.0 1.0]';    % Condiciones iniciales
z1(1) = ini_cond(1);
z2(1) = ini_cond(2);
z3(1) = ini_cond(3);
z4(1) = ini_cond(4);
z5(5) = ini_cond(5);

% Algoritmo forward euler
for i = 1:1000
    % Operacioness 
    op11 = z2(i)-z1(i);         
    op12 = a*op11;              
    op13 = z2(i)*z3(i);         
    op14 = op12 + op13;        
    op15 = op14 + z4(i);        
    op16 = op15*h;              
    z1(i+1) = z1(i) + op16;     % Listo
    
    
    op21 = b - z3(i);
    op22 = op21*z1(i);
    op23 = c*z4(i);
    op24 = op22 + op23;
    op25 = op24*h;              
    z2(i+1) = z2(i) + op25;     % Listo


    op31 = z1(i)*z1(i);
    op32 = z1(i)*z2(i); 
    op33 = op31 + op32;
    op34 = d*z3(i);
    op35 = op33 - op34;
    op36 = op35*h;
    z3(i+1) = z3(i) + op36;    % listo

    op41 = z5(i) - z2(i);
    op42 = op41*h;
    z4(i+1) = z4(i) + op42;  % Listo

    op51 = z5(i)*h;
    z5(i+1) =z5(i) - op51;

    data(i,:) = [z1(i+1),z2(i+1),z3(i+1),z4(i+1),z5(i+1),op11,op12,op13,op14,op15,op16,op21,op22,op23,op24,op25,op31,op32,op33,op34,op35,op36,op41,op42,op51];
end

% f = figure; f.Position(1:2) = [800 800]; % [right bottom]
subplot(2,2,1); plot(z1,z2); grid on; grid minor;
subplot(2,2,2); plot(z2,z3); grid on; grid minor;
subplot(2,2,3); plot(z3,z4); grid on; grid minor;
subplot(2,2,4); plot(z1,z4); grid on; grid minor;

check_max = max(data,[],'all');
check_min = min(data,[],'all');

toc
% Nota algo de suma importancia que acabo de notar es que dependiendo del 
% orden de las operaciones cambia el resultado, si realizamos primero la
% suma del parametro que tiene d z z2z3 el resultado cambia ligeeramente.
% 20,43