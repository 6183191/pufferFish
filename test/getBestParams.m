addpath(genpath('source'));

alpha = 0.09;
S = 9;
watSize = 1;

watermark = "res/pufferfish.mat";

imagesDir = "res/images/";

images = dir(imagesDir);
images = {images.name};
images = images(3:end);
images = strcat(imagesDir, images);
images = images';

results = zeros(size(images));

for i = 1:size(images)
    watImage = embed(images(i), watermark, alpha, S, watSize);
    results(i) = WPSNR(imread(images(i)), watImage);
end

resAvg = mean(results)
minRes = min(results)
maxRes = max(results)
