function [freq,data] = VNA_Meas(Start_Freq, Stop_Freq, Num_Points, IF_Band, IP_Addr, Cal_file)

IP=IP_Addr.Value; % IP address of the VNA
freq_1=Start_Freq.Value; % start frequency in GHz
freq_2=Stop_Freq.Value; % stop frequency in GHz
freq_points=Num_Points.Value; % number of frequency points
IF=IF_Band.Value; % IF measurement bandwidth in kHz
Cal = Cal_file.Value;
%IP=('10.206.161.196'); % IP address of the VNA
%freq_1=300; % start frequency in GHz
%freq_2=330; % stop frequency in GHz
%freq_points=151; % number of frequency points
%IF=1.3; % IF measurement bandwidth in kHz
%Cal=('WR3.4_S11_220330GHz_5MHz_step.cal'); % name of calibration to be applied
%filename=sprintf('%s',Data_Name,'.mat'); % file name of the saved data

freq_step=(freq_2-freq_1)/(freq_points-1);
freq=(freq_1:freq_step:freq_2)';
%data=zeros(length(d),freq_points); % measurement raw data

% Connect to the VNA
try
    rtb = VISA_Instrument(['TCPIP::' IP '::INSTR']); % Adjust the VISA Resource string to fit your instrument
    rtb.SetTimeoutMilliseconds(10000000000000); % Timeout for VISA Read Operations
    % rtb.AddLFtoWriteEnd = false;
catch ME
    error ('Error initializing the instrument:\n%s', ME.message);
end

% ASk to identify the VNA
idnResponse = rtb.QueryString('*IDN?'); %ask VNA to send back identifier
%fprintf('\nInstrument Identification string: %s\n', idnResponse); % print identifier

%rtb.Write('*RST;*CLS'); % Presets the instrument

rtb.Write(['FREQ:STAR ' num2str(freq_1) ' GHz']); % set start frequency
rtb.Write(['FREQ:STOP ' num2str(freq_2) ' GHz ']); % set stop frequency
rtb.Write(['SWE:POIN ' num2str(freq_points)]); % set number of sweep points
rtb.Write(['BAND:RES ' num2str(IF) ' kHz']); % set IF measurement bandwidth
rtb.Write(['MMEM:LOAD:CORR 1,"' Cal '"']); % apply calibration set

%%%%%%%%%%%%%%%%%%%%
rtb.Write('CALC:PAR:DEF CH1,S11') % Choose between the S21 and the S11
rtb.Write('INIT:CONT OFF') % stop continuous scan
%%%%%%%%%%%%%%%%%%%%

rtb.Write('INIT:IMM'); %initiate new scan
rtb.Write('*WAI'); % Using *wai we wait for the scan to be completed before we proceed
error=rtb.QueryString('SYST:ERR?'); %report for errors
temp=rtb.QueryASCII_ListOfDoubles(':CALC:DATA? SDATA', freq_points*2); %get the measurement data
temp1=reshape(temp,[2,freq_points]);
data=temp1(1,:)+1i*temp1(2,:);
%data = data';
%save(filename,'freq','data');