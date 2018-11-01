function watermark = getWatermark(old, entropy, new, alpha, watSize)
    watermark = zeros(1024, watSize);
    for i = 1:(1024 * watSize)
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
    if watSize == 1
        watermark = watermark';
    else
        watermark = mean(watermark');
    end
end