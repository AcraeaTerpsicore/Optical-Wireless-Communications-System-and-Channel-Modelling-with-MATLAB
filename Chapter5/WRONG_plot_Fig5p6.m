clear;clc;

% PLOT NOT CORRECT


%% optical power penalty for OOK
snr_1Mbps=10.54;
data_rate=[1 10 20 40 60 80 100 120 140 160 180 200];
%data rates
nf=5*(log10(data_rate));
% normalization factor
x=log10(data_rate);
% data rate in log scale
NOPR_ook_ideal=5*(log10(data_rate));
% optical power penalty in ideal channel;
%% *********** DPIM AWGN channel*************
NOPR_ideal_4dpim=NOPR_ook_ideal-5*log10(2*2.5/4);
NOPR_ideal_8dpim=NOPR_ook_ideal-5*log10(3*4.5/4);
NOPR_ideal_16dpim=NOPR_ook_ideal-5*log10(4*8.5/4);
semilogx(data_rate,NOPR_ideal_4dpim); hold on
semilogx(data_rate,NOPR_ideal_8dpim,'r');
semilogx(data_rate,NOPR_ideal_16dpim,'k');
 %% ********************** 4-DPIM in FLI channel ***************
snr_4dpim=[41.7 32.2 29.2 26.45 24.96 23.75 23 22.46 21.81 21.4 20.6 20.6];
% snr required to acheive a ber of 10^-6
snr_diff_4dpim=snr_4dpim-snr_1Mbps;
% difference in SNR compared to the LOS 1 Mbps
NOPR_4dpim=snr_diff_4dpim./2+nf;
% optical power penalty
p = polyfit(x,NOPR_4dpim,1);
% curve fitting
f4 = polyval(p,x);
 %% ********************** 8-DPIM in FLI channel ***************
snr_8dpim=[36.6 27 24.1 21.4 20 18.6 18.1 17.5 16.6 16.4 16.1 15.6];
snr_diff_8dpim=snr_8dpim-snr_1Mbps;
NOPR_8dpim=snr_diff_8dpim./2+nf;
p = polyfit(x,NOPR_8dpim,1);
f8 = polyval(p,x);
 %% ********************** 16-DPIM in FLI channel ***************
snr_16dpim=[31.1 21.5 18.6 16.1 14.7 13.5 13.1 12.4 11.7 11.2 11 10.5];
snr_diff_16dpim=snr_16dpim-snr_1Mbps;
NOPR_16dpim=snr_diff_16dpim./2+nf;
p = polyfit(x,NOPR_16dpim,1);
f16 = polyval(p,x);
%% plots
semilogx(data_rate,f4,'b--'); hold on
semilogx(data_rate,f8,'r--');
semilogx(data_rate,f16,'k--');
% xlabel(‘Data rate (Mbps)'); % ylabel(‘NOPR')%; % optical power penalty
semilogx(data_rate,f4-NOPR_ideal_4dpim,'b');
semilogx(data_rate,f8-NOPR_ideal_8dpim,'r');
semilogx(data_rate,f16-NOPR_ideal_16dpim,'k');