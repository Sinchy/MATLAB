classdef Camera
    %CAMERA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       camParaCalib
    end
    
    methods
        function obj = Camera(camParaCalib)

            obj.camParaCalib = camParaCalib;
        end
        
        function center = Center(obj)
            center = obj.camParaCalib.Tinv;
        end
        
        %pixel unit -> physical unit
        function pos1  =UnDistort(obj, pos)
            pos1 = [pos(1) - obj.camParaCalib.Npixw/2 - obj.camParaCalib.Noffw, ...
                -pos(2) + obj.camParaCalib.Npixh/2 - obj.camParaCalib.Noffh, ...
                pos(3)];
            pos1 = pos1 .* [obj.camParaCalib.wpix, obj.camParaCalib.hpix, 0];
            pos1 =pos1 .* [1, 1, 0];
            if obj.camParaCalib.k1 ~= 0
                a = pos1(1) / pos1(2);
                pos1(2) = (1 - (1 - 4 * pos1(2)^2 * obj.camParaCalib.k1 * (a^2 + 1)) ^ .5) / ...
                    (2 * pos1(2) * obj.camParaCalib.k1 * (a^2 + 1));
                pos1(1) = a * pos1(2);
            end
        end
        
        % physical unit -> pixel unit
        function pos1 = Distort(obj, pos)
            pos = [pos(1) pos(2) 0];
            rad = 1 + obj.camParaCalib.k1 * norm(pos) ^ 2;
            pos1 = pos / rad;
%             pos1 = pos1 .* [1, 1, 0];
            pos1 = pos1 .* [1 / obj.camParaCalib.wpix, 1 / obj.camParaCalib.hpix, 0];
            pos1 = [pos1(1) + obj.camParaCalib.Npixw / 2 + obj.camParaCalib.Noffw, ...
                - (pos1(2) - obj.camParaCalib.Npixh / 2) - obj.camParaCalib.Noffh, 0];
        end
        
        % 2D position -> 3D position
        function pos1 = ImageToWorld(obj,pos)
            pos1 = pos * obj.camParaCalib.T(3) / obj.camParaCalib.f_eff;
            pos1(3) = obj.camParaCalib.T(3);
            pos1 = obj.camParaCalib.Rinv * ( pos1 - obj.camParaCalib.T);
        end
        
        % 3D position -> 2D position
        function pos1 = WorldToImage(obj,pos)
            pos1 = obj.camParaCalib.R * pos + obj.camParaCalib.T;
            pos1 = pos1 * (obj.camParaCalib.f_eff / pos1(3));
        end
        
        
    end
end

