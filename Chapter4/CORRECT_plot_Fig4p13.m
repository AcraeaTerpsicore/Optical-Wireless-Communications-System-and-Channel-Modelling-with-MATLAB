clear;clc;

% Program 4.10: Matlab codes to calculate PSD of DPIM(0GS)

Rb = 1; % normalised bit rate
Tb = 1/Rb; % bit duration

L_values = [4, 8, 16, 32]; % Different symbol lengths

figure;
hold on;

for M=2:5 % Looping through different M values for L=4,8,16,32
    L=2^M; % symbol length
    Lavg=0.5*(2^M+1); % average symbol length
    p_avg=1; % average optical power
    R=1; % photodetector responsivity
    a=R*Lavg*p_avg; % electrical pulse amplitude
    Ts=M/(Lavg*Rb); % slot duration
    Rs=1/Ts; % slot rate
    df = Rs/100; % spectral resolution
    f = 0:df:8*Rb;
    x=f*Ts;
    %% ***** Calculate ACF *****
    r(1)=2/(L+1); k=0;
    for k=1:L
        r(k+1)=(2/(L^k))*((L+1)^(k-2));
    end
    for k=L+1:5*L
        temp=0;
        for i=1:L
            temp=temp+r(k-i+1);
        end
        r(k+1)=(1/L)*temp;
    end
    for k=(5*L)+1:1000
        r(k)=(1/Lavg)^2;
    end
    P_sq=(a*Ts)^2*(abs(sinc(f*Ts))).^2;
    term2=0;
    for ii=1:length(r)-1
        term2=term2+((r(ii+1)-((1/Lavg)^2))*cos(2*ii*pi*f*Ts));
    end
    p=(1/Ts)*P_sq.*((r(1)-1/Lavg^2)+2*term2);
    % p=p/(((p_avg*R)^2)*Tb);

    % Plotting the PSD for each L
    plot(f, p, 'DisplayName', ['L = ', num2str(L)]);
end

% Customizing the plot
title('Power Spectral Density (PSD) of DPIM(0GS)');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
legend;
grid on;
hold off;
