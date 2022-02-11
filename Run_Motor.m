function Run_Motor(h,Step_Size,Tire_Diam,Number_Steps,Start_Freq, Stop_Freq, Data_Name, Num_Points, IF_Band, IP_Addr, Cal_file)

StepSize = Step_Size.Value;
Num_Steps = Number_Steps.Value;
Freq1 = Start_Freq.Value;
Freq2 = Stop_Freq.Value;
FreqPoints = Num_Points.Value;
TireDiam = Tire_Diam.Value;

h.SetRelMoveDist(0,StepSize);

%h.SetJogStepSize(0,StepSize);
%acceleration = 1; GUI gives the 
%velocity = 2;
count = 0;
position = 0;
Format_Data = 'Data%d';
% Move a absolute distance
disp('Scanning');
while Num_Steps > count
    h.MoveRelative(0,1);
    %h.MoveJog(0,1);
    pause(0.1)
    %pause(5+StepSize/8);
    position = StepSize + position;
    count = count + 1;
    %Data_Count = sprintf(Format_Data,count);
    [freq,data] = VNA_Meas(Start_Freq, Stop_Freq, Num_Points, IF_Band, IP_Addr, Cal_file);
    DATA_FILE (count,:)= data;
    disp([' Step ',num2str(count)])
end
% count = 1;
% load(sprintf('Data1.mat'));
% Format_Data = 'Data%d%s';
% DATA_FILE = data;
% while Num_Steps > count
%     count = count + 1;
%     load(sprintf(Format_Data,count,'.mat'));
%     %Data_Stitch_Count(count,[]) = sprintf('%s','Data',count,'.mat');
%     DATA_FILE = cat(1,DATA_FILE,data);
%     %DATA_FILE(count,[]) = Data_Stitch_Count (2,[]);
% end
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