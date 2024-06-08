clear;clc;

% Program 4.7: Matlab codes to calculate the analytical PSD of PPM


% Program to calculate the analytical PSD of PPM for different L values
Rb = 1; % normalised bit rate
Tb = 1/Rb; % bit duration
M=4; % Bit resolution
L_values = [4, 8, 16]; % symbol lengths to be analyzed
p_avg=1; % average optical power
R=1; % photodetector responsivity

figure;
hold on;

for L = L_values
    a = R * L * p_avg; % electrical pulse amplitude
    Ts = M / (L * Rb); % slot duration
    Rs = 1 / Ts; % slot rate
    df = Rs / 1000; % spectral resolution
    f = 0:df:8 * Rb; % frequency range
    P_sq = (a * Ts)^2 * (abs(sinc(f * Ts))).^2;
    temp1 = 0;
    for k = 1:L-1
        temp1 = temp1 + (k/L-1) .* cos(k * 2 * pi * f * Ts);
    end
    S_c = (1 / (L * Ts)) * (((L-1) / L) + (2 / L) * temp1);
    S = P_sq .* S_c;
    S = S / (((p_avg * R)^2) * Tb);
    
    % Plot the Power Spectral Density
    plot(f, S, 'DisplayName', ['L = ', num2str(L)]);
end

xlabel('Frequency (Hz)   $f/R_b$','Interpreter','LaTeX');
ylabel('Power Spectral Density (PSD) $S(f)/(RP_{{avg}})^2 T_b$','Interpreter','LaTeX');
title('Analytical PSD of PPM for L=4,8 and 16');
grid on;
legend('show');
hold off;
