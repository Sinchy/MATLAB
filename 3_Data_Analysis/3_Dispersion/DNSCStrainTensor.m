function eigen_values = DNSCStrainTensor(size, num_points)
addpath D:\0.Code\MATLAB\2_Data_Extraction\5_GetDataFromJHU\JohnsHopkins_database_matlab_codes;
authkey = 'edu.yale.nicholas.ouellette-b0c68942';
dataset = 'isotropic1024coarse';
Lag4 = 'Lag4';
PCHIPInt = 'PCHIP';
FD4Lag4 = 'FD4Lag4';
VG = Coarse_grained_velocity_gradient;

% num_points = 500;
pos = rand(num_points, 3) * 2 * pi; 
time = rand(num_points, 1) * 10;
eigen_values = zeros(num_points, 3);

for i = 1 : num_points
    npoints = 100;
    points = (rand(npoints, 3) - 1/2 * ones(1, 3)) * size + pos(i,:);
    count = 0;
    err_count = 0; 
    while count == err_count % if fail to obtain vel, then try again.
        try 
            vel = getVelocity(authkey, dataset, time, Lag4, PCHIPInt, npoints, points');
        catch
            err_count = err_count + 1;
            if err_count > 5 % if 5 attempts have been made, then give up and exit. 
                break;
            end
        end
        count = count + 1;
    end

    if err_count > 5
        warning('Fail to obtain velocity from JHTDB.');
%         break;
    end

     points(:, 6:8) = vel';
     du_dx = VG.Cal_CGVG_LSF(points, pos(i, :), size);
     if sum(du_dx(:)) == 0
         warning('Particles are not uniformly distributed.');
            break; % if du_dx cann't be calculated, then it can't be calculated for the previous frames
%          break;
     end
     
    strain = VG.StrainRate(du_dx);
    [~, D] = eig(strain, 'vector');
    eigen_values(i, :) = D';       
end

end

