function [pp F] = projectRay (Pdst, Psrc, x, F)
%PROJECTRAY  Projects a ray from one camera passing through a specific
%image point into another camera.
%
%   [PP F] = PROJECTRAY(PDST, PSRC, X) calculates the epipolar line
%   corresponding to the point X in camera PSRC for camera PDST. This line
%   is described by a 1st-degree polynomial (i.e. a line equation) returned
%   in PP (where the line is defined by y(x) = PP(1) * x + PP(2).
%   Each point p along the line defined by PP satisfies p'*F*x = 0, where F
%   is the fundamental matrix for projections from PSRC into PDST, and p is
%   given in homogeneous coordinates. The output parameter F contains the
%   fundamental matrix used for this projection.
%
%   See also: GETFUNDAMENTAL

%                                                            created: 15.04.2010
% ------------------------------------------------------------------------------

    if nargin < 3
        error(['In projectRay: Function call is projectRay(Pdst,Psrc,x).\n' ...
               '  All parameters must be specified!\n']);
    end;
    
    % make x a column vector, if neccessary
    if (size(x,1) < size(x,2)), x = x'; end;
    
    % transfer to homogeneous coordinates, if neccessary
    if size(x,1) < 3, x = [x; 1]; end;
    if x(3) ~= 1, x = x./x(3); end;

    % get fundamental matrix for given cameras
    if nargin < 4
        F = getFundamental(Psrc, Pdst);
%         F = vgg_F_from_P(Psrc, Pdst);
    end
    

    % get center of camera SRC
    % [K R t C] = P2KRtC(Psrc);
    % C = [C; 1];
    
    % this is the epipole in camera DST
    % e = Pdst*C; e = e./e(3);
    
    % this is the epipolar line corresponding to x
    l = F*x; l = l./l(3);
    
    % following becomes unnecessary once you know about the PLUECKER-representation of l :-)
%     % create polynomial fit for this line
%     xx = 1:640;
%     yy = e(2)-(xx-e(1))/l(2)*l(1);
%     pp = polyfit(xx, yy, 1);

	pp = [-l(1)/l(2) -1/l(2)] ;
