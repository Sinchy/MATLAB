function S = skew(v)

    if length(v) > 3
        error('Can''t compute skew matrix for more than 3 elements.');
    end;
    
    S = [     0 -v(3)  v(2);
           v(3)   0   -v(1);
          -v(2)  v(1)   0];