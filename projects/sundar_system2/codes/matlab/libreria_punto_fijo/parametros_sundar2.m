clear; close all; clc;

format longG
param = [40.0, 90.0, 16.0, 15.0, 0.0001];
text = ["a","b","c","d","h"];

for i = 1:size(param,2)
    a = dectobin(param(i),15,48);
    aStr = sprintf('%d', a);
    aReal = bintodec(a,15,48);
    fprintf('    %s <= "%s";\t -- %5.4f \n',text(i),aStr,aReal);
end

param = [1.0 1.0 1.0 1.0 1.0];
text = ["z1_0","z2_0","z3_0","z4_0","z5_0"];

for i = 1:size(param,2)
    a = dectobin(param(i),15,48);
    aStr = sprintf('%d', a);
    aReal = bintodec(a,15,48);
    fprintf(' %s <= "%s";\t -- %5.4f \n',text(i),aStr,aReal);
end

