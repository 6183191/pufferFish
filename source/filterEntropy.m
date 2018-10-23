function [min, size, entropyMatrix,  entropySorted, entropyIndexes] = filterEntropy(image, S, dimx, dimy)
%FILTERENTROPY Summary of this function goes here
%   Detailed explanation goes here
    nhood = ones(S,S);
    center = floor(S/2)+1;
    nhood(center, center) = 0;
    entropyMatrix = entropyfilt(image, nhood);
    entropyFlat = reshape(entropyMatrix, 1, dimx*dimy);
    [entropySorted, entropyIndexes] = sort(entropyFlat, "descend");
    maxEnt = entropySorted(1);
    min = entropySorted(end);
    size = maxEnt-min;
end