addpath(genpath('test'));

imagesDir = "test/imagesWatermarks/es";
results = zeros(6);

for i = 1:6
    
    original = strcat(imagesDir, num2str(i), "/original.bmp");
    watermarked = strcat(imagesDir, num2str(i), "/watermarked.bmp");
    attacked = strcat(imagesDir, num2str(i), "/attacked2.bmp");
    
    watImage = imread(watermarked);
    attImage = test_blur(watImage, 1);
    
    imwrite(attImage, attacked, "bmp");
    
    detection(original, watermarked, attacked)
    
    WPSNR(watImage, attImage)
end
