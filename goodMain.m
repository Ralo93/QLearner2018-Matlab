clc;

warning('off','all')
%addpath(genpath(pwd));

%For plots:
rewardCart = [6000];
rewardPole = [6000];

% von kontinuierlichen zu diskreten werten der zustände
xNextZustand = zeros(4,1);
breaks = 0;
% INITIALIZATION

% Initialize 6 Q Tables: initQ(zeilen, spalten, minValue, maxValue);

Q1 = initQ(10000,50,2,5);
Q2 = initQ(10000,50,2,5);
Q3 = initQ(10000,50,2,5);

Q4 = initQ(10000,50,2,5);
Q5 = initQ(10000,50,2,5);
Q6 = initQ(10000,50,2,5);

%Set number of episodes
episodes   = 6000;
timestamps = 8000;

%Kontinuierliche Zustände und Errors
x_dyn = zeros(8,1);
x_dyn(1) = -45*pi/180; %  -              equal to -0.7854 in rad
x_dyn(2) = 0;
x_dyn(3) = -0.1; % -
x_dyn(4) = 0;
x_dyn(5) = 0; % state for cummulative theta error
x_dyn(6) = 0; % state for cummulative position (x) error
x_dyn(7) = 0; % state for the last theta error
x_dyn(8) = 0; % state for the last x error

% Initialization for discrete values (states)
dVal = zeros(4,1);

% Initialization for the next discrete values (next states)
dValNew = zeros(4,1);

%Learning rates
a0 = 0.015;
a1 = 0.3;

expRate = giveExp(1); 

breakme = 0;
      
cps = cartPoleSys(); % also initializes starting state

for eps = 1:1:6000    
     
  
    
    %Initialization
    x_dyn = zeros(8,1);
    x_dyn(1) = -45*pi/180; %  -              equal to -0.7854 in rad
    x_dyn(2) = 0;
    x_dyn(3) = 0.1; % -
    x_dyn(4) = 0;
    x_dyn(5) = 0;
    x_dyn(6) = 0;
    x_dyn(7) = 0;
    x_dyn(8) = 0;
    
    %Decay expRate
    expRate = giveExp(eps);
    stateMatrix = [];
    
    for time = 1:1:8000
                            
        dVal(1) = discreteMe(x_dyn(1), -45*pi/180, 45*pi/180, 10);
        dVal(2) = discreteMe(x_dyn(2), -15, 15, 10);
        dVal(3) = discreteMe(x_dyn(3), -3,   3, 10);
        dVal(4) = discreteMe(x_dyn(4), -15, 15, 10);
        
        state1 = giveState1(dVal(1), dVal(2));
        state2 = giveState2(dVal(1), dVal(2), dVal(3), dVal(4));    

        %States and actions for Controller 1:
        % This will either pick a random Index(0:50) or the highest value in
        % the specified Q-row(state1)
        actionIndex1 = newPickAction(Q1, state1, expRate); %for updating the table at Q(state,action)
        actionIndex2 = newPickAction(Q2, state1, expRate);
        actionIndex3 = newPickAction(Q3, state1, expRate);
        
        Kdp = newTakeAction3(actionIndex1); %Q1 inputs Kdp    
        Kip = newTakeAction2(actionIndex2); %Q2 inputs Kip
        Kpp = newTakeAction1(actionIndex3); %Q3 inputs Kpp
        
        actionIndex4 = newPickAction(Q4, state2, expRate);
        actionIndex5 = newPickAction(Q5, state2, expRate);
        actionIndex6 = newPickAction(Q6, state2, expRate);

        Kdc = newTakeAction6(actionIndex4); %Q4 inputs Kdc
        Kic = newTakeAction5(actionIndex5); %Q5 inputs Kic
        Kpc = newTakeAction4(actionIndex6); %Q6 inputs Kpc
    
        %S.5 LINE 15
        
        %Current errors
        currentErrorTheta = 0 - x_dyn(1);
        currentErrorX = 0 - x_dyn(3);

        %Last errors
        lastErrorTheta = x_dyn(7);
        lastErrorX = x_dyn(8);

        c1 = newController(0);

        % getting the output force of the controller
        u1 = c1.control(Kpp, Kip, Kdp, currentErrorTheta, lastErrorTheta, x_dyn(5));
        u2 = c1.control(Kpc, Kic, Kdc, currentErrorX, lastErrorX, x_dyn(6));
        
        
        % Updating the error history
        x_dyn(5) = x_dyn(5) + currentErrorTheta;
        x_dyn(6) = x_dyn(6) + currentErrorX;

        % Updating last Error into states of x_dyn
        x_dyn(7) = currentErrorTheta;
        x_dyn(8) = currentErrorX;

        uGes = u1+u2;
        
        %Observe new State
        newStates = cps.dynamics(x_dyn ,uGes);   
    
        %Überprüfe!
        xNextZustand(1) = x_dyn(1) + newStates(1)*0.01;
        xNextZustand(2) = x_dyn(2) + newStates(2)*0.01;
        xNextZustand(3) = x_dyn(3) + newStates(3)*0.01;
        xNextZustand(4) = x_dyn(4) + newStates(4)*0.01;
                
        stateMatrix = [stateMatrix; xNextZustand(:)'];
        
        if ( abs(xNextZustand(1) > 90*pi/180 || abs(xNextZustand(3)) > 10))
        % Interrupt the episode 
            breakme = 1; 
            breaks = breaks + 1;
            break;
        end
        
        %Receive rewards
        rewardRp = calcRewardRp(x_dyn(1), xNextZustand(1));
        rewardRc = calcRewardRc(x_dyn(1), xNextZustand(1), x_dyn(3), xNextZustand(3));
        
        % LINE 20: obtain discrete States
        dValNew(1) = discreteMe(xNextZustand(1), -45*pi/180, 45*pi/180, 10);
        dValNew(2) = discreteMe(xNextZustand(2), -15, 15, 10);
        dValNew(3) = discreteMe(xNextZustand(3), -3, 3, 10);
        dValNew(4) = discreteMe(xNextZustand(4), -15, 15, 10);

        %TODO:
        %da0 = adaptLearningRate(a0);
        %da1 = adaptLearningRate(a1);
        
        newState1 = giveState1(dValNew(1), dValNew(2));
        newState2 = giveState2(dValNew(1), dValNew(2), dValNew(3), dValNew(4));  

        % Updating all Q values
        Q1(state1, actionIndex1) = Q1(state1, actionIndex1) + a0*(rewardRp+0.99*getMaxQ(Q1, newState1)-Q1(state1, actionIndex1));
        Q2(state1, actionIndex2) = Q2(state1, actionIndex2) + a0*(rewardRp+0.99*getMaxQ(Q2, newState1)-Q2(state1, actionIndex2));
        Q3(state1, actionIndex3) = Q3(state1, actionIndex3) + a0*(rewardRp+0.99*getMaxQ(Q3, newState1)-Q3(state1, actionIndex3)); 

        Q4(state2, actionIndex4) = Q4(state2, actionIndex4) + a1*(rewardRc+0.99*getMaxQ(Q4, newState2)-Q4(state2, actionIndex4));
        Q5(state2, actionIndex5) = Q5(state2, actionIndex5) + a1*(rewardRc+0.99*getMaxQ(Q5, newState2)-Q5(state2, actionIndex5));
        Q6(state2, actionIndex4) = Q6(state2, actionIndex6) + a1*(rewardRc+0.99*getMaxQ(Q6, newState2)-Q6(state2, actionIndex6));
        
        %Setze Zustände
        x_dyn(1) = xNextZustand(1);
        x_dyn(2) = xNextZustand(2);
        x_dyn(3) = xNextZustand(3);
        x_dyn(4) = xNextZustand(4);
        
    end
 
    if ( breakme == 1)
        breakme = 0;
        continue;
    end
    
 
end

plot_pendulum(stateMatrix);
