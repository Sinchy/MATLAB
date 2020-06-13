function NormalizationPDF(x, p)
num_pdf = size(p, 1);
figure;
for i = 1 : num_pdf
   x_mean = trapz(x, x .* p(i,:));
   plot(x / x_mean, x_mean * p(i,:));
end
end

