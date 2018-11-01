function attackedImage = attack(watermarked)
%A Summary of this function goes here
%   Detailed explanation goes here

%get watImage
    watImage = imread(watermarked);
    watImage = double(watImage);
%attack
    attackedImage = double(test_awgn(watImage, 0.01, now));
    attackedImage = attackedImage + double(test_blur(watImage, 6));%-------------------questo fa schifo
    attackedImage = attackedImage + double(test_equalization(watImage, 2));
    attackedImage = attackedImage + double(test_jpeg(watImage, 9));%-------------------questo fa schifo
    attackedImage = attackedImage + double(test_median(watImage, 2, 2));%---------------questo forse fa schifo
    attackedImage = attackedImage + double(test_resize(watImage, 0.23));%---------------questo fa schifo
    attackedImage = attackedImage + double(test_sharpening(uint8(watImage), 100, 100));
    attackedImage = uint8(attackedImage/7);
end