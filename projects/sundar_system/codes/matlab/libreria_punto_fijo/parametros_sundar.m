clear; close all; clc;

format longG
param = [40.0, 28.0, 4.0, 7.0, 0.001];
text = ["a","b","c","d","h"];

for i = 1:size(param,2)
    a = dectobin(param(i),11,52);
    aStr = sprintf('%d', a);
    aReal = bintodec(a,11,52);
    fprintf(' %s <= "%s";\t -- %5.3f \n',text(i),aStr,aReal);
end

param = [0.1 0.1 0.1 0.1];
text = ["w0","x0","y0","z0"];

for i = 1:size(param,2)
    a = dectobin(param(i),11,52);
    aStr = sprintf('%d', a);
    aReal = bintodec(a,11,52);
    fprintf(' %s <= "%s";\t -- %5.3f \n',text(i),aStr,aReal);
end

