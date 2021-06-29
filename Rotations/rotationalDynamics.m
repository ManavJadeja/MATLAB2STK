function [dX] = rotationalDynamics(t,X,I)
    q = X(1:4);
    w = X(5:7);
    
    % Euler rotational dynamics:
    dw = I\(-1*cpm(w)*I*w);
    
    % Quaternion kinematic equations:
    Bq = zeros(4,3);
    Bq(1:3,:) = cpm(q(1:3)) + diag([q(4), q(4), q(4)]);
    Bq(4,:) = -q(1:3);
    dq = (1/2)*Bq*w;
    
    dX = [dq; dw];
end

% This sets up the differential for rotational dynamics
% Stolen from Chris Gnam
% Stolen in 2021
