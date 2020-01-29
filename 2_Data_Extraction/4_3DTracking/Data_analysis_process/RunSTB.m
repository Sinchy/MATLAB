function RunSTB(dir)
% dir is the address of data
dir_code = '/home-4/stan26@jhu.edu/work/Code/LocalCode/ShakeTheBox/Release/';
% system(['cd ' dir_code]);
system(['module load gcc/6.4.0 &&' ...
    dir_code 'ShakeTheBox ' dir 'trackingconfig1.txt >' dir 'result1.txt << 0 << 0 &']);
end

