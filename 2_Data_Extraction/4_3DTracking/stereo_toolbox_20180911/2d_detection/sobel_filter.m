function [ Ires ] = sobel_filter( I, lNoise, lGaussian, lGain )
% this function applies sobel filtering on images, which emphasizes blurred 
% or unsharp particle projections. It is used as a helper-tool in
% do_detection_2D and particle_detection_GUI.
%
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

        I = double(I);
        h = lGain.*fspecial('sobel');
        Ihorz = imfilter(I, h);
        Ivert = imfilter(I, h');
        Ires = sqrt(Ihorz.^2 + Ivert.^2);
        % blur image:
        fgauss = fspecial('gaussian', lGaussian, lNoise);
        Ires = imfilter(Ires,fgauss);
end

