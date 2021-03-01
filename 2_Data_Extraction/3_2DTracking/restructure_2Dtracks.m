function tracks = restructure_2Dtracks(vtracks)
    
% Input: Vtracks: It is a structure with X,Y,U,V,T,Theta for each track
% OutputL tracks: trkID, X, Y, frameID, U, V

    tracks = zeros(1,6);
    for i = 1:size(vtracks,1)
        nrows = vtracks(i).len;
        if nrows < 6
            continue;
        end
        
        dummy = repmat(i,[nrows,1]);
        dummy(:,2) = vtracks(i).X;
        dummy(:,3) = vtracks(i).Y;
        dummy(:,4) = vtracks(i).T;
        dummy(:,5) = vtracks(i).U;
        dummy(:,6) = vtracks(i).V;
        tracks = [tracks;dummy];
    end
    
    tracks(1,:) = [];
end