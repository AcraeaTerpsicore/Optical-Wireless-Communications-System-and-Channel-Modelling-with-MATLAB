clear;clc;
% Test the generate_PPM function
M = 3; % Example bit resolution
nsym = 5; % Example number of PPM symbols

% Generate PPM sequence
PPM_sequence = generate_PPM(M, nsym);

% Display the generated PPM sequence
disp('Generated PPM sequence:');
disp(PPM_sequence);

% Plot the generated PPM sequence
figure;
stem(PPM_sequence, 'filled');
title('Generated PPM Sequence');
xlabel('Sample Index');
ylabel('Amplitude');

