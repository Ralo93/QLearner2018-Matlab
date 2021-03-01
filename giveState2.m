function [state] = giveState2(n1, n2, n3, n4)
%GIVESTATE1 Summary of this function goes here
%   Detailed explanation goes here

state = (n1-1)*1000+(n2-1)*100+(n3-1)*10+n4;

% if (n2 > 1)
%     state = (n2-1)*10*10+(n3-1)*10+n4;
%     return;
% end
% 
% if( n3 > 1)
%     state = (n3-1)*10+n4;
%     return;
% end
% 
% if (n4 > 1)
%     state = n4;
%     return;
% end
% 
% state = 1;

end

