function R = A1C(binvec)
    R = zeros(size(binvec));
    for i = 1:length(binvec)
        if binvec(i) == 1
            R(i) = 0;
        else 
            R(i) = 1;
        end
    end
end