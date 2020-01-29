function F = getFundamental(P1, P2)
%GETFUNDAMENTAL  Compute fundamental matrix of two cameras.
%
%   F = GETFUNDAMENTAL(P1, P2) computes the fundamental matrix F of two
%   cameras specified by their camera matrices P1 and P2.
%
%   From R. Hartley and A. Zisserman:
%   Multiple View Geometry in computer vision, p244

    % camera projection matrices
    if ischar(P1), P1 = load(P1); end;
    if ischar(P2), P2 = load(P2); end;

    % pseudo-inverse of matrix 1
    P1inv = pinv(P1);

    % decompose matrix 1
    [K R t C] = P2KRtC(P1);

    % camera center in homogeneous coordinates
    C = [C; 1];

    % image of cam1 center in cam 2 (epipole)
    e2 = P2*C;
    
    % compose fundamental matrix
    f1 = skew(e2);
    f2 = P2*P1inv;
    
    F = f1*f2;
    