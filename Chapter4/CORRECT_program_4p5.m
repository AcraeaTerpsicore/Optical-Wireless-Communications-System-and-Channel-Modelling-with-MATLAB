clear;clc;

% Program 4.5: Matlab codes to simulate BER of OOK-NRZ using matched filter–based Rx

q = 1.6e-19; % Charge of Electron
Ib = 202e-6; % Background Noise Current + Interference
N0 = 2*q*Ib; % Noise Spectral Density, 2*q*Ib
Rb = 1e6; % Bit rate
Goc = 1; % Optical concentrator gain
Tb = 1/Rb; % Bit duration
R = 1; % Rx responsivity
sig_length = 1e5; % No. of bits in the input OOK symbols
snr_dB = 0:9; % Signal-to-noise ratio in dB
SNR = 10.^(snr_dB./10); % Signal-to-noise ratio

P_avg = zeros(1, length(snr_dB));
i_peak = zeros(1, length(snr_dB));
Ep = zeros(1, length(snr_dB));
sgma = zeros(1, length(snr_dB));
No_of_Error = zeros(1, length(snr_dB));
ber = zeros(1, length(snr_dB));

for i = 1:length(snr_dB)
    P_avg(i) = sqrt(N0*Rb*SNR(i)/(2*R^2)); % Average optical power
    i_peak(i) = 2*R*P_avg(i); % Peak photocurrent
    Ep(i) = i_peak(i)^2*Tb; % Peak Energy
    sgma(i) = sqrt(N0*Ep(i)/2); % Sigma, standard deviation of noise after matched filter
    th = 0.5*Ep(i); % Threshold level
    Tx = my_randint(1, sig_length); % Transmitted bit
    MF = zeros(1, sig_length); % Initialize matched filter output
    
    for j = 1:sig_length
        MF(j) = Tx(j)*Ep(i) + gngauss(sgma(i)); % Matched filter output
    end
    
    Rx = zeros(1, sig_length);
    Rx(find(MF > th)) = 1; % Threshold detection
    
    [No_of_Error(i), ber(i)] = biterr(Tx, Rx); % Bit error calculation
end

% Plotting BER vs SNR
figure;
semilogy(snr_dB, ber, 'o-'); % Semi-logarithmic plot
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR');
grid on;