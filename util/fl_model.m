% Program 3.4: Matlab codes for the FLI simulation model.

function i_elect= fl_model(Ib,samp_int,start_time,end_time)
% Generates a zero mean photocurrent, with maximum value i_max
global i_low i_high
t=start_time:samp_int:end_time;
no_of_points=length(t);
%***** low-frequency component *****
i=1:20;
p1=[4.65 2.86 5.43 3.90 2.00 5.98 2.38 4.35 5.87 0.70...
    1.26 1.29 1.28 0.63 6.06 5.49 4.45 3.24 2.07 0.87];
p2=[0.00 0.08 6.00 5.31 2.27 5.70 2.07 3.44 5.01 6.0...
    6.00 6.17 5.69 5.37 4.00 3.69 1.86 1.38 5.91 4.88];
b=10.^((-13.1*log((100*i)-50)+27.1)/20);
c=10.^((-20.8*log(100*i)+92.4)/20);
A3=5.9;
i_low=zeros(1,no_of_points);
for loop=1:no_of_points
    i_low(loop)=(Ib/A3)*sum(b.*cos(2*pi*(100*i-50)*...
        t(loop)+p1)+c.*cos(2*pi*100*i*t(loop)+p2));
end

%% ***** high-frequency component *****
j=[1 2 4 6 8 10 12 14 16 18 20 22];
d_db=[-22.2 0.00 -11.5 -30.0 -33.9 -35.3 -39.3 -42.7 -46.4 -48.1 -53.1 -54.9];
d=10.^(d_db/10); % convert from log to linear
thetaj=[5.09 0.00 2.37 5.86 2.04 2.75 3.55 4.15 1.64 4.51 3.55 1.78];
f_high=37500;
A4=2.1;
i_high=zeros(1,no_of_points); % preallocate array
for loop=1:no_of_points
    i_high(loop)=(Ib/A4)*sum(d.*cos(2*pi*f_high*j*t(loop)+thetaj));
end
i_elect=i_low+i_high;
end