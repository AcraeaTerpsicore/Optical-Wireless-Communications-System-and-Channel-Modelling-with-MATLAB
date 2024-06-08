clear;clc;

% Program 5.1: Matlab codes to simulate effect of FLI on OOK

q = 1.6e-19;             % Charge of Electron
Ib = 202e-6;             % Background Noise Current + interference
N0 = 2*q*Ib;             % Noise Spectral Density, 2*q*Ib
R = 1;                   % Photodetector responsivity
Rb = 1e6;                % Bit rate
Tb = 1/Rb;               % bit duration
sig_length = ceil(20e-3/Tb); % number of bits
nsamp = 10;              % samples per symbols
Tsamp = Tb/nsamp;        % sampling time
EbN0_db = 30;            % signal-to-noise ratio in dB.
BER = 1;                 % initializing ber
index = 1;
maxerr = 30;             % maximum error per simulation

while (BER > 1E-4)
    terr = 0;            % total error
    tsym = 0;            % total bits
    SNR = 10.^(EbN0_db./10); % signal-to-noise ratio
    P_avg = sqrt(N0*Rb*SNR/(2*R^2)); % average transmitted optical power
    i_peak = 2*R*P_avg;  % Peak Electrical amplitude
    Ep = i_peak^2 * Tb;  % Peak energy (Energy per bit is Ep/2)
    sgma = sqrt(N0/2/Tsamp); % noise variance
    pt = ones(1,nsamp)*i_peak; % transmitter filter
    rt = pt;            % Rx filter matched to pt
    
    while (terr < maxerr && tsym < 1e5)
        OOK = randi([0 1], 1, sig_length); % random signal generation
        Tx_signal = rectpulse(OOK, nsamp) * i_peak; % Pulse shaping function (rectangular pulse)
        Rx_signal = R * Tx_signal + sgma * randn(1, length(Tx_signal)); % received signal (y=x+n)
        
        % *****************Effect of FL****************
        start_time = abs(rand(1,1)) * 10E-3;
        end_time = start_time + Tb * nsamp * sig_length;
        Ib = 2E-6;       % average current due to the fL
        i_elect = fl_model(Ib, Tb, start_time, end_time); % FLI model
        Rx_OOK_fl = Rx_signal + i_elect(1:length(Rx_signal)); % Interference due to FL
        
        MF_out = conv(Rx_OOK_fl, rt) * Tsamp; % matched filter output
        MF_out_downsamp = MF_out(nsamp:nsamp:end); % sampling at end of bit period
        MF_out_downsamp = MF_out_downsamp(1:sig_length); % truncation
        Rx_th = zeros(1, sig_length);
        Rx_th(MF_out_downsamp > Ep/2) = 1; % thresholding
        
        % bit error calculation
        nerr = biterr(OOK, Rx_th);
        terr = terr + nerr;
        tsym = tsym + sig_length;
    end % end while
    
    BER = terr / tsym;
    ber(index) = BER;       % indexing the results
    EbN0(index) = EbN0_db;  % indexing the results
    index = index + 1;
    EbN0_db = EbN0_db + 0.5;
    
    if EbN0_db > 50; break; end
end

% Plotting the results
figure;
semilogy(EbN0, ber, '-o');
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs E_b/N_0 for OOK with FLI');
grid on;
