function [R, position] = CrossCorrelationImage(img, nx, ny, Am, rm, thred)
[Npixw, Npixh] = size(img);
img = double(img);
R = zeros(Npixw, Npixh);

position = [];
for i = 1 : Npixw
    for j = 1 : Npixh
        R(i, j) = ImageCrossCorrelation(img, i, j, nx, ny, Am, rm);
        if R(i, j) < thred 
            R(i, j) = 0;
        else
            position = [position; j,i];
        end
    end
end

end


