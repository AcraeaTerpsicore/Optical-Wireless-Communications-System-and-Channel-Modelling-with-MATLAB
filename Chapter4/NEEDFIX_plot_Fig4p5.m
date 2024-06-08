clear;clc;



p_avg=1; % average optical power
R=1; % photodetector sensitivity
Goc = 1; %optical concentrator gain
Rb = 1; % normalised bit rate
Tb = 1/Rb; % bit duration
df = Rb/100; % spectral resolution
f = 0:df:5*Rb; % frequency vector
x=f*Tb; % normalised frequency
 temp1=(sinc(x)).^2;
temp2=0;
a=2*R*p_avg; % peak power is twice average power
p= (a^2*Tb).*temp1; %p(1)=p(1)+(((a^2)*Tb))*(sinc(0)^2)*(1/Tb); 
% delta function at DC
p = p/(((p_avg*R)^2)*Tb); % power normalisation by energy per bit





p_avg=1; % average optical power
Rb = 1; % photodetector sensitivity
Goc = 1; % normalised bit rate
Tb = 1/Rb; % bit duration
df = Rb/100; % spectral resolution
f = 0:df:5*Rb; % frequency vector
x=f*Tb/2;% normalised frequency
term1=(sinc(x)).^2;
a=R*p_avg; 
p=(((a^2)*Tb)).*term1;
%p(1)=p(1)+(((a^2)*Tb))*(sinc(0)^2)*(1/Tb) 
% delta function at DC
p((Rb/df)+1)=p((Rb/df)+1)+(((a^2)*Tb))*(sinc(Rb*Tb/2)^2)*(1/Tb); 
% delta function at f=Rb
p((2*Rb/df)+1)=p((2*Rb/df)+1)+(((a^2)*Tb))*(sinc(2*Rb*Tb/2)^2)*(1/Tb); 
% delta function at f=2Rb
p((3*Rb/df)+1)=p((3*Rb/df)+1)+(((a^2)*Tb))*(sinc(3*Rb*Tb/2)^2)*(1/Tb); 
% delta function at f=3Rb
p((4*Rb/df)+1)=p((4*Rb/df)+1)+(((a^2)*Tb))*(sinc(4*Rb*Tb/2)^2)*(1/Tb); 
% delta function at f=4Rb
 p = p / (((p_avg*R)^2)*Tb);


Rb=1; 
Goc = 1; 
Tb=1/Rb; 
% bit duration
SigLen = 1000; 
% number of bits or symbols
fsamp=Rb*10; % sampling frequency
nsamp=fsamp/Rb; % number of samples per symbols
 Tx_filter=ones(1,nsamp); % Tx filter for NRZ
%Tx_filter=[ones(1,nsamp/2) zeros(1,nsamp/2)]; % Tx filter for RZ
bin_data=my_randint(1,SigLen); %generating prbs of length SigLen
bin_signal=conv(Tx_filter,upsample(bin_data,nsamp)); % pulse shaping function 
bin_signal=bin_signal(1:SigLen*nsamp);
% *************** psd of the signals ***********
 Pxx = periodogram(bin_signal);
 Hpsd = dspdata.psd(Pxx,'Fs',fsamp); 
 % Create PSD data object
 figure;
 plot(Hpsd); title('PSD of TX signal') 