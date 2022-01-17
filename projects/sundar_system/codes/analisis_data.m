clear all; close all; clc;
data = load("salida.txt");
x = data(:,1);
y = data(:,2);
plot(x,y)