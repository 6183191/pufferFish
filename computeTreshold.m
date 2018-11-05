%get watermark
watermark.size = 1024;
    wTemp = open("res/pufferfish.mat");
    watermark.file = wTemp.w;
    watermark.flat = reshape(watermark.file, 1, watermark.size);

    %get resImages
    resImage.file = imread("res/images/lena.tif");
    [resImage.x, resImage.y] = size(resImage.file);
    resImage.double = double(resImage.file);
    resImage.flat = reshape(resImage.double, 1, resImage.x * resImage.y);
    
    %get watImage
    watImage.file = imread("outputs/watermarkedImages/lena.tif");
    [watImage.x, watImage.y] = size(watImage.file);
    watImage.double = double(watImage.file);
    watImage.flat = reshape(watImage.double, 1, watImage.x * watImage.y);
    
    %get entropy
    entropy = filterEntropy(resImage, 5);
    
    %watermark from watermarked
    watWat = getWatermark(resImage, entropy, watImage, 0.09, 7);
    
%compute threshold
randomWatermarks = round(rand(1000, 1024));
randomWatermarks(500, :) = watermark.flat;


watermarkToTest = watWat;

sim=zeros(1,1000);
for n = 1:1000
    sim(n) = watermarkToTest.*randomWatermarks(n,:)/sqrt(watermarkToTest.*watermarkToTest);
end

x = 1:1000;
    plot(x, sim);
    

    
    
sorted=sort(sim,'descend');
    ss=sorted(2)*(1.1);
    
    
    
    
    ss