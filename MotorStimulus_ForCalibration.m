function[]=MotorStimulus(module)

if nargin<1||isempty('module') 
    module = input('Which module to run?');  
end
%% detect and initialize the A/D equipment
try
    devices = daq.getDevices();
    for ind1=1:length(devices)
        compare = strcmp('USB-6229 (BNC)',devices(ind1).Model); % compare the name of the DAQ I am using with whatever DAQ(s) are plugged into the computer
        if compare(1) == 1
            adDevice=devices(ind1).ID;
        end
    end
catch
    disp('No DAQ')
    return
end

%% Set the current data acquisition asession for analog output

VendorID ='ni';
Fs=2.5e4; %stimulus sampling rate

s = daq.createSession(VendorID);
addAnalogOutputChannel(s,adDevice,'ao0','Voltage');
addAnalogOutputChannel(s,adDevice,'ao1','Voltage');
s.Rate = Fs;  % Set the sample rate

%%
if module == 1 % square, sine, (and white noise)
    
    %square pulse
    duration_sq = 5; % duration of step pulse in second
    f_sq = 2; % number of step cycles per second
    t_interval_sq=0:1/Fs:duration_sq;
    Square_pulse = square(t_interval_sq*2*pi*f_sq); % total of cycles = duration_sq*f_sq
    
    t_interval_blank=0:1/Fs:1; % 1sec black period at the start and stop of each cycle
    blank=zeros(1,length(t_interval_blank));
    
    % sine pulse
    amp = 2; % max*2 is the peak to trough amplitude of sine
    duration_sine=10; % total duration the sine will to run for in sec
    f_sine = 5; % number of cyles per second
    t_interval_sine=0:1/Fs:duration_sine;
    
    sine = amp*sin(2*pi*f_sine*t_interval_sine); % total number of cycles is duration_sine*f_sine
    
    % white noise
    
    
    %final motor stimulus
    motor=[Square_pulse,blank,sine,blank]'; 
    
    daqData.stim = motor;
    s.queueOutputData([daqData.stim]);
    s.startForeground();

elseif module == 2 % test the frequency/amplitute range of the motor
     
    amp = 5; % amplitude of chirp
    T_chirp = 10; % total duration of chirp
    t = 0:1/Fs:T_chirp;
    fo = 0;
    f1 = 300;
    myChirp = amp*chirp(t,fo,10,f1,'linear');

%     % sine pulse
%     amp = 2; % max*2 is the peak to trough amplitude of sine
%     duration_sine=10; % total duration the sine will to run for in sec
%     f_sine = 150; % number of cyles per second
%     t_interval_sine=0:1/Fs:duration_sine;
%     
%     sine = amp*sin(2*pi*f_sine*t_interval_sine); % total number of cycles is duration_sine*f_sine
    
    % blank 
    t_interval_blank=0:1/Fs:1; % 1sec black period at the start and stop of each cycle
    blank=zeros(1,length(t_interval_blank));
    
    % motor command
    motor=[blank, myChirp , blank]'; 
    daqData.stim = motor;
    
    s.queueOutputData([daqData.stim]);
    s.startForeground();
    

elseif module == 3 % sine sequence to test motor
    
    %square pulse
    duration_sq = 0.5; % duration of step pulse in second
    f_sq = 0.5; % number of step cycles per second
    t_interval_sq=0:1/Fs:duration_sq;
    Square_pulse = square(t_interval_sq*2*pi*f_sq); % total of cycles = duration_sq*f_sq
    
    % blank
    t_interval_blank=0:1/Fs:0.5; % 1sec black period at the start and stop of each cycle
    blank=zeros(1,length(t_interval_blank));
    
    % Frequency Sweep
    freq_seq=logspace(1,2.7,10); % number of cycles per second
    amp = 1;
    duration_sq = 2; % duration of step pulse in seconds
     
    t_interval_sine=0:1/Fs:duration_sq;
    
    sine1 = amp*sin(2*pi*freq_seq(1)*t_interval_sine); % total number of cycles is duration_sine*f_sine
    sine2 = amp*sin(2*pi*freq_seq(2)*t_interval_sine); 
    sine3 = amp*sin(2*pi*freq_seq(3)*t_interval_sine); 
    sine4 = amp*sin(2*pi*freq_seq(4)*t_interval_sine); 
    sine5 = amp*sin(2*pi*freq_seq(5)*t_interval_sine); 
    sine6 = amp*sin(2*pi*freq_seq(6)*t_interval_sine); 
    sine7 = amp*sin(2*pi*freq_seq(7)*t_interval_sine);
    sine8 = amp*sin(2*pi*freq_seq(8)*t_interval_sine);
    sine9 = amp*sin(2*pi*freq_seq(9)*t_interval_sine);
    sine10 = amp*sin(2*pi*freq_seq(10)*t_interval_sine); 
    motor = [Square_pulse blank sine1 sine2 sine3 sine4 sine5 sine6 sine7 sine8 sine9 sine10]';
    adjustedVoltage_motor = [(motor+5)*(3.3/10)];
    daqData(1).stim = motor;
    daqData(2).stim = adjustedVoltage_motor;
    s.queueOutputData([daqData(1).stim daqData(2).stim]);
    s.startForeground();
    

end