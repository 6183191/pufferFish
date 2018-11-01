function [detected, wpsnr] = detect(resource, watermarked, attacked, alpha, S, watSize)
%get resImages
    resImage.file = imread(resource);
    [resImage.x, resImage.y] = size(resImage.file);
    resImage.double = double(resImage.file);
    resImage.flat = reshape(resImage.double, 1, resImage.x * resImage.y);
    
%get watImage
    watImage.file = imread(watermarked);
    [watImage.x, watImage.y] = size(watImage.file);
    watImage.double = double(watImage.file);
    watImage.flat = reshape(watImage.double, 1, watImage.x * watImage.y);
    
%get attImage
    attImage.file = imread(attacked);
    [attImage.x, attImage.y] = size(attImage.file);
    attImage.double = double(attImage.file);
    attImage.flat = reshape(attImage.double, 1, attImage.x * attImage.y);
    
%get entropy
    entropy = filterEntropy(resImage, S);
    
%watermark from watermarked
    watWat = getWatermark(resImage, entropy, watImage, alpha, watSize);

%watermark from attacked
    attWat = getWatermark(resImage, entropy, attImage, alpha, watSize);

%similarity with original watermark
    randomWatermarks = round(rand(1000, 1024));
    randomWatermarks(500, :) = watWat;
    
    sim=zeros(1,1000);
    for n = 1:1000
        sim(n) = attWat.*randomWatermarks(n,:)/sqrt(attWat.*attWat);
    end
    
    
    
    x = 1:1000;
    plot(x, sim);
    
    sorted=sort(sim,'descend');
    ss=sorted(2)*(1.1);
    if(sorted(2)<0)
        ss=sorted(2)*(0.9);
    end
    if(sim(500)>ss)
        detected = 1;
    else
        detected = 0;
    end
    wpsnr = WPSNR(watImage.file, attImage.file);
end