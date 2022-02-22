%% Parameters
dtheta = 30;     
v_max = 2;      % Maximum velocity of spin (Degrees/sec)
samples = 30;
s_period = dtheta/(samples*v_max);
acc = v_max/s_period; % Acceleration from velocty minimum (0) to velocity maximum in degrees/sec^2
%% Set Velocity and Move
h.SetVelParams(0,0, acc, v_max);
h.SetRelMoveDist(0,dtheta);
h.MoveRelative(0,1==0);
%% Action Loop
count = 1;
locations = zeros(1,samples);
while(count < samples+1)
    locations(count) = h.GetPosition_Position(0); % test to store locations
    count = count + 1;
    pause(s_period); 
end