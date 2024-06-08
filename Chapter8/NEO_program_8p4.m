clear;
clc;
close all;

% Program 8.4: Matlab codes to simulate the MIMO system.

TxN = 4; % Number of transmitters
RxN = 4; % Number of receivers
M = 1; % Bit resolutions bits/Hz/s/channel
L = 2^M; % Average symbol length
nsym = 1000; % Number of symbols
min_BitsToTest = 1e6;
max_BitError = 30;
SNR_dB = 1:1:30; % SNR in dB
Hmat = [0.4961 0.4936 0.4906 0.4931; ...
        0.1995 0.6526 0.4115 0.0529; ...
        0 0.0879 0.5623 0.2001; ...
        0.0075 0 0.0538 0.4057];
Hmat = Hmat ./ sum(Hmat(:));
% Hmat = eye(4,4); % For ideal MIMO channel

hMod = comm.PAMModulator('ModulationOrder', L, 'SymbolMapping', 'Gray');
hDemod = comm.PAMDemodulator('ModulationOrder', L, 'SymbolMapping', 'Gray'); % Specify properties directly

BER = zeros(1, length(SNR_dB));

for jj = 1:length(SNR_dB)
    total_nbit = 0; % Initialise the loop variables
    total_nerr = 0; % Number of bits tested, errors

    while total_nbit <= min_BitsToTest - 1 && total_nerr <= max_BitError
        DataSymbolIn = randi([0 L-1], TxN, nsym); % Generate data symbols
        DataSymbolIn_col = DataSymbolIn(:); % Reshape to column vector
        PAM_Symbol = step(hMod, DataSymbolIn_col); % Generate modulated symbols
        PAM_Symbol_tx = reshape(PAM_Symbol, TxN, nsym); % Reshape back to original dimensions
        Tx_signal = PAM_Symbol_tx + (L-1); % Adding a DC to make signal unipolar

        % Received data
        Rx_bit = Hmat * Tx_signal; % Received data
        Rx_bit = awgn(Rx_bit, SNR_dB(jj) + 3, 'measured');

        % MIMO decoding
        received_signal = pinv(Hmat) * Rx_bit;
        for Rx_index = 1:RxN
            received_signal(Rx_index, :) = received_signal(Rx_index, :) - mean(received_signal(Rx_index, :));
        end
        received_signal_col = received_signal(:); % Reshape to column vector for demodulation
        DataSymbolOut_col = step(hDemod, received_signal_col);
        DataSymbolOut = reshape(DataSymbolOut_col, TxN, nsym); % Reshape back to original dimensions

        [nerr, ~] = biterr(DataSymbolOut(:), DataSymbolIn_col); % Compare reshaped column vectors
        clc;
        total_nbit = total_nbit + nsym * M;
        total_nerr = total_nerr + nerr;
    end
    BER(jj) = total_nerr / total_nbit;
    if BER(jj) == 0
        break;
    end
end

figure;
semilogy(SNR_dB(1:length(BER)), BER);
xlabel('SNR(dB)');
ylabel('BER');
title('BER versus SNR for the MIMO system.')