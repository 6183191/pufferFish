addpath(genpath('attacks'));

imagesDir = "images/";

 images = dir(imagesDir);
 images = {images.name};
 images = images(3:end);
 images = strcat(imagesDir, images);
 images = images';
[x,y] = size(images);
results = zeros(x, 2);
for i = 1:size(images)
    watermarked = embedding(images(i));
    attacked=watermarked;
    
    %mettere qui attacchi o tecnica di attacco
    %attacked    = test_blur(attacked,1.6);
    attacked=test_jpeg(attacked, 25);
    %attacked=test_resize(attacked,0.4375);
    
    
    [p,n,e]=fileparts(images(i));
    attackedPath=fullfile(n+"_attacked"+e);
    watermarkedPath=fullfile(n+"_pufferfish"+e);
    imwrite(uint8(attacked),attackedPath);
    

    [results(i, 1), results(i, 2)]  = detection_pufferfish(images(i), watermarkedPath, attackedPath);
end

results