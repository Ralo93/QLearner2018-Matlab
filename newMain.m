
clc;

warning('off','all')
%addpath(genpath(pwd));

xZustand = zeros(4,1);

% INITIALIZATION

% Initialize 6 Q Tables: initQ(zeilen, spalten, minValue, maxValue);

Q1 = initQ(10000,50,1,0);
Q2 = initQ(10000,50,1,0);
Q3 = initQ(10000,50,1,0);

Q4 = initQ(10000,50,1,0);
Q5 = initQ(10000,50,1,0);
Q6 = initQ(10000,50,1,0);

%Set number of episodes
episodes = 6000;
x_dyn = zeros(8,1);

x_dyn(5) = 0; % state for cummulative theta error
x_dyn(6) = 0; % state for cummulative position (x) error
x_dyn(7) = 0; % state for the last theta error
x_dyn(8) = 0; % state for the last x error

% Initialization for discrete values (states)
dVal = zeros(4,1);

% Initialization for the next discrete values (next states)
dValNew = zeros(4,1);

% Initialization of starting states
x_dyn(1) = -45; %  -              equal to -0.7854 in rad
x_dyn(2) = 0;
x_dyn(3) = -0.1; % -
x_dyn(4) = 0;

% discreteValues
      dVal(1) = discreteMe(x_dyn(1), -45, 45, 10);
      dVal(2) = discreteMe(x_dyn(2), -15, 15, 10);
      dVal(3) = discreteMe(x_dyn(3), -3, 3, 10);
      dVal(4) = discreteMe(x_dyn(4), -15, 15, 10);


cps = cartPoleSys(); % also initializes starting state


for eps = 1:1:6000
    
        
    e = giveExp(eps); 
    dVal(1) = discreteMe(x_dyn(1), -45, 45, 10);
    dVal(2) = discreteMe(x_dyn(2), -15, 15, 10);
    dVal(3) = discreteMe(x_dyn(3), -3, 3, 10);
    dVal(4) = discreteMe(x_dyn(4), -15, 15, 10);
      
    state1 = giveState1(dVal(1), dVal(2));
    state2 = giveState2(dVal(1), dVal(2), dVal(3), dVal(4));    
        
    %States and actions for Controller 1
    actionIndex1 = newPickAction(Q1, state1, e); %for updating the table at Q(state,action)
        % this is the q1 actionIndex
    Kdp = newTakeAction3(actionIndex1); %Q1 inputs Kdp
    
    actionIndex2 = newPickAction(Q2, state1, e);
    Kip = newTakeAction2(actionIndex2); %Q2 inputs Kip
    
    actionIndex3 = newPickAction(Q3, state1, e);
    Kpp = newTakeAction1(actionIndex3); %Q3 inputs Kpp
    
    
    %States and actions for Controller 2
    actionIndex4 = newPickAction(Q4, state2, e);
    actionIndex5 = newPickAction(Q5, state2, e);
    actionIndex6 = newPickAction(Q6, state2, e);
          
    Kdc = newTakeAction6(actionIndex4); %Q4 inputs Kdc
    
    Kic = newTakeAction5(actionIndex5); %Q5 inputs Kic
    
    Kpc = newTakeAction4(actionIndex6); %Q6 inputs Kpc
    
    currentErrorTheta = 0 - x_dyn(1);
    currentErrorX = 0 - x_dyn(3);
    
    lastErrorTheta = x_dyn(7);
    lastErrorX = x_dyn(8);
    
    c1 = newController(0);
    
    % getting the output force of the controller
    u1 = c1.control(Kpp, Kip, Kdp, currentErrorTheta, lastErrorTheta, x_dyn(5));
    u2 = c1.control(Kpc, Kic, Kdc, currentErrorX, lastErrorX, x_dyn(6));
    
    
    %FINE UNTIL HERE!
    
    % Updating the error history
    x_dyn(5) = x_dyn(5) + currentErrorTheta;
    x_dyn(6) = x_dyn(6) + currentErrorX;
    
    % Updating last Error into states of x_dyn
    x_dyn(7) = currentErrorTheta;
    x_dyn(8) = currentErrorX;
    
    uGes = u1+u2;
    
    newStates = cps.dynamics(x_dyn ,uGes);   
    
    xZustand(1) = x_dyn(1) + newStates(1)*0.01;
    xZustand(2) = x_dyn(2) + newStates(2)*0.01;
    xZustand(3) = x_dyn(3) + newStates(3)*0.01;
    xZustand(4) = x_dyn(4) + newStates(4)*0.01;
    
    
        
    rewardRp = calcRewardRp(x_dyn(1), xZustand(1));
    rewardRc = calcRewardRc(x_dyn(1), xZustand(1), x_dyn(3), xZustand(3));
    
    %Line 20
    dValNew(1) = discreteMe(xZustand(1), -45, 45, 10);
    dValNew(2) = discreteMe(xZustand(2), -15, 15, 10);
    dValNew(3) = discreteMe(xZustand(3), -3, 3, 10);
    dValNew(4) = discreteMe(xZustand(4), -15, 15, 10);
    
    % delta1 = rewardRp+0.99*getMaxQ(Q1(dVal(1),:))- can be added
    % afterwards
    % Learning rate
    a1 = 0.5; % originally 0.15
    a2 = 0.3;
    
    newState1 = giveState1(dValNew(1), dValNew(2));
    newState2 = giveState2(dValNew(1), dValNew(2), dValNew(3), dValNew(4));  
    
    % Updating all Q values
    Q1(state1, actionIndex1) = Q1(state1, actionIndex1) + a1*(rewardRp+0.99*getMaxQ(Q1, newState1)-Q1(state1, actionIndex1));
    Q2(state1, actionIndex2) = Q2(state1, actionIndex2) + a1*(rewardRp+0.99*getMaxQ(Q2, newState1)-Q2(state1, actionIndex2));
    Q3(state1, actionIndex3) = Q3(state1, actionIndex3) + a1*(rewardRp+0.99*getMaxQ(Q3, newState1)-Q3(state1, actionIndex3)); 
    
    Q4(state2, actionIndex4) = Q4(state2, actionIndex4) + a2*(rewardRc+0.99*getMaxQ(Q4, newState2)-Q4(state2, actionIndex4));
    Q5(state2, actionIndex5) = Q5(state2, actionIndex5) + a2*(rewardRc+0.99*getMaxQ(Q5, newState2)-Q5(state2, actionIndex5));
    Q6(state2, actionIndex4) = Q6(state2, actionIndex6) + a2*(rewardRc+0.99*getMaxQ(Q6, newState2)-Q6(state2, actionIndex6));
    
    % Updating states
    x_dyn(1) = xZustand(1);
    x_dyn(2) = xZustand(2);
    x_dyn(3) = xZustand(3);
    x_dyn(4) = xZustand(4);
    
    %dVal(1) = discreteMe(x_dyn(1), -45, 45, 10);
    %dVal(2) = discreteMe(x_dyn(2), -15, 15, 10);
    %dVal(3) = discreteMe(x_dyn(3), -3, 3, 10);
    %dVal(4) = discreteMe(x_dyn(4), -15, 15, 10);
    
    
    if ( abs(xZustand(1) > 45 || abs(xZustand(3)) > 10))
        % Hier vielleicht noch einen sinnvollen rücksprung auf bessere werte setzen? 
        x_dyn(1) = -45; %  
        x_dyn(2) = 0;
        x_dyn(3) = -0.1; % 
        x_dyn(4) = 0;

        continue;
    end
    
    
    
end












