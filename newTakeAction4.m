function [Kpc] = newTakeAction4(actionIndex)
%NEWTAKEACTION Summary of this function goes here
%   Detailed explanation goes here


actionCluster = zeros(50);
tmp = 0;


for i = 1:1:50
    
    
    actionCluster(i) = tmp;
    tmp = tmp -40;
    
end

Kpc = actionCluster(actionIndex);


end
