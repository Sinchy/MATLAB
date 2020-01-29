for i = 25 : 37
    prediction = zeros(1,3);
    for j = 1 : 3
        prediction(j) = LMSWienerPredictor(wrongtrack_matrix(1 : i - 1, j),5);
    end
    figure(fig);
    plot3(prediction(1), prediction(2), prediction(3), 'g*');
    [prediction_xc, prediction_yc] = Proj2d_Int(prediction, 'VSC_calib_04.12.18.mat');
    figure('Name', ['Frame' num2str(i)], 'NumberTitle','off');
    for j = 1 : 4
        img = uint8(imread(['/home/sut210/Documents/Experiment/EXP6/Images/cam' num2str(j) 'frame' num2str(i) '.tif']));
        subplot(2,2,j);
        imshow(img);
        hold on
        plot(wrongtrack_xc(i, j), wrongtrack_yc(i, j), 'ro');
        plot(correcttrack_xc(i, j), correcttrack_yc(i, j), 'b*');
        plot(prediction_xc(j), prediction_yc(j), 'g*');
        xlim([correcttrack_xc(i, j) - 10, correcttrack_xc(i, j) + 10]);
        ylim([correcttrack_yc(i, j) - 10, correcttrack_yc(i, j) + 10]);
    end
    subplot(2,2,3);
    dist_wrong = norm(wrongtrack_matrix(i, :) - prediction);
    dist_correct = norm(correcttrack_matrix(i, :) -  prediction);
    title(['to wrong point:' num2str(dist_wrong) '; to correct point' num2str(dist_correct)]);
end
        