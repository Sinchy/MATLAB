function d = dist2line2d(p, l)
% DIST2LINE2D  Compute the distance of a point to a line in 2D
%
%   D = DIST2LINE2D(P, L) returns the shortest distance of the point P = (x,y)
%   to the line L = (m,b) with f(x) = m*x+b. P may be an Nx2 array of points,
%   with x-coordinates in the first column and y-coordinates in the second. D is
%   then a Nx1 vector of the corresponding distances to the line L.

%                                                            created: 15.02.2011
% ------------------------------------------------------------------------------

    % coordinates of P
    x0 = p(:,1);  y0 = p(:,2);
    % slope and y-intercept of L
    m = l(1);   b = l(2);
    
    % normal line L_nrm (perpendicular to L and passing through P)
    m_nrm = -1/m;
    b_nrm = y0 - x0.*m_nrm;

    % intersection point Q of L and L_nrm
    int_x = (b_nrm - b) ./ (m - m_nrm);
    int_y = m .* int_x + b;
    
    % distance of P to Q
    dists(:,1) = int_x - x0;
    dists(:,2) = int_y - y0;
    d = sqrt(dists(:,1).^2 + dists(:,2).^2);

%   this is just for debugging - do not uncomment unless you really want it!
%     figure; hold on;
%     plot(p(:,1), p(:,2), 'kx', 'linewidth', 2);
%     plot(-2:2, polyval(l, -2:2), 'r-', 'linewidth', 2);
%     for i = 1:length(b_nrm)
%         plot(-2:2, polyval([m_nrm b_nrm(i)], -2:2), 'g-', 'linewidth', 2);
%         plot(int_x(i), int_y(i), 'bs', 'linewidth', 2, 'markersize', 8);
%         text(p(i,1), p(i,2), num2str(d(i)));
%     end;
%     box on; grid on; axis equal;
%     set(gca, 'fontsize', 20, 'linewidth', 2);
