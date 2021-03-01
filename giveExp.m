function [eRate] = giveExp(episode)
%GIVEEXP Summary of this function goes here
%   Detailed explanation goes here

if ( episode < 0.6*3000)
    tmp = exp(episode);
    eRate = 1/(1 + tmp) + 0.001;
    return;
end

eRate = 0;




end

