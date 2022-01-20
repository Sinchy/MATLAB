function is_bubble = CheckStereomatch(img1, img2, img3, particles)
fh = figure();
fh.WindowState = 'maximized';
is_bubble = zeros(size(particles, 1), 1);
for i = 1 : size(particles, 1)
    subplot(2, 2, 1)
    imshow(img1)
    viscircles(particles(i, 5:6) + [1 1], particles(i, 11), 'LineWidth', 0.5);
    subplot(2, 2, 2)
    imshow(img2)
    viscircles(particles(i, 7:8) + [1 1], particles(i, 12), 'LineWidth', 0.5);
    subplot(2, 2, 3)
    imshow(img3)
    viscircles(particles(i, 9:10) + [1 1], particles(i, 13), 'LineWidth', 0.5);
    %answer = inputdlg(['The error is' num2str(particles(i, 4)) '. Is it a right bubble?']);
    answer  = input(['The error is' num2str(particles(i, 4)) '. Is it a right bubble?']);
    is_bubble(i) = str2double(answer);
end
end

