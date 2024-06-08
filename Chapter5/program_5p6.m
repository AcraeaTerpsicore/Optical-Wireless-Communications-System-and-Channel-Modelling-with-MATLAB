clear;clc;


% simulate_ceiling_bounce_model_and_received_signal_eye_diagram

Rb=200e6;
% Bit rate
Tb=1/Rb;
% bit duration
sig_length=1e3;
% number of bits
nsamp=10;
% samples per symbols
Tsamp=Tb/nsamp;
% sampling time
%% *****Channel Impulse response (using Ceiling bounce model)*************
Dt=0.5;
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
% normalizing for conservation of energy
% **************** filter definitions*******
pt = ones(1,nsamp)
 % tranmitter filter
c=conv(pt,h);
OOK=my_randint(1,sig_length);
% random signal generation
Tx_signal=rectpulse(OOK,nsamp);
% Pulse shaping function (rectangular pulse);
channel_output=conv(Tx_signal,h);
% channel output
eyediagram(channel_output, 3*nsamp);
