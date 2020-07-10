function [exponent_D, exponent_VL] = DispersionIntermittentModel(D, h)

for i = 1 :10
   exponent_D(i) = min((i + 3 - D)./(1 - h)); 
   exponent_VL(i) = min((i * h - D + 3) ./ (1 - h));
end
end

