function attackedImage = multiAttack(image, power)
    attacks = attackFunctions();
    
    attackedImage = double(zeros(512, 512));
    
    [sortedBoundaries, boundariesIndexes] = sortrows(image.attacksBoundaries.values, 1, "descend");
    
    %attackPower = power * boundarypower
    
    for i = 1:size(attacks)
        attack = attacks{boundariesIndexes(i)};
        boundaryPower = sortedBoundaries(i, 2);
        attackPower = power * boundaryPower;
        attackedImage = attackedImage + double(attack.action(image.watermarked, attackPower));
    end
    attackedImage = uint8(attackedImage/4);
end

