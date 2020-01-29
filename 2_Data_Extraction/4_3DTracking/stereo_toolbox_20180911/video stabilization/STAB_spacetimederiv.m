%%% SPACE/TIME DERIVATIVES
function[ fx, fy, ft ] = STAB_spacetimederiv( f1, f2 )
%%% DERIVATIVE FILTERS
pre = [0.5 0.5];
deriv = [0.5 -0.5];
%%% SPACE/TIME DERIVATIVES

fpt = pre(1)*f1 + pre(2)*f2; % pre-filter in time
fdt = deriv(1)*f1 + deriv(2)*f2; % differentiate in time
fx = conv2( conv2( fpt, pre', 'same' ), deriv, 'same' );
fy = conv2( conv2( fpt, pre, 'same' ), deriv', 'same' );
ft = conv2( conv2( fdt, pre', 'same' ), pre, 'same' );


