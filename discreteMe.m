function [n] = discreteMe(x, min, max, buckets)
%DISCRETEME Summary of this function goes here
%   Detailed explanation goes here

if (x < min)
    n = 1;
    return
end

if (x > max )
    n = buckets;
    return
end

tmp = (( x / (max-min) )*buckets);
n = floor(tmp);

if ( n < 0)
    
n = -n;    
end

n = n+1;

end

