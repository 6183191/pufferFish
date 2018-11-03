function attacks = attackFunctions()
    attacks = cell(4, 1);
    
    awgn.max = 1;
    awgn.min = 0;
    awgn.action = @(image, power)test_awgn(image, awgn.min+power*(awgn.max-awgn.min), now);
    awgn.info = "awgn";
    attacks{1} = awgn;
    
    blur.max = 10;
    blur.min = 0.1;
    blur.action = @(image, power)test_blur(image, blur.min+power*(blur.max-blur.min));
    blur.info = "blur";
    attacks{2} = blur;
    
    jpeg.max = 1;
    jpeg.min = 100;
    jpeg.action = @(image, power)test_jpeg(image, jpeg.min+power*(jpeg.max-jpeg.min));
    jpeg.info = "jpeg";
    attacks{3} = jpeg;
    
    resize.max = 0.1;
    resize.min = 1;
    resize.action = @(image, power)test_resize(image, resize.min+power*(resize.max-resize.min));
    resize.info = "resize";
    attacks{4} = resize;
    
end

