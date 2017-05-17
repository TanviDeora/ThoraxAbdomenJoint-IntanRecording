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
s.Rate = Fs;  % Set the sample rate

%%
if module == 1 % square, sine, (and "white" noise?)
    
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

elseif module == 2 % test sum of sines
    
    % I used PrimeNumGen function (Freq=PrimeNumGen(150,5)) to generate 5 random frequencies 
    
    freq =[11 71 109 113 127]; % number of cycles per second for 5 different sines
     
    amp = 1; % max*2 is the peak to trough amplitude of sine
    T_EachSine = 5; % total duration of the sine will run for in sec
    t = 0:1/Fs:T_EachSine;
    
    Sin1 = amp*sin(2*pi*freq(1)*t); % total number of cycles is duration_sine*f_sine
    Sin2 = amp*sin(2*pi*freq(2)*t);
    Sin3 = amp*sin(2*pi*freq(3)*t);
    Sin4 = amp*sin(2*pi*freq(4)*t);
    Sin5 = amp*sin(2*pi*freq(5)*t);
    
      
    sine = Sin1 + Sin2 + Sin3 + Sin4 + Sin5; % total number of cycles is
%   duration_of each cycle * number of sines
    
    % blank 
    t_interval_blank=0:1/Fs:1; % 1sec black period at the start and stop of each cycle
    blank=zeros(1,length(t_interval_blank));
    
    % motor command
    motor=[blank, sine, blank, sine, blank]'; 
    daqData.stim = motor;
    
    s.queueOutputData([daqData.stim]);
    s.startForeground(); 
 end