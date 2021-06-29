%%% STARTING STUFF > idk what matlabrc does~
matlabrc; clc; close all;


%%% SIMULATION INFORMATION
% Defining time
dt = 1/30;
duration = 100;
tspan = dt:dt:duration;
L = length(tspan);


%%% OBJECT INFORMATION
% Initial State
w0 = randn(3,1);
q0 = [0;0;0;1]; % How do quaternions works asdfg
rotation = [q0; w0];

% Object Properties
mass = 1;
inertia = diag([1 1 1]);
vertices = [-1 -1  -1;
            -1  1 -1;
            1   1  -1;
            1  -1  -1;
            -1 -1  1;
            -1  1 1;
            1   1  1;
            1  -1  1]; % I copied this from Chris's code
faces = [1 2 6 5;
         2 3 7 6;
         3 4 8 7;
         4 1 5 8;
         1 2 3 4;
         5 6 7 8]; % I copied this from Chris's code
color = [0 0.5 0]; % Should be green

% Creating object with shape.m class
satellite = shape(vertices, faces, mass, inertia, color);


%%% SOLVING STUFF
[t,q] = ode45(@(t,X) rotationalDynamics(t,X,inertia), tspan, rotation);


%%% MAKING ANIMATION
% Plot limits and camera angles
xlabel("X")
ylabel("Y")
zlabel("Z")
xlim([-5 5])
ylim([-5 5])
zlim([-5 5])
view(45,20)

% Actual Animation
for i = 1:L
    q_i = q(i, 1:4);
    rotmat = q2a(q_i);
    satellite.updateAttitude(rotmat)
    drawnow
    pause(1/90)
end


