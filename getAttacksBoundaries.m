function boundaries = getAttacksBoundaries(image)
    attacks = attackFunctions();
    [x, y] = size(attacks);
    boundaries = zeros(x, 2);
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
        tempPrecision = image.attacksBoundaries.precision;
        start = cputime;
        while foundState.wpsnr - lostState.wpsnr > tempPrecision
            tempState.power = (lostState.power + foundState.power)/2;
            [tempState.watFound, tempState.wpsnr] = set(tempState.power);
            if tempState.watFound
                foundState = tempState;
            else
                lostState = tempState;
            end
            if cputime-start > 30
                tempPrecision = tempPrecision + 1;
                disp("precision increased by 1 due to exceeding time");
                disp(["actual precision: ", tempPrecision]);
                foundState.wpsnr
                lostState.wpsnr
            end
        end
        
        boundaries(i, :) = [lostState.wpsnr, lostState.power];
    end
    
    function [watFound, wpsnr] = setAux(power, image, attack)
        imwrite(attack.action(image.watermarked, power), image.path.attacked, "bmp");
        [watFound, wpsnr] = detectionProf(image.path.original, image.path.watermarked, image.path.attacked);
    end
end