## I. Switch on  


1. motor (first power ON. then MOtor ON) 
2. RDH2000 acquision system 
3. Oscilloscope (if needed)

## II. Start Running 


1. RHD2000Interface 
2. Matlab editor "motor stimulus".

## III. Settings: On RHD2000 Interface


- Select File format - "one file per signal" 


- Enable the first 16 channels on Probe A if using NeuroNexus probe/the specific channels you are recording from/ all channels on Ports A


- Enable last ADC input "A-007"




- Sampling Freq - 25kHz


- Select bandwidth low pass - 75hZ

## IV. To Run experiment:


- Hit "Run: to see input from amplifier, "stop" to stop scanning input


- To hear the spike --> Select Audio - by going to DAC/Audio - and select DAC 1 --> Select the channel you want to hear on the oscilloscope and hit "select DAC to selected". Adjust the electrode to DAC gain to until you hear something. 

## V. To Record:


- On RHD2000 Interface: Select Base filename: Name "_YYMMDD_Time" is added by default


- Hit Record


- Go to Matlab --> run script MotorStimulus with appropriate module number.


- Once the stimulus is over - (can see on oscilloscope as well as on RHD2000 Interface), Hit "Stop"
