function [Q] = initQ(zeilen,spalten, min, max)
%INITQ Summary of this function goes here
%   Detailed explanation goes here
Q = zeros(zeilen,spalten);

for v = 1:1:zeilen
    for w = 1:1:spalten
    
        Q(v, w) = (max-min).*rand() + min;
        
    end
   
end

end

