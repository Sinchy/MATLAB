% ALIGN TWO FRAMES (f2 to f1)
function[ Acum, Tcum ] = STAB_opticalflow( f1, f2, roi, L )

f2orig = f2;
Acum = [1 0 ; 0 1];
Tcum = [0 ; 0];
for k = L : -1 : 0
    %% DOWN-SAMPLE
    f1d = STAB_down( f1, k );
    f2d = STAB_down( f2, k );
    ROI = STAB_down( roi, k );
    
    %% COMPUTE MOTION
    [Fx,Fy,Ft] = STAB_spacetimederiv( f1d, f2d );
    [A,T] = STAB_computemotion( Fx, Fy, Ft, ROI );
    T = (2^k) * T;
    [Acum,Tcum] = STAB_accumulatewarp( Acum, Tcum, A, T );
    
    %% WARP ACCORDING TO ESTIMATED MOTION
    f2 = STAB_warp( f2orig, Acum, Tcum );
end


