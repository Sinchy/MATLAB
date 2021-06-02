%%% COMPUTE MOTION
function[ A, T ] = STAB_computemotion( fx, fy, ft, roi )
[ydim,xdim] = size(fx);
[x,y] = meshgrid( [1:xdim]-xdim/2, [1:ydim]-ydim/2 );

%%% TRIM EDGES
fx = fx( 3:end-2, 3:end-2 );
fy = fy( 3:end-2, 3:end-2 );
ft = ft( 3:end-2, 3:end-2 );
roi = roi( 3:end-2, 3:end-2 );
x = x( 3:end-2, 3:end-2 );
y = y( 3:end-2, 3:end-2 );
ind = find( roi > 0 );
x = x(ind); y = y(ind);
fx = fx(ind); fy = fy(ind); ft = ft(ind);
%***** original affine transformation ***********************************************
% xfx = x.*fx; xfy = x.*fy; yfx = y.*fx; yfy = y.*fy;
% 
% M(1,1) = sum(xfx .* xfx );  M(1,2) = sum( xfx .* yfx);  M(1,3) = sum( xfx .* xfy) ;
% M(1,4) = sum( xfx .*yfy);   M(1,5) = sum( xfx .* fx);   M(1,6) = sum( xfx .* fy);
% M(2,1) = M(1,2);            M(2,2) = sum( yfx .* yfx);  M(2,3) = sum( yfx .* xfy);
% M(2,4) = sum( yfx .* yfy);  M(2,5) = sum( yfx .*fx);    M(2,6) = sum( yfx .*fy);
% M(3,1) = M(1,3);            M(3,2) = M(2,3);            M(3,3) = sum( xfy .*xfy);
% M(3,4) = sum( xfy .* yfy);  M(3,5) = sum( xfy .*fx);    M(3,6) = sum( xfy .* fy);
% M(4,1) = M(1,4);            M(4,2) = M(2,4);            M(4,3) = M(3,4);
% M(4,4) = sum( yfy .* yfy);  M(4,5) = sum( yfy .* fx);   M(4,6) = sum( yfy .* fy);
% M(5,1) = M(1,5);            M(5,2) = M(2,5);            M(5,3) = M(3,5);
% M(5,4) = M(4,5);            M(5,5) = sum( fx .* fx);    M(5,6) = sum ( fx .*fy);
% M(6,1) = M(1,6);            M(6,2) = M(2,6);            M(6,3) = M(3,6);
% M(6,4) = M(4,6);            M(6,5) = M(5,6);            M(6,6) = sum( fy .*fy);
% 
% k = ft + xfx + yfy;
% b(1) = sum( k .* xfx );     b(2) = sum( k .* yfx );
% b(3) = sum( k .* xfy );     b(4) = sum( k .* yfy );
% b(5) = sum( k .* fx );      b(6) = sum( k .* fy );

% v = inv(M) * b';
% A = [v(1) v(2) ; v(3) v(4)];

% T = [v(5) ; v(6)];
%************************************************************************************

%****** downgrading algorithm to translation-only ***********************************
M(1,1) = sum( fx .* fx);    M(1,2) = sum ( fx .*fy);
M(2,1) = M(1,2);            M(2,2) = sum(fy .* fy);
k = ft; b(1) = sum(k .* fx); b(2) = sum(k .* fy);

v = inv(M) * b';
A = [1 0 ; 0 1];
T = [v(1) ; v(2)];