function correctpercent = CorrectPercentage(tracks, correctness)
[num_tracks, ~, ~] = size(tracks);
correctpercent = zeros(1, num_tracks);
for i = 1 :  num_tracks
    X = tracks(i, :, 1);
    Y = tracks(i, :, 2);
    Z = tracks(i, :, 3);
    %% delete zero points
   while(X(1) == 0 && Y(1) == 0 && Z(1) == 0)
       X(1) = []; Y(1) =[]; Z(1) = [];
   end
   while(X(end) == 0 && Y(end) == 0 && Z(end) == 0)
       X(end) = []; Y(end) =[]; Z(end) = [];
   end
   correctpercent(i) = correctness(i) / length(X);
end
end
