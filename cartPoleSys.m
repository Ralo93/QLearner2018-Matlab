classdef cartPoleSys < handle
    %CARTPOLESYS 
    
    properties(SetAccess = 'public', GetAccess = 'public')
        
        state (4,1) = [0;0;0;0] % state of the cart-pole-system with theta, theta_dot, x, x_dot
        m                       % mass of the pendulum
        M                       % mass of cart
        l                       % half lenght of pendulum
        f0                      % friction of cart
        f1                      % friction of pendulum
        g                       % g acceleration
        J                       % the moment of inertia of the pendulum
    end
    
    methods
        function obj = cartPoleSys(obj)
           obj.M = 1.3282; %kg
           obj.m = 0.22;   %kg
           obj.l = 0.304;  %m
           obj.f0 = 22.915; %N/m/s
           obj.f1 = 0.007056; %N/rad/s
           obj.g = 9.8; %m/s^2
           obj.J = 2/3*obj.m*obj.l; %kgm^2
           
           % State initialization
           obj.state(1,1) = -45*pi/180; % equal to -0.7854 in rad
           obj.state(2,1) = 0;
           obj.state(3,1) = -0.1;
           obj.state(4,1) = 0;
            
        end
        
        function dxdt = dynamics(obj,x,u)
            % F: external forces
            dxdt    = zeros(4,1);
            
            dxdt(1) = x(2);
            dxdt(2) = (-obj.f1*(obj.M+obj.m)*x(2)-obj.m^2*obj.l^2*x(2)^2*sin(x(1))*cos(x(1))+obj.f0*obj.m*obj.l*x(4)*cos(x(1))+(obj.M+obj.m)*obj.m*obj.g*obj.l*sin(x(1))-obj.m*obj.l*cos(x(1))*u) / ((obj.M+obj.m)*(obj.J+obj.m*obj.l^2)-obj.m^2*obj.l^2*(cos(x(1)))^2);
            dxdt(3) = x(4);
            dxdt(4) = (-obj.f1*obj.m*obj.l*cos(x(1))+(obj.J+obj.m*obj.l^2)*obj.m*obj.l*x(2)^2*sin(x(1))-obj.f0*(obj.J+obj.m*obj.l^2)*x(4)-obj.m^2*obj.g*obj.l^2*sin(x(1))*cos(x(1))+(obj.J+obj.m*obj.l^2)*u)/ ((obj.M+obj.m)*(obj.J+obj.m*obj.l^2)-obj.m^2*obj.l^2*(cos(x(1)))^2);
            
        end
        
        
    end
end

