clear;clc;


sig_length = 1024;
Lfilter = 256;
nsamp=16;
i_peak=8;
R=0.2;
sgma=0.37;
Tb=10;
Tsamp=10;

OOK=my_randint(1,sig_length);
% random signal generation
OOKm=[zeros(1,Lfilter) OOK zeros(1,Lfilter)];
Tx_signal=rectpulse(OOKm,nsamp)*i_peak;
% Pulse shaping function (rectangular pulse)
Rx_signal=R*Tx_signal+sgma*randn(1,length(Tx_signal));
% received signal (y=x+n); % %*****************Effect of FL****************
start_time=abs(rand(1,1))*10E-3;
end_time=start_time+Tb*nsamp*sig_length;
Ib=2E-6;
% average current due to the fL
i_elect=fl_model(Ib,Tsamp,start_time,end_time);
% FLI model
Rx_OOK_fl=Rx_signal+i_elect(1:length(Rx_signal));
% Interference due to FL
MF_out=conv(Rx_OOK_fl,rt)*Tsamp;
% matched filter output
MF_out_downsamp=MF_out(nsamp:nsamp:end);
% sampling at end of bit period
MF_out_downsamp=MF_out_downsamp(1:length(OOKm));
% truncation; %% **************** wavelet denoising of the signal
[C,L] = wavedec(MF_out_downsamp,Lev,wname);
cA=appcoef(C,L,wname,Lev);
C(1:length(cA))=0;
Rx_OOK = waverec(C,L,wname);
% reconstructed signal
Rx_OOK=Rx_OOK(Lfilter+1:end-Lfilter);
Rx_OOK=mapminmax(Rx_OOK);
Rx_th=zeros(1,sig_length);
Rx_th(find(Rx_OOK>0))=1;
 % thresholding