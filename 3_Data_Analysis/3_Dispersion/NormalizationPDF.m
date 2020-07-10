function [xx, pp] = NormalizationPDF(x, p)
num_pdf = size(p, 1);
% figure;
for i = 1 : num_pdf
   p = p / trapz(x, p(i,:));
   x_mean = trapz(x, x .* p(i,:));
   
%    plot(x / x_mean, x_mean * p(i,:));
end
xx = x / x_mean;
pp = x_mean * p(i,:);
end

