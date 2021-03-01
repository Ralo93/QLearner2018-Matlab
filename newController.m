classdef newController < handle
    %NEWCONTROLLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ref % reference value for theta or x
        sampleTime
        
    end
    
    methods
        function obj = newController(ref)
             obj.ref = ref;
             obj.sampleTime = 0.01; % 10 ms
        end
        
        function [u] = control(obj, K, I, D, currentError, lastError, errorHist)
           
            u = K*currentError + I*errorHist*obj.sampleTime + D*(currentError-lastError)/obj.sampleTime;
            
        end
    end
end

