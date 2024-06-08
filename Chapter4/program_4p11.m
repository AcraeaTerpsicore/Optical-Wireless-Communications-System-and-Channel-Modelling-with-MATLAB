clear;clc;

% Program 4.11: Matlab codes to simulate SER of DPIM in AWGN channel

M=4; % bit resolutions
NGS=0; % number of guard slots
Lavg=0.5*(2^M+1)+NGS; % Average symbol length
nsym=1e4; % number of PPM symbols
Rb=200e6; % Bit rate
Tb=1/Rb; % bit duration
Ts=M/(Lavg*Rb); % slot duration
EbN0=-10:3; % Energy per slot
EsN0=EbN0+10*log10(M); % Energy per symbol
SNR = 10.^(EbN0./10);
for ii=1:length(EbN0)
    DPIM= generate_DPIM(M,nsym,NGS); % generating DPIM sequence
    Lsig=length(DPIM); % actual packet length
    MF_out=awgn(DPIM,EsN0(ii)+3,'measured');
    % matched filter output assuming unit energy per bit
    Rx_DPIM_th=zeros(1,Lsig);
    Rx_DPIM_th(find(MF_out>0.5))=1;
    % Threshold detections
    [No_of_Error(ii) ser(ii)]= biterr(Rx_DPIM_th,DPIM);
end
semilogy(EbN0,ser,'ko','linewidth',2);
hold on
% theoretical calculation
Pse_DPIM=qfunc(sqrt(M*Lavg*0.5*SNR));
semilogy(EbN0,Pse_DPIM,'r','linewidth',2);
title('SER of DPIM in AWGN channel');