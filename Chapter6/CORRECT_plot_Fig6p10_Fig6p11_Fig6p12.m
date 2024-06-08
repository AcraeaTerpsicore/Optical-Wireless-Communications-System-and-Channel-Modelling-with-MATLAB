%*****Subcarrier modulation simulation for M-PSK intensitymodulation******%
%*************************************************************************%
clear all
clc
close
%**********SIMULATION PARAMETERS********************************
N_sub = 1; %No of subcarriers
symb = 1e2; %No of symbols
Rb = 155e6; %Symbol rate
M = 4; %M-PSK
Responsivity = 1; %Photodetector responsivity
T = 1/Rb;
fmin = 1e9; %Starting carrrier frequency
Fs = 50*fmin; %Sampling frequency
t = 0:1/Fs:T;
samples_symb = length(t); %Number of samples per symbol
fmax = 2*fmin; %Single octave operation
if N_sub > 1
    delta = (fmax - fmin)/(N_sub - 1); %Frequency spacing of any two
    consecutive subcarriers
else
    delta = 0;
end
K = 2*pi;
%***********GENERATION OF THE SUBCARRIER SIGNAL***********************
[Inphase,Quadrature,Datain] = Basebandmodulation(M,symb,N_sub);
Input1 = Inphase + (j*Quadrature); %The input symbols constellation
Ac = 1; %Subcarrier signals amplitude
M0 = [];M1 = [];
for i0 = 1:N_sub
    j0 = i0-1;
    XX = Ac.*cos(K.*t.*(fmin + (j0*delta)));
    XX1 = Ac.*sin(K.*t.*(fmin + (j0*delta)));
    M0 = [M0;XX];
    M1 = [M1;XX1];
end
for i1 = 1:N_sub
    I_phase =[];Q_phase = [];
    for j1 = 1:symb
        I_sig = Inphase(j1,i1).*M0(i1,:);
        I_phase = [I_phase,I_sig];

        Q_sig = Quadrature(j1,i1).*M1(i1,:);
        Q_phase = [Q_phase,Q_sig];
    end
    I_Mod_Data(i1,:) = I_phase;
    Q_Mod_Data(i1,:) = Q_phase;
end
PSK_sig = I_Mod_Data - Q_Mod_Data;
SIM = sum(PSK_sig,1); %subcarrier multiplexed signal
Mod_index = 1/(Ac*N_sub); %Modulation index
SCM_Tx = (1 + Mod_index*SIM); %The transmitted signal
%**********************THE CHANNEL PARAMETERS**************************
%************Turbulence parameters*****************
Io = 1; %Average received irradiance
I_var = 1e-3; %Log irradiance variance
I = Turbulence(I_var,symb,Io,t); %Irradiance using the Log normal turbulence model
SNR_dB = 2; %SNR value in dB
SNR = 10.^(SNR_dB./10);
Noise_var = (Mod_index*Responsivity*Io)^2./(SNR);
Noise_SD = sqrt(Noise_var);
%**********************RECEIVER DESIGN************************
%************Filtering to separate the subcarriers************
SCM_Rx = (Responsivity.*I.*SCM_Tx);
%SCM_Rx = (Responsivity.*SCM_Tx);

for i0 = 1:length(SNR)
    Noise =[];
    Noise = Noise_SD(i0).*randn(size(SCM_Tx));
    if Rb <= 0.5*delta || N_sub == 1
        for i1 = 1:N_sub
            j1 = i1 - 1; A1 = []; B1 = [];
            fc = fmin + j1*delta;
            f_Rb = Rb*2/Fs; %Normalised data rate (bandwidth of data)
            fcl = 2*(fc - Rb)/Fs; fch = (fc + Rb)*2/Fs; %Normalised cutoff frequencies
            w_bpf = [fcl,fch];
            [B1,A1] = butter(1,w_bpf);
            %*******Individual subcarrier signal plus noise*************
            filter_out(i1,:) = filter(B1,A1,SCM_Rx) + Noise;
            %*************Symbol-by-symbol Coherent Demodulation *******************
            for i2 = 1:symb
                j2 = i2 - 1;
                a2 = 1 + j2*samples_symb;
                b2 = i2*samples_symb;
                %*******Coherent demodulation******************
                I_Dem_out = (2*Ac.*cos(2.*pi.*t.*fc)).*filter_out(i1,a2:b2);
                Q_Dem_out = (2*Ac.*sin(2.*pi.*t.*fc)).*filter_out(i1,a2:b2);
                [B2,A2] = butter(2,f_Rb);
                %I_Dem_out2 = filter(B2,A2,I_Dem_out); %Q_Dem_out2 =
                filter(B2,A2,Q_Dem_out);
                I_Demod_out2(i1,a2:b2) = filter(B2,A2,I_Dem_out);
                Q_Demod_out2(i1,a2:b2) = filter(B2,A2,Q_Dem_out);
                I_symb_end(i1,i2) = I_Demod_out2(i1,end);
                Q_symb_end(i1,i2) = -Q_Demod_out2(i1,end);
            end
            Demod_out2(i1,:) = I_symb_end(i1,:) + (j.*Q_symb_end(i1,:));
        end
    else
        'ALIASING; subcarriers too close and or too low fmin for the Rb'
    end
end
%Scatter plot- giving the constellation plot
scatterplot(Input1(:,1))
title('The input symbols constellation')
scatterplot(Demod_out2(1,:))
title('The received symbols constellation')
%Note: The codes for the functions: Baseband modulation and turbulence
% are given at the end of the chapter


% ******************%Function Basebandmodulation%**************************
function [Inphase, Quadrature, X] = Basebandmodulation(M, symb, N_sub)
    % Generate random integers for symbols
    X = randi([0 M-1], symb, N_sub);

    % Create PSK modulator object with specified properties
    H = comm.PSKModulator(M, 'PhaseOffset', pi/4, 'SymbolMapping', 'Gray');

    % Modulate the signal
    Y = step(H, X(:));
    
    % Reshape the modulated signal to the original matrix form
    Y = reshape(Y, symb, N_sub);

    % Separate the in-phase and quadrature components
    Inphase = real(Y);
    Quadrature = imag(Y);
end
% ******************%Function Turbulence %**************************
function [I] = Turbulence(Log_Int_var,No_symb,Io,t)
%Log intensity Variance
Var_l = Log_Int_var;
% Number of symbols
%No_symb = 1e4;
%Log normal atmospheric turbulence
l = (sqrt(Var_l).*randn(1,No_symb)) - (Var_l/2);
I1 = Io.*exp(l);
for i = 1:No_symb
    a = 1+(i-1)*length(t);
    b = i*length(t);
    I(1,a:b) = I1(i);
end
end
