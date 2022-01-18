clear; close all; clc;

format longG
an= [-0.6, -0.1, 1.1, 0.2, -0.8, 0.6, -0.7, 0.7, 0.7, 0.3, 0.6, 0.9];  %M1

for i = 1:size(an,2)
    a = dectobin(an(i),3,60,'round');
    aStr = sprintf('%d', a);
    aReal = bintodec(a,3,60);
    fprintf(' an_%d <= "%s";\t -- %2.1f \n',i,aStr,aReal);
end
