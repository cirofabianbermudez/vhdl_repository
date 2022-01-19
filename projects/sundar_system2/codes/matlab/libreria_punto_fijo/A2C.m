function R = A2C(binvec)
    uno = [ zeros(1,length(binvec)-1) 1 ];
    R = suma_bin( A1C(binvec), uno);
end