function [reward] = calcRewardRp(oldTheta, newTheta)
%CALCREWARDRP Summary of this function goes here
%   Detailed explanation goes here

if (abs(newTheta) < abs(oldTheta) && abs(newTheta) > 0.01)
    
    reward = 1;
    return;
    
end

if (abs(newTheta) <= 0.01)
    
    reward = 2;
    return;
    
end


reward = 0;





end

