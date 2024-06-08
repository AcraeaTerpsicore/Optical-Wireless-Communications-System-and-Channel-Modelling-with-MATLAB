clear;clc;


% Test code
M = 3; % Bit resolution
nsym = 10; % Number of symbols
NGS = 2; % Number of guard slots

% Generate DPIM sequence
DPIM = generate_DPIM(M, nsym, NGS);

% Plot the DPIM sequence
figure;
stem(DPIM, 'filled');
title('DPIM Sequence');
xlabel('Time');
ylabel('Amplitude');
grid on;

% Display the DPIM sequence
disp('Generated DPIM sequence:');
disp(DPIM);