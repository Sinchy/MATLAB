function [ fit_params ] = traj_fitDampedDistr( v_z, init_params, vel_range, doShow)
%
% [ fit_params ] = traj_fitDampedDistr( v_z, init_params, vel_range, doShow)
% This function fits the damped harmonic oscillator function (defined
% inside this file) to the given v_z-distribution.
%
% v_z:          velocities to compute
% init_params:  initial parameters for the nonlin-fit.(e.g.[1 1 1 100])
% vel_range:    velocity_range to consider (outside values are dropped)
% doShow:       if not set to zero, a plot of the distribution and the fit
%               is shown. Parameter is optional. Default is 1.
% fit_params:   array of fitted parameters [ amplitude, omega, beta ]

% mlint message suppression
%#ok<*AGROW>   
%#ok<*TRYNC>

%--------------------------------------------------------------------------
%     Copyright (C) 2016 Michael Himpel (himpel@physik.uni-greifswald.de)
%     
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

% drop velocities outside vel_range
v_z(v_z<min(vel_range) | v_z>max(vel_range)) = [];

% compute histogram
[Nz, Xz] = hist(v_z,vel_range);

% start optimization
options = optimset('TolFun', 1e-15, 'TolX', 1e-14, 'MaxFunEvals', 100000, 'MaxIter', 100000,'Display', 'off');%, 'Algorithm','levenberg-marquardt');
fit_params = lsqcurvefit(@DampedDistrZ, init_params,Xz, Nz, [0 0 0 -Inf], [], options);

% show plot if desired
if doShow
    figure;
    hist(v_z, vel_range ); hold on;
    plot( interp(Xz,10), DampedDistrZ(fit_params, interp(Xz,10)),'-r', 'LineWidth',2);
end

if doShow
    fprintf(1,'Fit Results:\n');
    fprintf(1,' Amp*omega | Amp*beta  | shift \n');
    fprintf(1,' %+06.1f    | %+06.1f    | %+06.1f \n', fit_params(1), fit_params(2), fit_params(4));
end
end


%% ----------------- LOCAL FUNCTIONS --------------------------------------

function [ y ] = DampedDistrZ(params, x)
% fit-function prototype
% params: amplitude, omega, beta
% A = params(1);
% omega = params(2) + 1i*params(3); % imaginary includes friction!
% scale = params(4);
% shift = params(5);
Aomega = params(1) + 1i*params(2); % imaginary includes friction!
scale = params(3);
shift = params(4);
try 
    mu = params(5);
    sigma = params(6);
end

% x is not (pure) velocity need for correction!

if numel(params) == 6
    y = pdf('norm',x, mu, sigma) .* abs( scale* 1./ (   pi()*sqrt((Aomega)^2 - x.^2  )   )) ;
elseif numel(params) == 4
    y = abs( scale* 1./ (   pi()*sqrt((Aomega)^2 - (x-shift).^2  )   )) ;
end


end
