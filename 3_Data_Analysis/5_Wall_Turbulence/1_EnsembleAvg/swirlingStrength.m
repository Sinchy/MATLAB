function [Lambda,Vorticity] = swirlingStrength(dx,dy,U,V)
% Function to calculate the "Stereo" Swirling Strength. It takes the
% Velocity Gradient Tensor for each grid point and find the imaginary
% part of the eigenvalues of the local Velocity Gradient Tensor (Zhou et al
% 1999)
%
% OBS:
% U and V should be the in-plane Velocity
% dU/dx should be varing in the horizontal direction (across colums)
% dU/dy should be varing in the vertical direction (across rows)
%
% Outputs:
% Lambda = Signed imaginary part of the eigenvalues of the local Velocity
% Gradient Tensor
%
% Author: Julio Barros
% University of Illinois at Urbana-Champaign

% Find the Gradients using Matlab function
[dUdx, dUdy] = gradient(U,dx,dy);
[dVdx, dVdy] = gradient(V,dx,dy);

% My function for the Velocity Tensor
%[dUdx,dUdy,dVdx,dVdy,dWdx,dWdy] = velocityTensor3D(U,V,W,dx,dy);

% Initialize the lambda matrix
lambda = zeros(size(U));
for i=1:size(U,1)
    for j=1:size(U,2)
        Vel_tensor = [dUdx(i,j) dVdx(i,j);...
                      dUdy(i,j) dVdy(i,j)];
        d = eig(Vel_tensor);
        lambda(i,j) = abs(imag(d(2,1)));
    end
end

Vorticity = dVdx - dUdy;
Lambda = lambda.*(Vorticity./abs(Vorticity));
