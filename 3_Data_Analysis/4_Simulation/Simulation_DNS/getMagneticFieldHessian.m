%
% Turbmat - a Matlab library for the JHU Turbulence Database Cluster
%   
% get*.m, part of Turbmat
%

%
% Written by:
%  
% Perry Johnson
% The Johns Hopkins University
% Department of Mechanical Engineering
% pjohns86@jhu.edu, johnson.perry.l@gmail.com
%

%
% This file is part of Turbmat.
% 
% Turbmat is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
% 
% Turbmat is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.
% 
% You should have received a copy of the GNU General Public License along
% with Turbmat.  If not, see <http://www.gnu.org/licenses/>.
%

function result = getMagneticFieldHessian(authToken, dataset, time, ...
                                          spatialInterpolation, temporalInterpolation, ...
                                          npoints, points)
%
%     Retrieve magnetic field hessian for specified 'time' and 'points'
%   
%     Input:
%       authToken = (string)
%       dataset = (string)
%       time = (float)
%       spatialInterpolation = (string)
%       temporalInterpolation = (string)
%       npoints = (integer)
%       points = (float array 3xN)
%   
%     Output:
%       result = (float array 3xN)
%     

if( size(points,1) ~= 3 || size(points,2) ~= npoints)
    
  error('Points not specified correctly.');

end

% Get the TurbulenceService object
obj = TurbulenceService;

resultStruct =  GetMagneticHessian (obj, authToken, dataset, time, ...
		spatialInterpolation, ...
		temporalInterpolation, ...
		points);

result = getVector(resultStruct.GetMagneticHessianResult.VelocityHessian);

return
