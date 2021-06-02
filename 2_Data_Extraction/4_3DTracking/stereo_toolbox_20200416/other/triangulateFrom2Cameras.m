function [X, perr] = triangulateFrom2Cameras(m1, m2, P1, P2, F, disp)
%TRIANGULATE  Perform a stereo triangulation into 3D space
%
%   X = TRIANGULATE(M1, M2, P1, P2, F) triangulates the 2D points M1, M2
%   using the camera projection matrices P1, P2 (where P1 is the projection
%   matrix of the camera with the particle M1) and the fundamental matrix
%   F. The fundamental matrix can be computed using the GETFUNDAMENTAL
%   script. M1 and M2 can be given as 2-vectors or in their homogeneous
%   form. The triangulated 3D point is returned in X (in homogeneous
%   coordinates).
%
%   X = TRIANGULATE(..., DISP) displays some informatory stuff, if DISP is
%   set to 1.
%
%   [X PERR] = TRIANGULATE(...) returns the reprojection error in the 1x2-vector
%   PERR. The first element is the reprojection error (in px) in the first
%   camera, the second element the error in the second camera.
%
%   See also:
%       GETFUNDAMENTAL, OPTIMIZEPROJECTION.
%
%   References:
%     [1] Hartley & Zisserman, Multiple View Geometry in Computer Vision,
%         2nd edition, 2004 (pp. 312-318)

%                                                            created: 16.02.2009
%                                                      last modified: 07.04.2011
% ------------------------------------------------------------------------------

    % set display to OFF (default)
    if nargin < 6, disp = 0; end;

    % create homogeneous coordinate vectors, if not given
    if length(m1) ~= 3, m1(3) = 1; end;
    if length(m2) ~= 3, m2(3) = 1; end;

    % get optimized projected coordinates
    [x1 x2] = optimizeProjection(m1, m2, F, disp);
    
    if ~(isnan(x1) | isnan(x2))
        % get rows of projection matrices
        p11 = P1(1,:);    p12 = P1(2,:);    p13 = P1(3,:);
        p21 = P2(1,:);    p22 = P2(2,:);    p23 = P2(3,:);

        % compose 
        A1 = (x1(1)*p13' - p11')';
        A2 = (x1(2)*p13' - p12')';
        A3 = (x2(1)*p23' - p21')';
        A4 = (x2(2)*p23' - p22')';
        A = [A1; A2; A3; A4];

        [~, ~, V] = svd(A);

        X = V(:,4);
        X = X./X(4);
        
        if nargout == 2
            
            % reproject 3D point into cameras
            m1_rec = P1*X;    m1_rec = m1_rec./m1_rec(3);
            m2_rec = P2*X;    m2_rec = m2_rec./m2_rec(3);
            
            % calculate reprojection error
            if size(m1,1) > 1, m1 = m1'; end;
            if size(m2,1) > 1, m2 = m2'; end;
            perr = [distance2d(m1,m1_rec) distance2d(m2,m2_rec)];
            
            
            if disp == 1
                display('Triangulation results:');
                display(sprintf('\t X = [%6.3f  %6.3f  %6.3f  %3.1f]', X));
                display(sprintf('\t m1 = [%5.1f  %5.1f  %3.1f]  (was [%5.1f  %5.1f  %3.1f])', m1_rec, m1));
                display(sprintf('\t m2 = [%5.1f  %5.1f  %3.1f]  (was [%5.1f  %5.1f  %3.1f])', m2_rec, m2));
                display(' ');
            end;
            
        else
            perr = [];
        end
        
    else
        X = [NaN NaN NaN 1];
    end;
