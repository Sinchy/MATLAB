function X2D = Distort(x2D,camParaCalib) 
    
    kr = camParaCalib.k1;
    x = x2D(:,1); y = x2D(:,2);
    rad = 1 + kr .* (x.^2 + y.^2);
	X = x./(rad*0.02)+512;
    Y = -y./(rad*0.02)+512;
    
    X2D = [X Y];

end