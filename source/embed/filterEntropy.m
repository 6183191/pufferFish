function [entropy] = filterEntropy(image, S)
%FILTERENTROPY Summary of this function goes here
%   Detailed explanation goes here
    nhood = ones(S,S);
    center = floor(S/2)+1;
    nhood(center, center) = 0;
    entropy.matrix = entropyfilt(image.file, nhood);
    entropy.flat = reshape(entropy.matrix, 1, image.x*image.y);
    [entropy.sorted, entropy.indexes] = sort(entropy.flat, "descend");
    max = entropy.sorted(1);
    entropy.min = entropy.sorted(end);
    entropy.size = max-entropy.min;
end