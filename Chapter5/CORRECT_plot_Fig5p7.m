clear;clc;


% Program 5.3: Matlab codes to slow the effect of high-pass 
% filter and baseline wander in OOK-NRZ signal.


Rb=1e6;
% Bit rate
Tb=1/Rb;
% bit duration
sig_length=1e2;
% number of bits
nsamp=10;
% samples per symbols
Tsamp=Tb/nsamp;
% sampling time
Lsym=1e3;
% number of bits
fc_rb=5e-2;
% normalized cut-off frequency of HPF
A=1;
% normalized amplitude
 %% ***** Calculate impulse response of filters *****
tx_impulse=ones(1,nsamp)*A;
% Tx filter
fc=fc_rb*Rb; %Note, fc = fc-hpf;
% actual cut-on frequency of HPF
 t=Tsamp:Tsamp:10*Tb;
% time vector
hpf_impulse(1)=1*exp(-2*pi*fc*t(1));
% impulse response (see eq (5.9))
for loop=2:length(t)
 hpf_impulse(loop)=-1*(exp(2*pi*fc*t(1))-1)*exp(-2*pi*fc*t(loop));
end
 %% effect of HPF on OOK
OOK=my_randint(1,Lsym);
OOK=2*OOK-1;
% removing dc components
signal=filter(tx_impulse,1, upsample(OOK,nsamp));
% rectangular pulse shaping
hpf_output=filter(hpf_impulse,1,signal);
% hpf output; %% plots
plotstart=(10*nsamp+1);
plotfinish=plotstart+15*nsamp;
t=0:Tsamp:Tsamp*(plotfinish-plotstart);
subplot(311); plot(t,signal(plotstart:plotfinish),'k');
subplot(312); plot(t,hpf_output(plotstart:plotfinish),'k');
% subplot(413); plot(t,signal(plotstart:plotfinish)-hpf_output(plotstart:plotfinish),'k')
subplot(313); plot(t,-signal(plotstart:plotfinish)+hpf_output(plotstart:plotfinish),'k')