function [ intensities ] = STB_getIntensities( tracks )

if isempty(tracks)
    intensities = [];
    return;
end

for k = 1:size(tracks,2)
   intensities(k,:) = tracks(k).intensities(end,:); 
end

end

