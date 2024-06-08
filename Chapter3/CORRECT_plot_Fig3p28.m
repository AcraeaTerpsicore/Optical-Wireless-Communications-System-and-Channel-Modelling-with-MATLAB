clear;clc;
% Program 3.6: Matlab codes for the log-normal pdf.


%PDF of log-normal distribution
% E[I] value
Io = 1;
I = 0:0.005:3; %Log irradiance variance values
Var_l = [0.1,0.2,0.5,0.8];
for i = 1:length(Var_l)
 for j = 1:length(I)
 B = sqrt(2*pi*Var_l(i));
 C(j) = log(I(j)/Io) + (Var_l(i)/2);
 D = 2*Var_l(i);
 pdf(i,j)=(1/I(j))*(1/B)*exp(-((C(j))^2)/D);
 end
end
%plot function
plot((I./Io),pdf)
xlabel('Noramlsied Irradiance, I/E[I]')
ylabel('p(I)')
legend('$\sigma_I^2$=0.1','$\sigma_I^2$=0.2','$\sigma_I^2$=0.5','$\sigma_I^2$=0.8','Interpreter','LaTeX')
title('the log-normal pdf');