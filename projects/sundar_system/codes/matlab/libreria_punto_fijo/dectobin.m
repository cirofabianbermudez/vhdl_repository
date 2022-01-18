function R = dectobin(decnum,a,b,modo)
    % a: parte entera   b: parte decimal
    % NOTA: numero de bits es a + b + 1, el bit extra es el bit de signo
    
    % Separamos parte entera de parte fraccionaria
    % modo: trunc o  round
    
    if ~exist('modo','var')
        modo = 'trunc'; % third parameter does not exist, so default it to something
    else
        if ~ischar(modo) || ~(strcmp(modo,'trunc') || strcmp(modo,'round') ) % si no es char
            msg = "Error occurred. \nFourth argument must be a word, 'trunc' or 'round' not a '%s'.";
            error(msg,modo);
        end
    end
    
    if decnum < 0
       signo = 1;
       decnum = abs(decnum);
    else 
        signo = 0;
    end 

%     fprintf("Modo: %s\n",modo);
    integ = fix(decnum);
    fract = abs(decnum - integ);
%     fprintf("Entera = %d, Fraccion = %f\n",integ,fract);
    Rt = zeros(1,a+b+2);

    for i = a+1:-1:2
        Rt(i) = mod(integ,2);
        integ = fix(integ/2);
%         fprintf("%d, %d\n",integ,Rt(i));
    end

    for i = a+2:1:a+b+2
        mult = fract*2;
        Rt(i) = fix(mult);
        fract = abs(mult - Rt(i));
%         fprintf("%f, %d\n",mult,Rt(i));
    end
    
    if strcmp(modo,'round')
        if Rt(end) == 1
            uno = [ zeros(1,b-1) 1 ];
            Rt(a+2:a+b+1) = suma_bin( Rt(a+2:a+b+1), uno );
        end
    end
    
    R = Rt(1:end-1);
    if  signo == 1
      R = A2C(R);
    end 
    
end


