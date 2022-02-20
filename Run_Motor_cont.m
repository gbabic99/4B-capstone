function Run_Motor_cont(h,dtheta,Tire_Diam,samples,Start_Freq, Stop_Freq, Data_Name, Num_Points, IF_Band, IP_Addr, Cal_file)

% attempt at making scan continuous

samples = samples.value;
dtheta = dtheta.value;
Freq1 = Start_Freq.Value;
Freq2 = Stop_Freq.Value;
FreqPoints = Num_Points.Value;
TireDiam = Tire_Diam.Value;

% m_degree = 10; test values
% s_period = 1;

h.SetRelMoveDist(0,dtheta);
h.MoveRelative(0,1==0);

count = 0;
while(count < samples)
    pos = h.GetPosition_Position(0);
    if h.GetPosition_Position(0) - pos == dtheta/samples
        [freq,data] = VNA_Meas(Start_Freq, Stop_Freq, Num_Points, IF_Band, IP_Addr, Cal_file);
        DATA_FILE (count,:)= data;
        disp([' Step ',num2str(count)]) 
    end
  count = count + 1;
    
end


save(Data_Name.Value,'freq','DATA_FILE');
disp('Done Scanning');
%dx = 2*pi*22.86*StepSize/360;
%load(sprintf('%s',Data_Name.Value,'.mat'));
%load('data.mat');
%[z,x,map_dB] = image_processing(Freq1,Freq2,(Freq2-Freq1)/(FreqPoints-1),dx,0,1,'data.mat');

final_image_processing(Freq1,Freq2,StepSize,TireDiam,Num_Steps,sprintf('%s',Data_Name.Value,'.mat'));

% [z,x,map_dB] = image_processing(Freq1,Freq2,(Freq2-Freq1)/(FreqPoints-1),dx,0,1,sprintf('%s',Data_Name.Value,'.mat'));
% final_image(z, x, map_dB);


%Disp motor is done moving
%Compile data and generate image

end 