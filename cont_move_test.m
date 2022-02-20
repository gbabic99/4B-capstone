samples = 100;
dtheta = 30;

h.SetRelMoveDist(0,dtheta);
h.MoveRelative(0,1==0);
h.SetVelParams(0,3,speed); % need to figure out how varying affects stuff: middle is acceleration

count = 0;
locations = zeros(1,samples);
while(count < samples)
    pos = h.GetPosition_Position(0);
    if h.GetPosition_Position(0) - pos == dtheta/samples
        locations(count) = h.GetPosition_Position(0); % test to store locations
        count = count + 1;
    end   
end