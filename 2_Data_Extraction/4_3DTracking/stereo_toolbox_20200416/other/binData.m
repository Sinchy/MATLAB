function [ whichBin, binEdges ] = binData( x, botEdge, topEdge, nBins )
% usage: 
% This function puts the data into the right of nBins bins and returns the
% number of
binEdges = linspace(botEdge, topEdge, nBins+1);

if (x>topEdge | x<botEdge)
    error('Data out of bin-range');
end



[~, whichBin] = histc(x, binEdges); % usual case
if any(x == topEdge) % is one member the top edge?
    whichBin(x==topEdge) = nBins; % set manually.
end

end

