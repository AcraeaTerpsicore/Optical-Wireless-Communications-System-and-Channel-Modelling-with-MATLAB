%Evaluation of BER of SISO BPSK-SIM FSO under weak turbulence using the
% Gauss-Hermite Quadrature integration approach.; %Different noise sources
% considered: Background, thermal and dark
clear
clc


% PLOT NOT CORRECT 




%*************Simulation Parameters***************************
Rb = 155e6; %symbol rate
R = 1; %Responsivity
M_ind = 1; %Modulation index
A = 1; %Subcarrier signal amplitude
RL = 50; %Load resistance
Temp = 300; %Ambient temperature
wavl = 850e-9; %Optical source wavelenght
%********************Background Noise************************
%Considering 1 cm^2 receiving aperture
sky_irra = 1e-3; % at 850nm wavelength, in W/cm^2-um-sr
sun_irra = 550e-4; %at 850nm wavelength, in W/cm^2-um
FOV = 0.6; % in radian
OBP = 1e-3; %Optical filter bandwidth in micrometre
Isky = sky_irra*OBP*(4/pi)*FOV^2; %Sky irradiance
Isun = sun_irra*OBP; %Sun irradiance
%**************Rytov Variance********************************************
Range = 1e3; %Link range in meters
Cn = 0.75e-14; %Refractive index structure
%parameter
Rhol = 1.23*(Range^(11/6))*Cn*(2*pi/wavl)^(7/6); %Log irradiance;
%variance (Must be less than 1
Varl = Rhol; %Log intensity variance
r = sqrt(Varl); %log intensity standard deviation
%*****************Physical constants****************************
E_c = 1.602e-19; %Electronic charge
B_c = 1.38e-23; %Boltzmann constant
%************************************************************************
Pd = A^2/2;
K1 = ((M_ind^2)*R*Pd)/(2*E_c*Rb); %Quantum limit
K2 = ((R*M_ind)^2)*Pd*RL/(4*B_c*Temp*Rb); %Thermal noise limit
K3 = (Pd*R*M_ind^2)/(2*E_c*Rb*(Isun + Isky)); %Background radiation
%limit

Ktemp = (4*B_c*Temp*Rb/RL) + (2*E_c*R*Rb*(Isun + Isky));
K4 = ((R*M_ind)^2)*Pd/Ktemp; %background and thermal;
%noise combined
%***************Hermite polynomial weights and roots************
w20=[2.22939364554e-13,4.39934099226e-10,1.08606937077e-7,...
    7.8025564785e-6,0.000228338636017,0.00324377334224,0.0248105208875,...
    0.10901720602,0.286675505363,0.462243669601,...
    0.462243669601,0.286675505363,0.10901720602,0.0248105208875,...
    0.00324377334224,0.000228338636017,7.8025564785e-6,1.08606937077e-7,...
    4.39934099226e-10,2.22939364554e-13];
x20=[-5.38748089001,-4.60368244955,-3.94476404012,-3.34785456738,-2.78880605843,...
    -2.25497400209,-1.73853771212,-1.2340762154,...
    -0.737473728545,-0.245340708301,...
    0.245340708301,0.737473728545,1.2340762154,1.73853771212,...
    2.25497400209,2.78880605843,3.34785456738,3.94476404012,...
    4.60368244955,5.38748089001];
%**************************BER evaluation*******************
Io = logspace(-10,-4,30); %Average received irradiance
IodBm =10*log10(Io*1e3); %Average received irradiance in
%dBm
SNR2 = RL*((R.*Io).^2)./(4*B_c*Temp*Rb);
SNR2dB = 10*log10(SNR2);
for i1 = 1:length(Io)
    GH1 = 0;GH2 = 0;GH3 = 0;GH4 = 0;
    for i2 = 1:length(x20)
        arg1 = sqrt(K1*Io(i1))*exp(0.5*x20(i2)*sqrt(2)*r - Varl/4);
        temp1 = w20(i2)*Q(arg1);
        GH1 = GH1 + temp1;
        arg2 = sqrt(K2)*Io(i1)*exp(x20(i2)*sqrt(2)*r - Varl/2);
        temp2 = w20(i2)*Q(arg2);
        GH2 = GH2 + temp2;
        arg3 = sqrt(K3)*Io(i1)*exp(x20(i2)*sqrt(2)*r - Varl/2);
        temp3 = w20(i2)*Q(arg3);
        GH3 = GH3 + temp3;
        arg4 = sqrt(K4)*Io(i1)*exp(x20(i2)*sqrt(2)*r - Varl/2);
        temp4 = w20(i2)*Q(arg4);
        GH4 = GH4 + temp4;
    end
    BER1(i1) = GH1/sqrt(pi);
    BER2(i1) = GH2/sqrt(pi);
    BER3(i1) = GH3/sqrt(pi);
    BER4(i1) = GH4/sqrt(pi);
end
%*********Plot function****************************
figure
% subplot(4,1,1);
semilogy(IodBm,BER2,'o-') % Thermal noise case
hold on;
% subplot(4,1,2) ;
% subplot(4,1,3);
semilogy(IodBm,BER3,'+-') % Background radiation case
% subplot(4,1,4);
semilogy(IodBm,BER4,'-') % background and thermal noise case
semilogy(IodBm,BER1,'.') %Quantum limit case
legend('Thermal noise','Background noise','Thermal+Background','Quantum');