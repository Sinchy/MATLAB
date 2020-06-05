function [outputArg1,outputArg2] = PairTraceBack(data_map, pairs, backframe)
num_pair = size(pairs, 1);
trackID = unique([pairs(:,1); pairs(:,2)]);
tracks = GetSpecificTracksFromData(data_map, trackID);

for i = 1 : num_pair
    
end
end

