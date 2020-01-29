function PlotTracksV0( fig, tracks, marker, long_track_only)
[num_tracks,~,~] =size(tracks);
figure(fig);
XX = []; YY = []; ZZ = [];
for i = 1 :  num_tracks
    X = tracks(i, :, 1);
    Y = tracks(i, :, 2);
    Z = tracks(i, :, 3);

    %% delete zero points
   while(~isempty(X) && X(1) == 0 && Y(1) == 0 && Z(1) == 0)
       X(1) = []; Y(1) =[]; Z(1) = [];
   end
   while(~isempty(X) && X(end) == 0 && Y(end) == 0 && Z(end) == 0)
       X(end) = []; Y(end) =[]; Z(end) = [];
   end

   if exist('long_track_only','var')
       if long_track_only 
           if length(X) < 30
               continue; % skip short tracks
           end
       end
   end
   XX = [XX, X];
   YY = [YY, Y];
   ZZ = [ZZ, Z];
     %%
%     plot3(X, Y, Z, marker);
%     hold on
end
plot3(XX, YY, ZZ, marker);
end