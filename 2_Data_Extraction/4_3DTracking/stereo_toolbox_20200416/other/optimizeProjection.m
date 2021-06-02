function [x1 x2] = optimizeProjection(m1, m2, F, disp)
%OPTIMIZEPROJECTION  Find an optimized projection of two 2D points
%
%   [X1 X2] = OPTIMIZEPROJECTION(M1, M2, F) calculates the optimized
%   projections X1, X2 of the two 2D points M1, M2 in such a way, that X1
%   and X2 have the smallest sum of squared distances to M1 and M2, and
%   fulfill the epipolar constraint (i.e., X1 lies on X2's EPL and vice
%   versa). The calculation uses the fundamental matrix F, which can be
%   created from camera matrices by using the GETFUNDAMENTAL script.
%   [X1 X2] = OPTIMIZEPROJECTION(M1, M2, F, DISP) displays some informatory
%   stuff, if DISP is set to 1. In this case, M1 and M2 have to be given in
%   homogeneous coordinates for a correct format of the output.
%
%   See also: GETFUNDAMENTAL, TRIANGULATE
%
%   References:
%     [1] Hartley & Zisserman, Multiple View Geometry in Computer Vision,
%         2nd edition, 2004 (p. 318)

%                                                       created: 16.02.2009
%                                                 last modified: 10.02.2011
% -------------------------------------------------------------------------

    % we need column vectors to follow H & Z.
    if size(m1,1) == 1, m1 = m1'; end;
    if size(m2,1) == 1, m2 = m2'; end;


    % (i)
    % transformation matrices (to take m1, m2 to the origin)
    T1 = [1 0 -m1(1);
          0 1 -m1(2);
          0 0   1   ];
    T2 = [1 0 -m2(1);
          0 1 -m2(2);
          0 0   1   ];


    % (ii)
    % transform fundamental matrix
    F = T2'\F/T1;


    % (iii)
    % find epipoles after transformation
    [~, ~, V] = svd(F); 
    e1 = V(:,end); %e1 = e1./e1(3);     % NEIN! GANZ GANZ GANZGANZGANZ FALSCH!!!

    [~, ~, V] = svd(F'); 
    e2 = V(:,end); %e2 = e2./e2(3);     % s.o.

    % normalized to e(1)^2+e(2)^2 == 1 ?
%     if (abs(e1(1)^2+e1(2)^2-1) > 1e-6) || (abs(e2(1)^2+e2(2)^2-1) > 1e-6)
%         keyboard;
%         error('Oops, wrong scaling here: |e1| = %f\t|e2| = %f', ...
%                 e1(1)^2+e1(2)^2, e2(1)^2+e2(2)^2);
%     end;


    % (iv)
    % form rotation matrices
    R1 = [ e1(1) e1(2) 0;
          -e1(2) e1(1) 0;
            0     0    1];
    R2 = [ e2(1) e2(2) 0;
          -e2(2) e2(1) 0;
            0     0    1];
    

    % (v)
    % transform fundamental matrix
    F = R2 * F * R1';
    
    % (vi)
    % assign auxiliary variables
    f1 = e1(3);    f2 = e2(3);
    a = F(2,2);    b = F(2,3);
    c = F(3,2);    d = F(3,3);

    
    % (vii)
    % form g(t) as polynomial in t: g(t) = a6 t^6 + a5 t^5 + ... + a0
    a6 = f1^4*(a*b*c^2-a^2*c*d);
    a5 = a^4 + f2^2*(2*a^2*c^2+f2^2*c^4) - f1^4*(a^2*d^2-b^2*c^2);
    a4 = 4*a^3*b + 4*f2^2*(a^2*c*d+a*b*c^2+f2^2*c^3*d) - f1^2*(f1^2*a*b*d^2-f1^2*b^2*c*d+2*a^2*c*d-2*a*b*c^2);
    a3 = 6*a^2*b^2 + 2*f2^2*(a^2*d^2+b^2*c^2+3*f2^2*c^2*d^2+4*a*b*c*d) - 2*f1^2*(a^2*d^2-b^2*c^2);
    a2 = 4*a*b^3 + 4*f2^2*(a*b*d^2+b^2*c*d+f2^2*c*d^3) - 2*f1^2*(a*b*d^2-b^2*c*d) - a*c*(a*d-b*c);
    a1 = f2^2*(2*b^2*d^2+f2^2*d^4) - a^2*d^2 + b^2*c^2 + b^4;
    a0 = b^2*c*d - a*b*d^2;
    
    % find roots (max. 6)
    r = roots([a6 a5 a4 a3 a2 a1 a0]);
    

    % (viii)
    % evaluate cost function at the REAL part of each root
    s = zeros(length(r),1);
    for i = 1:length(r)
        s(i) = geoCost(f1, f2, a, b, c, d, real(r(i)));
    end;
    % get root with the smalles geometric error
    idxMin = find(s==min(s));
    t = real(r(idxMin(1)));
    

    % (ix)
    % evaluate two epipolar lines, find point nearest to origin
    l1 = [t*f1 1 -t];                   l1 = l1./l1(3);
    l2 = [-f2*(c*t+d) a*t+b c*t+d];     l2 = l2./l2(3);
    
    min1 = [-l1(1)*l1(3) -l1(2)*l1(3) l1(1)^2+l1(2)^2];
    min1 = min1./min1(3);
    min2 = [-l2(1)*l2(3) -l2(2)*l2(3) l2(1)^2+l2(2)^2];
    min2 = min2./min2(3);
    

    % (x)
    % transform points min1, min2 back to original coordinate system
    x1 = T1\R1'*min1';    x1 = x1./x1(3);
    x2 = T2\R2'*min2';    x2 = x2./x2(3);
    
    if disp == 1
        display('Results of optimization:');
        display(sprintf('\t[%5.1f  %5.1f  %3.1f] -> [%5.1f  %5.1f  %3.1f]   (%5.3f px)', m1, x1, distance2d(m1(1:2)',x1(1:2))));
        display(sprintf('\t[%5.1f  %5.1f  %3.1f] -> [%5.1f  %5.1f  %3.1f]   (%5.3f px)', m2, x2, distance2d(m2(1:2)',x2(1:2))));
    end;
    