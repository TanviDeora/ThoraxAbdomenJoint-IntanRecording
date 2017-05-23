num_channels = length(board_adc_channels); % ADC input info from header file
fileinfo = dir('analogin.dat');
num_samples = fileinfo.bytes/(num_channels * 2); % uint16 = 2 bytes
fid = fopen('analogin.dat', 'r');
v = fread(fid, [num_channels, num_samples], 'uint16');
fclose(fid);
v = v * 0.000050354; % convert to volts if board mode 0
%v = (v - 32768) * 0.00015259; % convert to volts if board mode 1
%v = (v - 32768) * 0.0003125; % convert to volts if board mode = 13

% this bit is edited by Tanvi Deora
% convert 0 to + 3.3 (what_the_board_takes) back to -5 to + 5 V 
% ( what_the_motor_command_is)
OldMin =0; OldMax = 3.3; NewMin = -5; NewMax = 5;
Adjusted_Motor_v = ((v-OldMin)*((NewMax - NewMin)/(OldMax - OldMin))) + NewMin ;