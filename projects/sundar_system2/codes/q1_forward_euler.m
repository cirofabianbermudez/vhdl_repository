clear; close all; clc;
tic
h = 0.0001;   % Tamanio de paso   0.0003
t = 0:h:15;   % Vector de tiempo

% Parametros
a = 40.0;
b = 90.0;
c = 16.0;
d = 15.0;

z1 = zeros(size(t));   % Inicializacion de los vectores
z2 = zeros(size(t));
z3 = zeros(size(t));
z4 = zeros(size(t));
z5 = zeros(size(t));

% Asignacion de condicion inicial
ini_cond = [1.0 1.0 1.0 1.0 1.0]';    % Condiciones iniciales
z1(1) = ini_cond(1);
z2(1) = ini_cond(2);
z3(1) = ini_cond(3);
z4(1) = ini_cond(4);
z5(1) = ini_cond(5);

% Algoritmo forward euler
for i = 2:size(z1,2)
    z1(i) = z1(i-1) + z1_state(z1(i-1),z2(i-1),z3(i-1),z4(i-1),z5(i-1),a,b,c,d)*h;
    z2(i) = z2(i-1) + z2_state(z1(i-1),z2(i-1),z3(i-1),z4(i-1),z5(i-1),a,b,c,d)*h;
    z3(i) = z3(i-1) + z3_state(z1(i-1),z2(i-1),z3(i-1),z4(i-1),z5(i-1),a,b,c,d)*h;
    z4(i) = z4(i-1) + z4_state(z1(i-1),z2(i-1),z3(i-1),z4(i-1),z5(i-1),a,b,c,d)*h;
    z5(i) = z5(i-1) + z5_state(z1(i-1),z2(i-1),z3(i-1),z4(i-1),z5(i-1),a,b,c,d)*h;
end

% f = figure; f.Position(1:2) = [800 800]; % [right bottom]
subplot(2,2,1); plot(z1,z2); grid on; grid minor;
subplot(2,2,2); plot(z2,z3); grid on; grid minor;
subplot(2,2,3); plot(z3,z4); grid on; grid minor;
subplot(2,2,4); plot(z1,z4); grid on; grid minor;

check_max = max( [max(z1) max(z2) max(z3) max(z4)] )
check_min = min( [min(z1) min(z2) min(z3) min(z4)] )
toc

% Descripcion de sistema dinamico
function R = z1_state(z1,z2,z3,z4,z5,a,b,c,d)
    R = a*(z2-z1) + z2*z3 + z4;
end

function R = z2_state(z1,z2,z3,z4,z5,a,b,c,d)
    R = z1*(b-z3) + c*z4;
end

function R = z3_state(z1,z2,z3,z4,z5,a,b,c,d)
    R = z1*z1 + z1*z2 - d*z3;
end

function R = z4_state(z1,z2,z3,z4,z5,a,b,c,d)
    R = -z2 + z5;
end

function R = z5_state(z1,z2,z3,z4,z5,a,b,c,d)
    R = -z4;
end