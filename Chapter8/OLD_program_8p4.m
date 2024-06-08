clear
clc
close all


% Program 8.4: Matlab codes to simulate the MIMO system.

TxN=4; % No of the transmitter
RxN=4; % No of receiver
M=1; % bit resolutions bits/Hz/s/channel
L=2^M; % Average symbol length
nsym=1000; % number of symbols
min_BitsToTest = 1e6;
max_BitError = 30 ;
SNR_dB=1:1:30; % SNR in dB
Hmat=[0.4961 0.4936 0.4906 0.4931;...
    0.1995 0.6526 0.4115 0.0529;...
    0 0.0879 0.5623 0.2001; ...
    0.0075 0 0.0538 0.4057];
Hmat=Hmat./sum(Hmat(:));
% Hmat=eye(4,4); for ideal MIMO channel
hMod = modem.pammod('M',L, 'SymbolOrder', 'Gray');
hDemod = modem.pamdemod(hMod); % Create a M-PAM based on
the modulator
for jj = 1:length(SNR_dB)
    total_nbit = 0; % initialise the loop variables
    total_nerr = 0; % number of bits tested, errors
    while total_nbit <= min_BitsToTest - 1 && total_nerr <= max_BitError
        DataSymbolIn=randi([0 L-1],TxN,nsym);% Generate data symbols
        PAM_Symbol = modulate(hMod, DataSymbolIn);% Generate modulated symbols
        PAM_Symbol_tx=real(PAM_Symbol);
        Tx_signal=PAM_Symbol_tx+(L-1); % Adding a DC to make signal unipolar
        %% received data
        Rx_bit=Hmat*Tx_signal; % received data
        Rx_bit=awgn(Rx_bit, SNR_dB(jj)+3, 'measured');
        % Rx_bit = awgn(Rx_bit, SNR_dB(Index)+10*log10(M)+3,'measured');
        % Rx_bit=Rx_bit-mean(Rx_bit);
        %% MIMO decoding
        received_signal=pinv(Hmat)*Rx_bit;
        for Rx_index=1:RxN
            received_signal(Rx_index,:)=received_signal(Rx_index,:)-mean
            (received_signal(Rx_index,:));
        end
        DataSymbolOut = demodulate(hDemod, received_signal);

        [nerr, bb] = biterr(DataSymbolOut , DataSymbolIn);
        clc
        total_nbit=total_nbit+nsym*M;
        total_nerr=total_nerr+nerr
    end
    BER(jj) = total_nerr/total_nbit
    if BER(jj) == 0
        break;
    end
end
figure;
semilogy(SNR_dB(1:length(BER)), BER)
xlabel('SNR(dB)'), ylabel('BER');
