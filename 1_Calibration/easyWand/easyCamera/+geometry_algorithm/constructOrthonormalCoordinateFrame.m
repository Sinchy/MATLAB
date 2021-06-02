function M = constructOrthonormalCoordinateFrame(vector, up, bHoldUp)
% Construct an orthonormal coordinate system using a trick from computer
% graphics where the "forward" vector is known, but the "up" vector is only
% known approximately. 
%
% Returned matrix goes FROM wherever you started INTO
% the new coordinate system. Transforming with the returned
% matrix will cause the input "vector" to be transformed into the X axis
% ([1 0 0]) and Z axis ([0 0 1]).
%
% @param[in] vector - the vector that should become the new X axis
%
% @param[in] up (optional) - the (approximate) up vector. 
% default value is the Z axis ([0 0 1]). 
%
% @param[in] bHoldUp (optional) - force the input up vector to be the Z
% axis and allow the X vector to float.
%
% @return 4x4 transformation (rotation) matrix.
%

if size(vector, 2) == 1
    vector = vector';
end

if norm(vector) < .0001
    M = eye(4);
    return;
end

vector = vector/norm(vector);
if ~exist('up', 'var') || isempty(up)
    up = [0 0 1];
else
    up = up/norm(up);
end
if ~exist('bHoldUp', 'var')
    bHoldUp = false;
end


%important to normalize, since magnitude of cross product will only be 1 if
%the input vectors start out orthogonal.
out = cross3(up,vector);
out = out / norm(out);

if ~bHoldUp
    up = cross3(vector,out);
    up = up/norm(up);
else
    vector = cross3(out,up);
    vector = vector / norm(vector);
end

M = [vector(:)'; out(:)'; up(:)'];

M(4,4) = 1;
transformation = M;
if abs(det(transformation)-1.0) > 0.0001
    i = 0;
end
end

function c = cross3(a,b)
c = ([0 -a(3) a(2); a(3) 0 -a(1); -a(2) a(1) 0]*b(:))';
end
