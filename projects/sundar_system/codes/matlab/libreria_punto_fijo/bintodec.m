function R = bintodec(binvec,a,b)
    % a: parte entera   b: parte decimal
    % NOTA: numero de bits es a + b + 1, el bit extra es el bit de signo
    
    % A2C si negativo
    flag = 0;
    if binvec(1) == 1  
        binvec =  A2C(binvec);
        flag = 1;
    end
    % Parte entera
    sum = 0;
    idx = a;      
    for i = 1:a+1  
        sum = sum + binvec(i)*2^(idx);
        idx = idx - 1;
    end
    % Parte decimal
    idx = 1;
    for i = a+2:a+b+1
        sum = sum + binvec(i)*2^(-idx);
        idx = idx + 1;
    end
    % Agregar signo menos
    if flag == 1  
        R = -sum;
    else
        R = sum;
    end
        
end