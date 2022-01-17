clear; close all; clc;

% 32 bit architecture X(a,b) 
% a+b+1 = 32 bits
% 1 is for the sign bit
a = 10; 
b = 64-1-a; 

format longG;
fprintf("Enteros = %d\nDecimales = %d\n",a,b);
min_range = -2^a
max_range = 2^a-2^(-b)
format short;