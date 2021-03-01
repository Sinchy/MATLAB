function[X,Y] = Distort(x,y,kr) 

    rad = 1 + kr * (x^2 + y^2);
	X = x/(rad*0.02)+512;
    Y = -y/(rad*0.02)+512;

end