%Evaluation of BER of SISO BPSK MSM FSO under weak turbulence using the 
% Gauss-Hermite Quadrature integration approach.
clear
clc

% PLOT NOT CORRECT


%*************Parameters***************************
R=1; %Responsivity
Io=1; %Intensity without turbulence
N=1; %no of subcarrier
r=sqrt(0.1); %log intensity standard deviation
Noise=logspace(0,-5,100); %Gaussian noise variance
%**************************************************
for j=1:length(Noise)
 No = Noise(j);
 SNR(j)=10*log10(((R*Io)^2)/(No));
 K=(R*Io)/(sqrt(2*No)*N);
%****Hermite polynomial weights and roots************
w20=[2.22939364554e-13,4.39934099226e-10,1.08606937077e-7,...
7.8025564785e-6,0.000228338636017,0.00324377334224,0.0248105208875,...
0.10901720602,0.286675505363,0.462243669601,...
0.462243669601,0.286675505363,0.10901720602,0.0248105208875,...
0.00324377334224,0.000228338636017,7.8025564785e-6,1.08606937077e-7,...
4.39934099226e-10,2.22939364554e-13];
x20=[-5.38748089001,-4.60368244955,-3.94476404012,-3.34785456738,...
-2.78880605843,-2.25497400209,-1.73853771212,-1.2340762154,...
-0.737473728545,-0.245340708301,...
0.245340708301,0.737473728545,1.2340762154,1.73853771212,...
2.25497400209,2.78880605843,3.34785456738,3.94476404012,4.60368244955,...
5.38748089001]; 
%****************************************************
GH=0;
for i=1:length(x20)
 arg=K*exp(x20(i)*sqrt(2)*r - r^2/2);
 temp=w20(i)*Q(arg);
 GH=GH + temp;
end
BER(j) = GH/sqrt(pi);
end
%*********Plot function****************************
semilogy(SNR,BER)
xlabel('SNR (R*E[I])^2/No (dB)'); ylabel('BER');
%title('BPSK E[I]=Io=1 R=1')