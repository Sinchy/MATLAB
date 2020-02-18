function DynamicPlotPDFDispSpeed(disp_matrix, t)
figure
for i = 1 : t
[PDF, ~] = GetDispersionSpeedPDF(disp_matrix, i);
plot(PDF(:, 2), PDF(:,1))
pause(0.5);
end
end

