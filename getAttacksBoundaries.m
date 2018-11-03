function boundaries = getAttacksBoundaries(image)
    attacks = attackFunctions();
    boundaries = zeros(4, 2);
    for i = 1:size(attacks)
        attack = attacks{i};
        
        disp(["attack: ", attack.info]);
        
        set = @(x)setAux(x, image, attack);
        
        foundState.power = 0;
        [foundState.watFound, foundState.wpsnr] = set(foundState.power);
        if ~foundState.watFound
            disp("watermark not found with minimum power");
        end
        
        lostState.power = 1;
        [lostState.watFound, lostState.wpsnr] = set(lostState.power);
        if lostState.watFound
            disp("watermark found with maximum power");
        end
        
        while foundState.wpsnr - lostState.wpsnr > image.attacksBoundaries.precision
            tempState.power = (lostState.power + foundState.power)/2;
            [tempState.watFound, tempState.wpsnr] = set(tempState.power);
            if tempState.watFound
                foundState = tempState;
            else
                lostState = tempState;
            end
        end
        
        boundaries(i, :) = [lostState.wpsnr, lostState.power];
    end
    
    function [watFound, wpsnr] = setAux(power, image, attack)
        imwrite(attack.action(image.watermarked, power), image.path.attacked, "bmp");
        [watFound, wpsnr] = detectionProf(image.path.original, image.path.watermarked, image.path.attacked);
    end
end