function [ tracks, discontinuedTracks ] = STB_sortOutIntensity( tracks, discontinuedTracks, STB_params )
%STB_SORTOUTINTENSITY Summary of this function goes here
%   Detailed explanation goes here
       allIntensities = STB_getIntensities( tracks );
       
       %means = mean(allIntensities,1);
       % better to use fixed threshold?
       means = STB_params.lowerIntensityThreshold;
       deleteIdx = [];
       
       for k = 1:size(tracks,2)
            isAwayLow  = (tracks(k).intensities(end,:) < means);
            
          %  isAwayHigh = (tracks(k).intensities(end,:) > 2.5*means);
            if nnz(isAwayLow)>1 % when in at least 2 cameras below threshold, discontinue track
              deleteIdx(k) = 1;
            end

       end
       
       discontinuedTracks = [ discontinuedTracks , tracks(logical(deleteIdx)) ];
       tracks(logical(deleteIdx)) = [];
       
end

