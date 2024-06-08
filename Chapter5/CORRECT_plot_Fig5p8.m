clear;clc;

Rb=1e6;
% Bit rate
Tb=1/Rb;
% bit duration
nsamp=10;
% samples per symbols
Tsamp=Tb/nsamp;
% sampling time
Lsym=1e5;
% number of bits
fc_rb=1e-3;
%normalized cut-off frequency
fc=fc_rb*Rb;
% cut-on frequency of HPF
p_ave=1;
p_peak=2*p_ave;
% peak power of TX'd signal for OOK; % ***** Calculate impulse response of filters *****
tx_impulse=ones(1,nsamp)*p_peak;
mf_impulse=ones(1,nsamp)*(1/sqrt(Tb));
t=Tsamp:Tsamp:200*Tb;
hpf_impulse(1)=1*exp(-2*pi*fc*t(1));
 for loop=2:length(t)
 hpf_impulse(loop)=-1*(exp(2*pi*fc*t(1))-1)*exp(-2*pi*fc*t(loop));
end
 % ***** calculate overall impulse response*****
temp1=conv(tx_impulse,hpf_impulse);
temp2=conv(temp1,mf_impulse);
temp2=temp2*Tsamp;
system_impulse=temp2(nsamp:nsamp:200*nsamp);
%discrete impulse response; % ***** Do analysis on a per sequence basis *****
expected_one=0.5*p_peak*sqrt(Tb);
expected_zero=-0.5*p_peak*sqrt(Tb);
 OOK=my_randint(1,Lsym);
OOK=2*OOK-1;
% removing dc components
mf_output=filter(system_impulse,1,OOK)/(2*expected_one);
mf_output_one=mf_output(find(OOK==1)); % output for tranmitted bit of 1;
mf_output_zero=mf_output(find(OOK==-1));
nbin=51;
[n_zero,xout]=hist(mf_output_zero,nbin);
[n_one,xout]=hist(mf_output_one,nbin);
% combined histogram; % both expected outputs are shifted to zero; % note that removing dc value makes energy for zero and one identical
expect_one=xout(find(n_one==max(n_one)));
n_total=n_zero+n_one;
% Fig.; 
bar(xout,n_zero);
% histogram for zero bits
% Fig.; 
bar(xout,n_one);
% histogram for zero bits
% Fig.;
bar(xout-expect_one,n_total);
set(0,'defaultAxesFontName','timesnewroman','defaultAxesFontSize',12)
xlabel('Normalized matched filter ourput');
ylabel('Frequency')