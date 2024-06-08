
clear;clc;


i_peak=10;
Tb=3;
nsamp=16;
Tsamp=16;
sig_length=256;
sgma=0.23;
Ep=0.5;

%% *****Channel Impulse response (using Ceiling bounce model*************
Dt=0.1; 
% Normalised delay spread
Drms=Dt*Tb; 
%RMS delay spread 
a=12*sqrt(11/13)*Drms; 
K=30*nsamp; 
% number of channel taps 
k=0:K; 
h=((6*a^6)./(((k*Tsamp)+a).^7));
% channel impulse response
h=h./sum(h); 
% normalizing for conservation of energy; %% system impulse response
 pt = ones(1,nsamp)*i_peak;
 % tranmitter filter
 rt=pt;
 % Rx filter matched to pt
 c=conv(pt,h);
 c=conv(c,rt); 
 % overall impulse response of system
 delay=find(c==max(c));
 % channel delay; %% multipath simulation
 OOK=my_randint(1,sig_length); 
 % random signal generation
 Tx_signal=rectpulse(OOK,nsamp)*i_peak; 
 % Pulse shaping function (rectangular pulse)
 channel_output=conv(Tx_signal,h);
 % channel output, without noise 
 Rx_signal=channel_output+sgma*randn(1,length(channel_output));
 % received signal with noise; 
%Rx_signal=awgn(channel_output,EbN0+3-10*log10(nsamp),’measured’);
 %% Matched filter simulation
 MF_out=conv(Rx_signal,rt)*Tsamp; 
 % matched filter output
 MF_out_downsamp=MF_out(delay:nsamp:end); 
 % sampling at end of bit period
 MF_out_downsamp=MF_out_downsamp(1:sig_length);
 % truncation 
 Rx_th=zeros(1,sig_length);
 Rx_th(find(MF_out_downsamp>Ep/2))=1;