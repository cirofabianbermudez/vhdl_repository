function [R, carry] = suma_bin(a,b)
    R = zeros(size(a));
    carry = 0;
    for i = length(a):-1:1
        R(i) = xor(carry , xor(a(i),b(i)));
        carry = (b(i)&carry) | (a(i)&carry) | (a(i)&b(i));
    end
end