function [watImage] = embed(resource, watermarkResource, alpha, S)
%get image
    image.file = imread(resource);
    [image.x, image.y] = size(image.file);
    image.double = double(image.file);
    
%get watermark
    watermark.size = 1024;
    wTemp = open(watermarkResource);
    watermark.file = wTemp.w;
    watermark.flat = reshape(watermark.file, 1, watermark.size);
    
%get entropy
    entropy = filterEntropy(image, S);
    
%apply watermark
    watImage = reshape(image.double, 1, image.x*image.y);
    for i = 1:watermark.size
        index = entropy.indexes(i);
        pixel = watImage(index);
        pixelEntropy = entropy.sorted(i);
        entropyStrength = (pixelEntropy - entropy.min)/entropy.size;
        if(pixel > 127.5)
            entropyStrength = -1 * entropyStrength;
        end
        strength = entropyStrength * alpha ;
        watImage(index) = pixel + (strength * watermark.flat(i) * pixel);
    end
    watImage = reshape(watImage, image.x, image.y);
    watImage = uint8(watImage);
end