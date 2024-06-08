clear;clc;


% Program 4.13: Matlab codes to simulate BER of BPSK modulation 
% in AWGN channel

Eb=1;



Rb=1; % normalised bit rate
fc=Rb*5; % carrier frequency;
Tb=1/Rb; % bit duration
SigLen = 1000; % number of bits or symbols
fsamp=fc*10; % sampling rate
nsamp=fsamp/Rb; % samples per symbols
Tsamp=Tb/nsamp; % sampling time
Tx_filter=ones(1,nsamp); % Tx filter
bin_data=my_randint(1,SigLen); %generating prbs of length SigLen
data_format = 2*bin_data-1;% BPSK constillation
t=Tsamp:Tsamp:Tb*SigLen;% time vector
carrier_signal=sqrt(2*Eb/nsamp)*sin(2*pi*fc*t);% carrier signal
bin_signal=conv(Tx_filter,upsample(data_format,nsamp));
%bin_signal=rectpulse(OOK,nsamp); % rectangular pulse shaping
bin_signal=bin_signal(1:SigLen*nsamp);
Tx_signal=bin_signal.*carrier_signal;
% transmitted signal
Eb=1; % energy per bit
Eb_N0_dB = -3:10; % multiple Eb/N0 values
for ii = 1:length(Eb_N0_dB)
    Rx_signal = awgn(Tx_signal,Eb_N0_dB(ii)+3-10*log10(nsamp),'measured');
    % additive white Gaussian noise
    Rx_output=Rx_signal.*carrier_signal;
    % decoding process
    for jj=1:SigLen
        output(jj)=sum(MF_output((jj-1)*nsamp+1:jj*nsamp));
        % matched filter output; % alternatively method of matched filter
        is given in OOK simulation
    end
    rx_bin_data=zeros(1,SigLen);
    rx_bin_data(find(output>0))=1;
    [nerr(ii) ber(ii)] = biterr(rx_bin_data,bin_data);
end
figure
semilogy(Eb_N0_dB,ber,'bo','linewidth',2);
hold on
semilogy(Eb_N0_dB,0.5*erfc(sqrt(10.^(Eb_N0_dB/10))),'r-X','linewidth',2); % theoretical ber ,'mx-');
