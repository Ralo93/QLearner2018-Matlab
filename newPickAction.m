function [actionIndex] = newPickAction(Q,state,exp)
%NEWTAKEACTION Summary of this function goes here
%   Detailed explanation goes here

tmp = normrnd(0,1);

if(tmp < exp)
   % take random action from Q 
   % generate random number between 1 and 50
   actionIndex = randi(50);
   
   return;
end

% take maxValue action from Q

            row = Q(state,:);
           
            % Find maxima and return index
            idx = find( row == max(row) );
            
            
            actionIndex = idx(1);

end

