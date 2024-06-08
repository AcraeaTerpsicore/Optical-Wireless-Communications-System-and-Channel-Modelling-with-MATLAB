%Evaluating the additional power (margin, m) needed to achieve a given
% outage probability, using the Chernoff upper bound. log-normal
% scintillation model used.

%PLOT CORRECT.


clear
clc
Rhol = [0.1,0.3,0.5,1]
ro = sqrt(Rhol); %Log intensity standard deviation
for j = 1: length(ro)
    r = ro(j);
    Pout = logspace(0,-10,50); %Outage probability
    for i = 1: length(Pout)
        Po = Pout(i);
        arg = sqrt(-2*r^2*log(2*Po)) + ((r^2)/2);
        mp(i) = exp(arg);
        margin(j,i) = 10*log10(mp(i)*1e3); %Power margin to achieve outage prob.; %in dBm.
    end
end
semilogy(margin,Pout)
xlabel('Power Margin (dBm)')
ylabel('Outage Probability')
title('SISO')
legend('$\sigma_I^2$=0.1','$\sigma_I^2$=0.3','$\sigma_I^2$=0.5','$\sigma_I^2$=1','Interpreter','LaTeX')
