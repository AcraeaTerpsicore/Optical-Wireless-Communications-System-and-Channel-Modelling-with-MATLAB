clear;clc;

% Program 3.5: Matlab codes for simulation of Kim’s model

wavl = 830; %Wavelength in nm
Visibility = 0.1:0.1:50; %Visibility values in km
for i=1:length(Visibility)
    V = Visibility(i);
    if (V >=50)
        q = 1.6;
    elseif (V>=6) && (V<50)
        q = 1.3;
    elseif (V>=1)&&(V<6)
        q = 0.16*V + 0.34;
    elseif (V>=0.5)&&(V<1)
        q = V-0.5;
    else
        q = 0;
    end
    Att_coeff(i) = (3.91/V)*(wavl/550)^-q;
    Att_coeff_dB_km(i) = 10*Att_coeff(i)/log(10);
end
% Plot function
semilogy(Visibility,Att_coeff_dB_km)
xlabel('Visibility in km')
ylabel('Attenuation coeffient in dB/km')