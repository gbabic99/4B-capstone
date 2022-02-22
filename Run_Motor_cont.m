function Run_Motor_cont(h,dtheta,Tire_Diam,motor_speed,samples,Start_Freq, Stop_Freq, Data_Name, Num_Points, IF_Band, IP_Addr, Cal_file)

% attempt at making scan continuous

samples = samples.value;
dtheta = dtheta.value;
speed = motor_speed.value;
Freq1 = Start_Freq.Value;
Freq2 = Stop_Freq.Value;
FreqPoints = Num_Points.Value;
TireDiam = Tire_Diam.Value;

increment = dtheta/samples;         % angle scanned per sample
s_period = dtheta/(samples*speed);  % time between samples
acc = speed/s_period;               % acceleration from 0 to max

h.SetVelParams(0,0, acc, speed);    % controls motor speed
h.SetRelMoveDist(0,dtheta);         % sets rotational motion of motor
h.MoveRelative(0,1==0);             % tells motor to move

count = 0;
while(count < samples)
    [freq,data] = VNA_Meas(Start_Freq, Stop_Freq, Num_Points, IF_Band, IP_Addr, Cal_file);
    DATA_FILE (count,:)= data;
    disp([' Step ',num2str(count)]) 
    count = count + 1;
    pause(s_period);
end

save(Data_Name.Value,'freq','DATA_FILE');
disp('Done Scanning');
%dx = 2*pi*22.86*StepSize/360;
%load(sprintf('%s',Data_Name.Value,'.mat'));
%load('data.mat');
%[z,x,map_dB] = image_processing(Freq1,Freq2,(Freq2-Freq1)/(FreqPoints-1),dx,0,1,'data.mat');

final_image_processing(Freq1,Freq2,increment,TireDiam,samples,sprintf('%s',Data_Name.Value,'.mat'));

% [z,x,map_dB] = image_processing(Freq1,Freq2,(Freq2-Freq1)/(FreqPoints-1),dx,0,1,sprintf('%s',Data_Name.Value,'.mat'));
% final_image(z, x, map_dB);


%Disp motor is done moving
%Compile data and generate image

end 