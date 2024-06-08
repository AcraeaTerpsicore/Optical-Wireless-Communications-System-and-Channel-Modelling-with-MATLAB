clear;clc;

% Program 4.14: Matlab codes to simulate OFDM system.

N=256;
% Number of subcarriers or size of IFFT/FFT
N_data_symbol=128;
% Number of symbol to IFFT
GI=N/4
% Guard interval 1/4,1/8,1/16,...
M=4;
% Modulation 2:BPSK, 4:QPSK, (8,16,32,64,128,256):QAM
L=16;
% Channel length
N_Iteration=500;
% Number of iteration
SNR=[0:1:15];
% Signal to Noise Ratio in dB
for i=1:length(SNR)
    snr=SNR(i)
    for (k=1:N_Iteration)
        tx_bits = my_randint(N_data_symbol,1,M);
        % Input Bit Streams to Transmit
        % Modulation
        tx_bits_Mod= qammod(tx_bits,M);
        input_symbol=[zeros((N-N_data_symbol)/2,1); tx_bits_Mod
            ;zeros((N-N_data_symbol)/2,1)];
        % IFFT and Circular Prefix Addition
        ofdm_symbol_ifft = ifft(input_symbol,N);
        % Guard Interval insertion (CP)
        guard_symbol = ofdm_symbol_ifft(N-GI+1:N);
        % Add the cyclic prefix to the ofdm symbol
        ofdm_symbol = [guard_symbol ; ofdm_symbol_ifft];
        %sig_pow=ofdm_symbol'.*conj(ofdm_symbol);
        ofdm_spectrum=ofdm_symbol;
        %ofdm_spectrum=[ofdm_spectrum ; ofdm_symbol]; %
        h=randn(L,1)+j*randn(L,1); % Generate random channel h(1:L,1); %h=h./
        sum(abs(h)); % Normalisation
        h=1; %AWGN
        y1 = filter(h,1,ofdm_symbol);
        %y=x*h; % Adding AWGN Noise
        y = awgn(y1,snr,'measured');
        %y=x*h+n; % Remove Cyclic prefix
        rx_symbol = y(GI+1:N+GI);
        % The FFT of the time domain signal after the removal of cyclic prefix
        rx_symbol_fft = fft(rx_symbol,N);
        % Equalization; %H_f=fft(h,N); %G=1./H_f;
        rx_equalized_zp=rx_symbol_fft;

        rx_equalized=rx_equalized_zp(((N-N_data_symbol)/2)+1:(N+N_data_symbol)/2);
        % Demodulate
        rx_bits_zp = qamdemod(rx_equalized,M);
        rx_bits=rx_bits_zp;
        % Comparison; % Bit Error Rate computation
        [nErr bErr(i,k)] = symerr(tx_bits,rx_bits);
    end
end
snr_theo=10.^(SNR/10);
Theory_awgn=0.5*erfc(sqrt(snr_theo));
semilogy(SNR,mean(bErr'),'b',SNR,Theory_awgn,'ro--')
legend('mean(bErr)','Theory_awgn');