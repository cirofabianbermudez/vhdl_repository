function  R = sat_fun_k(x,m,s,k)
%   x vector de entrada
%   m 
%   s numero de enrollamientos

    [r,c] = size(x);
     R = zeros(r,c);
     for i = 0:s-2
         sub = 2*i-s+2;
         
             if sub == 0
                 f = @fo;
             elseif sub >0
                 f = @fh;
             else
                 f = @f_h;
             end
             
         for j = 1:r*c
            R(j) = R(j) + f(x(j),m,sub,k);
         end  
        
     end
       
end

function R = fo(x,m,h,k)
    if x < -m
        R = -1*k;
    elseif -m <= x && x <= m
        R = (x/m)*k;
    elseif x > m
        R = 1*k;
    end
end    

function R = fh(x,m,h,k)
    if x > h + m
        R = 2*k;
    elseif -m+h <= x && x <= m+h
        R = ((x-h)/m +1)*k;
    elseif x < h-m
        R = 0;
    end
end

function R = f_h(x,m,h,k)
    if x > h + m
        R = 0;
    elseif -m+h <= x && x <= m+h
        R = ((x-h)/m -1)*k;
    elseif x < h-m
        R = -2*k;
    end
end