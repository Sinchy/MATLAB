classdef Coarse_grained_velocity_gradient
    %COARSE_GRAINED_VELOCITY_GRADIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data_map
    end
    
    methods
%         function obj = Coarse_grained_velocity_gradient(inputArg1,inputArg2)
%             %COARSE_GRAINED_VELOCITY_GRADIENT Construct an instance of this class
%             %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
%         end
        
        function du_dx = Cal_CGVG(~, particles, x, filter_length)
            % calculate the coarse-grained velocity gradient at position x
            % at frame.
            % NOTE: all the unit in data_map and filter_length should be in
            % mm.
            % get particles at frame
            % particles = obj.data_map.Data.tracks(obj.data_map.Data.tracks(:, 4) == frame, :);
            % find particles within sphere of filter length around x
            particles = particles(abs(particles(:, 1) - x(1)) < filter_length / 2 & ...
                abs(particles(:, 2) - x(2)) < filter_length / 2 & ...
                abs(particles(:, 3) - x(3)) < filter_length / 2, :);
            dist = vecnorm(particles(:, 1:3) - x, 2, 2);
            particles = particles(dist < filter_length / 2, :);
     
            num_particles = size(particles, 1);
%             if num_particles <= 1
%                 fprintf('No particle is found\n');
%                 du_dx = zeros(3, 3);
%                 return;
%             elseif num_particles < 20
%                 fprintf('Number of particles may not be enough\n');
%             end
            if num_particles <= 20 %|| ParticleDistributionCheck(obj, particles(:, 1:3)) < 0.1
                fprintf('Number of particles may not be enough\n');
                du_dx = zeros(3, 3);
                return;
            end
            u = mean(particles(:, 6:8));
            x = mean(particles(:, 1:3));       
            A = zeros(3, 3);
            for i = 1 : 3
                for j = 1 : 3
                    A(i, j) = 20 / (num_particles - 1) / filter_length ^2  * ...
                        sum( (particles(:, j) - x(j)) .* ( particles(:, 5 + i) - u(i)) );
                end
            end
            tr_A = A(1, 1) + A(2, 2) + A(3, 3);
            du_dx = A;
            for i = 1 : 3
                du_dx(i, i) = du_dx(i, i) - 1/3 * tr_A;
            end
        end
        
        function du_dx = Cal_CGVG_LSF(obj, particles, x, filter_length)
            % least square fit of velocity gradient tensor
            particles = particles(abs(particles(:, 1) - x(1)) < filter_length / 2 & ...
                abs(particles(:, 2) - x(2)) < filter_length / 2 & ...
                abs(particles(:, 3) - x(3)) < filter_length / 2, :);
            dist = vecnorm(particles(:, 1:3) - x, 2, 2);
            pts = particles(dist < filter_length / 2, :);
            np = size(pts, 1);
            pts = pts - mean(pts);
            
           if np<= 20 || ParticleDistributionCheck(obj, pts(:, 1:3)) < 0.1 % 30-40 particles would be good. 
%                 fprintf('Number of particles may not be enough\n');
                du_dx = zeros(3, 3);
                return;
            end

            A(1:3:3*np,1) = pts(:,1);
            A(1:3:3*np,2) = pts(:,2);
            A(1:3:3*np,3) = pts(:,3);


            A(2:3:3*np+1,4) = pts(:,1);
            A(2:3:3*np+1,5) = pts(:,2);
            A(2:3:3*np+1,6) = pts(:,3);

            A(3:3:3*np+2,7) = pts(:,1);
            A(3:3:3*np+2,8) = pts(:,2);
            A(3:3:3*np+2,9) = pts(:,3);

            b(1:3:3*np) = pts(:,6);
            b(2:3:3*np+1) = pts(:,7);
            b(3:3:3*np+2) = pts(:,8);

            du_dx = A\b';
            
            du_dx = reshape(du_dx, [3 3]);
            tr_dudx= du_dx(1, 1) + du_dx(2, 2) + du_dx(3, 3);
            for i = 1 : 3
                du_dx(i, i) = du_dx(i, i) - 1/3 * tr_dudx;
            end
        end
        
        function du_dx_field = Cal_CGVG_field(obj, frame, filter_length)
            particles = obj.data_map.Data.tracks(obj.data_map.Data.tracks(:, 4) == frame, :);
            max_x = max(particles(:, 1)); min_x = min(particles(:, 1));
            max_y = max(particles(:, 2)); min_y = min(particles(:, 2));
            max_z = max(particles(:, 3)); min_z = min(particles(:, 3));
            
            x_grid =min_x + filter_length / 2 : filter_length/10 : max_x - filter_length / 2;
            y_grid =min_y + filter_length / 2 : filter_length/10 : max_y - filter_length / 2;
            z_grid =min_z + filter_length / 2 : filter_length/10 : max_z - filter_length / 2;
            
            n_x = length(x_grid);
            n_y = length(y_grid);
            n_z = length(z_grid);
            du_dx_field = zeros(n_x * n_y * n_z, 12);
            for i = 1 : n_x
                for j = 1 : n_y
                    for k = 1 : n_z
                        du_dx = Cal_CGVG(obj, particles, [x_grid(i), y_grid(j), z_grid(k)], filter_length);
                        du_dx_field( (i - 1)* n_y * n_z+ (j - 1)* n_z+ k, :) = [x_grid(i), y_grid(j), z_grid(k), reshape(du_dx, [1 9])];
                    end
                end
            end
        end
        
        function du_dx_field = Cal_CGVG_field2(obj, particles, filter_length, domain_size)
%             particles = obj.data_map.Data.tracks(obj.data_map.Data.tracks(:, 4) == frame, :);
            if ~exist('domain_size', 'var')
                max_x = max(particles(:, 1)); min_x = min(particles(:, 1));
                max_y = max(particles(:, 2)); min_y = min(particles(:, 2));
                max_z = max(particles(:, 3)); min_z = min(particles(:, 3));
            else
                min_x = domain_size(1,1); max_x = domain_size(1,2);
                min_y = domain_size(2,1); max_y = domain_size(2,2);
                min_z = domain_size(3,1); max_z = domain_size(3,2);
            end
            
            x_grid =min_x + filter_length / 2 : filter_length : max_x - filter_length / 2;
            y_grid =min_y + filter_length / 2 : filter_length : max_y - filter_length / 2;
            z_grid =min_z + filter_length / 2 : filter_length : max_z - filter_length / 2;
            
            n_x = length(x_grid);
            n_y = length(y_grid);
            n_z = length(z_grid);
            du_dx_field = zeros(n_x * n_y * n_z, 12);
%             h = waitbar(0, 'processing...');
            for i = 1 : n_x
                for j = 1 : n_y
                    for k = 1 : n_z
%                         waitbar( ((i - 1)* n_y * n_z+ (j - 1)* n_z+ k) / ( n_x * n_y * n_z), h, 'processing...');
                        du_dx = Cal_CGVG_LSF(obj, particles, [x_grid(i), y_grid(j), z_grid(k)], filter_length);
                        du_dx_field( (i - 1)* n_y * n_z+ (j - 1)* n_z+ k, :) = [x_grid(i), y_grid(j), z_grid(k), reshape(du_dx, [1 9])];
                    end
                end
            end
        end
        
        function s = MeanStrain(obj, du_dx_field)
            % transpose du_dx in 1D
            du_dx_field_T = du_dx_field(:, [4     7    10     5     8    11     6     9    12]);
            % strain rate:
            s_field = 1/2 * (du_dx_field(:, 4:12) + du_dx_field_T);
            % strain square
            s_square = vecnorm(s_field, 2, 2) .^2;  % works for only symmetric tensor
            % mean strain
            s = mean(nonzeros(s_square));
        end
        
        function w = Entrophy(~, du_dx_field)
            % transpose du_dx in 1D
            du_dx_field_T = du_dx_field(:, [4     7    10     5     8    11     6     9    12]);
            % strain rate:
            w_field = 1/2 * (du_dx_field(:, 4:12) - du_dx_field_T);
            % entrophy
            w_square = vecnorm(w_field, 2, 2) .^2 * 2;
            % mean entrophy
            w = mean(nonzeros(w_square));            
        end
        
        function RQ= Invariant_field(obj, du_dx_field)
            np = size(du_dx_field, 1);
            RQ = zeros(np, 2);
            for i = 1 : np
                du_dx = reshape(du_dx_field(i, 4:12), [3 3]);
                [R, Q]= Invariant(obj, du_dx);
                s = 1/2 * ( du_dx + du_dx') .^ 2;
                s = sum(s(:));
                RQ(i, :) = [R / s ^ (3/2), Q / s];
            end
        end
        
        function [R, Q] = Invariant(obj, du_dx)
            % Hugh M. Backburn, Nagi N. Mansour, Brain J. Cantwell, 1996,
            % JFM
            R = - det(du_dx);
            Q = 1/2 * ( (trace(du_dx)) ^ 2 - trace(du_dx * du_dx));
        end
        
        function w = Vorticity(~, du_dx)
            w = [du_dx(3,2) - du_dx(2, 3), du_dx(1,3) - du_dx(3, 1), du_dx(2, 1) - du_dx(1, 2)];
        end
        
        function a = VorticityStrainAllignment(obj, du_dx_field)
            np = size(du_dx_field, 1);
            a = zeros(np, 3);
            for i = 1 : np
                du_dx = reshape(du_dx_field(i, 4:12), [3 3]);
                s = StrainRate(obj, du_dx);
                [V, D] = eig(s, 'vector');
                w = Vorticity(obj, du_dx);
                for j = 1 : 3
                    a(i, j) = dot(w,V(:, j))/(norm(w)*norm(V(:, j)));
                end
            end
        end
        
        function s = StrainRate(~, du_dx)
            s = 1/2 * (du_dx + du_dx');
        end
        
        function r = RotationRate(~, du_dx)
            r = 1/2 * (du_dx - du_dx');
        end
        
        function C = double_dot(~, A, B)
            assert(~isvector(A) && ~isvector(B))
            idx = max(0, ndims(A) - 1);
            B_t = permute(B, circshift(1:ndims(A) + ndims(B), [0, idx - 1]));
            C = sum(squeeze(sum(squeeze(sum(bsxfun(@times, A, B_t), idx)), idx)));
        end
        
        function D = double_dot2(~, A, B, C)
            D = 0;
            for i = 1 : 3
                for j = 1 : 3
                    for k = 1 : 3
                        D = D + A(i, j) * B(j, k) * C(k, i);
                    end
                end
            end
        end
        
        % check the uniformibility of particles
        function shape = ParticleDistributionCheck(~, p)
            % NOTE: p is the relative position to the investigated
            % particles
            
%             x=p(:,1);y=p(:,2);z=p(:,3);
% 
%             s1(1:3:3*length(x)-2,1:3)=[x y z];
%             s1(2:3:3*length(x)-1,1:3)=[x y z];
%             s1(3:3:3*length(x),1:3)=[x y z];
%             s2(1:3:3*length(x)-2,1:3)=[x x x];
%             s2(2:3:3*length(x)-1,1:3)=[y y y];
%             s2(3:3:3*length(x),1:3)=[z z z];
%             s_dum=s1.*s2;
%             s=zeros(3,3,length(x));
%             for i=1:length(x)
%                 s(:,:,i)=s_dum(3*(i-1)+1:3*i,1:3);    
%             end
%             s=sum(s,3);
% 
%             [~,eig_d]=eig(s);
%             shape=min(diag(eig_d))/max(diag(eig_d));

            g = zeros(3,3);
            for i = 1 : 3
                for  j = 1 :3
                    g(i, j) = sum(p(:, i) .* p(:,j));
                end
            end
            g = g / trace(g);
            [~,eig_d]=eig(g);
            shape=min(diag(eig_d))/max(diag(eig_d));
        end
    end
end

