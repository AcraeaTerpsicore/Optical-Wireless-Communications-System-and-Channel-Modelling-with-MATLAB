%Evaluation of BER of BPPM FSO (using equation (6.16) ) under weak
% turbulence using the Gauss-Hermite Quadrature integration approach.
clear
clc


% PLOT NOT CORRECT 

%****Hermite polynomial weights and roots************
w20=[2.22939364554e-13,4.39934099226e-10,1.08606937077e-7,7.8025564785e6,0.000228338636017,0.00324377334224,0.0248105208875,0.10901720602,...
    0.286675505363,0.462243669601,...
    0.462243669601,0.286675505363,0.10901720602,0.0248105208875,...
    0.00324377334224,0.000228338636017,7.8025564785e-6,1.08606937077e-7,...
    4.39934099226e-10,2.22939364554e-13];
x20=[-5.38748089001,-4.60368244955,-3.94476404012,-3.34785456738,...
    -2.78880605843,-2.25497400209,-1.73853771212,-1.2340762154,...
    -0.737473728545,-0.245340708301,...
    0.245340708301,0.737473728545,1.2340762154,1.73853771212,...
    2.25497400209,2.78880605843,3.34785456738,3.94476404012,...
    4.60368244955,5.38748089001];
%****************************************************
Ks1 = [140,180,220,260,300];
for i1 = 1:length(Ks1)
    Ks = Ks1(i1);
    %*************Simulation Parameters***************************
    Rb = 155e6; %Bit rate
    RL = 50; %Load resistance
    Temp = 300; %Ambient temperature
    E_c = 1.602e-19; %Electronic charge
    B_c = 1.38e-23; %Boltzmann constant
    %************************************************************************
    NoTh = (2*B_c*Temp/(2*Rb*RL));
    Ioni = 0.028;
    Kb = 10;
    gain = 150;
    F = 2 + (gain*Ioni);
    Kn = ((2*NoTh)/(gain*E_c)^2) + (2*F*Kb);
    S_I = 0.1:0.15:0.9; %Scintillation Index
    for i = 1:length(S_I)
        SI = S_I(i);
        Sk = log(S_I(i) + 1);
        Mk = log(Ks)-(Sk/2);
        Temp = 0;
        for j = i:length(x20)
            ANum(j) = (2*x20(j)*sqrt(2*Sk)) + (2*Mk);
            Num(j) = exp(ANum(j));
            BDen(j) = (sqrt(2*Sk)*x20(j) + Mk);
            Den(j) = (F*exp(BDen(j))) + Kn;
            Prod(j) = w20(j)*Q(Num(j)/Den(j));
            Temp = Temp + Prod(j);
        end
        BER(i1,i) = Temp/sqrt(pi);
    end
end
%*********Plot function****************************
figure
semilogy(S_I,BER)

legendStrings = arrayfun(@num2str, Ks1, 'UniformOutput', false);
legend(legendStrings);



