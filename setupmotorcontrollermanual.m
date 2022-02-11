[h] = 0;
global h;
fpos    = get(0,'DefaultFigurePosition'); % figure default position
fpos(3) = 650; % figure window size;Width
fpos(4) = 450; % Height
f = figure('Position', fpos,'Menu','None','Name','APT GUI'); %If you want
set(f,'Visible','off')
h = actxcontrol('MGMOTOR.MGMotorCtrl.1',[20 20 600 400 ], f);
%set(f,'Visible','off')
%h = COM.MGMOTOR_MGMotorCtrl_1
%h = actxcontrol('MGMOTOR.MGMotorCtrl.1');
h.StartCtrl;
SN = 40145984; % put in the serial number of the hardware
set(h,'HWSerialNum', SN);
h.Identify;
h.SetStageAxisInfo (0, 0, 9999999, 2, 1.0111111, 0 );
h.SetMotorParams(0,37,1);
h.SetHomeParams(0,2,1,10,5.5);
h.SetDCJoystickParams(0,0,1,0,1,2);
h.SetJogVelParams(0,0,10,10);

% 
% % Controlling the Hardware
%h.MoveHome(0,0); % Home the stage. First 0 is the channel ID (channel 1)
%                  % second 0 is to move immediately
% %% Event Handling
%h.registerevent({'MoveComplete' 'MoveCompleteHandler'});
%  
% %% Sending Moving Commands
%timeout = 10; % timeout for waiting the move to be completed
%h.MoveJog(0,1); % Jog
%  
% % Move a absolute distance
%h.SetAbsMovePos(0,0);
%h.MoveAbsolute(0,1==0);
%  
% t1 = clock; % current time
% while(etime(clock,t1)<timeout) 
% % wait while the motor is active; timeout to avoid dead loop
%     s = h.GetStatusBits_Bits(0);
%     if (IsMoving(s) == 0)
%       pause(2); % pause 2 seconds;
%       h.MoveHome(0,0);
%       disp('Home Started!');
%       break;
%     end
% end


disp('Connection To Motor Controller Complete');