function [qValue] = calcNewQ(Q, reward, state, action)


            maxValue = max(Q(state,:));
            currentQ = Q(state, action);
            % Does not use the future state here! Does work better than
            % with the new state tho (getGammeMax(stateNew, Q)
            qValueNew = 0.1*currentQ + reward + obj.y*obj.getGammaMax(state, Q);



end

 