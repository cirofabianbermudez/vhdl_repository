clear; close all; clc;

% 64 bit architecture X(a,b) 
% a+b+1 = 64 bits
% 1 is for the sign bit
arch = 64;
a = 11;         % Entera
b = arch-11-a;   % Fraccionaria

format longG;
fprintf("Enteros = %d\nDecimales = %d\n",a,b);
min_range = -2^a
max_range = 2^a-2^(-b)
format short;