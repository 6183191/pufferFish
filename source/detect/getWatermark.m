function watermark = getWatermark(old, entropy, new, alpha)
    watermark = zeros(1,1024);
    for i = 1:1024
        index = entropy.indexes(i);
        oldPixel = old.flat(index);
        newPixel = new.flat(index);
        pixelEntropy = entropy.sorted(i);
        entropyStrength = (pixelEntropy - entropy.min)/entropy.size;
        if(oldPixel > 127.5)
            entropyStrength = -1 * entropyStrength;
        end
        strength = entropyStrength * alpha;
        watermark(i) = (newPixel - oldPixel)/(strength * oldPixel);
    end
end