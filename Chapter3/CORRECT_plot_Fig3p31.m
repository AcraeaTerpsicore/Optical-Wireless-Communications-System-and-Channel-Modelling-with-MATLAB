clear;clc;

%The gamma-gamma pdf
alpha_vec = [11.6, 4, 4.2];
beta_vec = [10.1, 1.9, 1.4];

figure
hold on

for sel=1:1:3
    a = alpha_vec(sel);
    b = beta_vec(sel);
    k = (a+b)/2;
    k1 = a*b;
    K =2*(k1^k)/(gamma(a)*gamma(b));
    I = 0.01:0.01:5;
    K1 = I.^(k-1);
    Z = 2*sqrt(k1*I);
    p = K.*K1.*besselk((a-b),Z);
    plot(I,p)
    xlabel('Irradince, I')
    ylabel('Gamma gamma pdf, p(I)')
end

legend('Weak $\alpha=11.6,\beta=10.1,\sigma_I^2=0.2$', ... 
    'Moderate $\alpha=4,\beta=1.9,\sigma_I^2=1.6$', ...
    'Strong $\alpha=4.2,\beta=1.4,\sigma_I^2=3.5$', ...
    'Interpreter','LaTeX')


title('The gamma-gamma pdf');