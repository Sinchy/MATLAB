%%% BLUR AND DOWNSAMPLE (L times)
function[ f ] = STAB_down( f, L )
blur = [1 2 1]/4;
for k = 1 : L
    f = conv2( conv2( f, blur, 'same' ), blur', 'same' );
    f = f(1:2:end,1:2:end);
end


