function [reward] = calcRewardRc(oldTheta, newTheta, oldX, newX)
%CALCREWARDRP Summary of this function goes here
%   Detailed explanation goes here

if (abs(newTheta) < abs(oldTheta) && abs(newX) < abs(oldX) && abs(newX) > 0.1)
    
    reward = 1;
    return;
    
end

if (abs(newX) <= 0.1)
    
    reward = 2;
    return;
    
end


reward = 0;





end

