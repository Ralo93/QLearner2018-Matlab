function [Kdp] = newTakeAction3(actionIndex)
%NEWTAKEACTION Summary of this function goes here
%   Detailed explanation goes here

actionCluster = zeros(50);
tmp = 0;


for i = 1:1:50
    
    
    actionCluster(i) = tmp;
    tmp = tmp -60;
    
end

Kdp = actionCluster(actionIndex);



end
