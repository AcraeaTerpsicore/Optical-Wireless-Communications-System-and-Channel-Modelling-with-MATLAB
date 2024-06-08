clear;clc;


% Program 4.4: Matlab codes to simulate BER of OOK-NRZ.


q=1.6e-19; % Charge of Electron
Ib=202e-6; % Back ground Noise Current + interference
N0=2*q*Ib; % Noise Spectral Density, 2*q*Ib
R = 1; % Photodetector responsivity
Goc = 1;
Rb=1e6; % Normalised Bit rate
Tb=1/Rb; % bit duration
sig_length=1e5; % number of bits
nsamp=10; % samples per symbols
Tsamp=Tb/nsamp; % sampling time
EbN0 = 1:12; % signal-to-noise ratio in dB.
SNR = 10.^(EbN0./10);
%% signal-to-noise ratio; % ************* Simulation of probability of errors. ************
for i=1:length(SNR)
    P_avg(i) = sqrt(N0*Rb*SNR(i)/(2*R^2)); % average transmitted optical power
    i_peak(i) = 2*R*P_avg(i); % Peak Electrical amplitude
    Ep(i) = i_peak(i)^2 * Tb; % Peak energy (Energy per bit is Ep/2)
    sgma(i)=sqrt(N0/2/Tsamp); % noise variance; %sgma(i) = i_peak(i)/
    sqrt(2)*sqrt(nsamp/(2*SNR(i)));
    pt = ones(1,nsamp)*i_peak(i); % tranmitter filter
    rt=pt; % Rx filter matched to pt
    OOK=my_randint(1,sig_length); % random signal generation
    Tx_signal=rectpulse(OOK,nsamp)*i_peak(i);% Pulse shaping function (rectangular pulse)
    Rx_signal=R*Tx_signal+sgma(i)*randn(1,length(Tx_signal)); % received signal (y=x+n)
    MF_out=conv(Rx_signal,rt)*Tsamp;% matched filter output
    MF_out_downsamp=MF_out(nsamp:nsamp:end);% sampling at end of bit period
    MF_out_downsamp=MF_out_downsamp(1:sig_length); % truncation
    Rx_th=zeros(1,sig_length);
    Rx_th(find(MF_out_downsamp>Ep(i)/2))=1;% thresholding
    [nerr ber(i)]=biterr(OOK,Rx_th);% bit error calculation
end
figure
semilogy(EbN0,ber,'b');
hold on
semilogy(EbN0,qfunc(sqrt(10.^(EbN0/10))),'r-X','linewidth',2);%theoretical ber ,'mx-');
grid on
legend('simulation','theory');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for OOK modulation')