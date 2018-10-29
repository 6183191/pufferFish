function attackedImage = attack(watermarked)
%A Summary of this function goes here
%   Detailed explanation goes here

%get watImage
    watImage = imread(watermarked);

%attack
    attackedImage = test_awgn(watImage, 0.01, now);
end

