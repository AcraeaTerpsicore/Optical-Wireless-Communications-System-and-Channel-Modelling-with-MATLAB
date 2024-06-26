clear;clc;


% Program 3.1: Matlab codes to calculate the LOS channel gain.

theta=70; % semi-angle at half power
m=-log10(2)/log10(cosd(theta)); %Lambertian order of emission
P_total=20; %tranmistted optical power by individeal LED
Adet=1e-4; %detector physical area of a PD
%% Optics parameters
Ts=1; %gain of an optical filter; ignore if no filter is used
index=1.5; %refractive index of a lens at a PD; ignore if no lens is used
FOV=60*pi/180; %FOV of a receiver
G_Con=(index^2)/sin(FOV); %gain of an optical concentrator
%% Room dimension
lx=5; ly=5; lz=3; % room dimension in meter
h=2.15; %the distance between source and receiver plane
Nx=lx*20; Ny=ly*20;% number of grid in the receiver plane
XT=0; YT=0;% position of LED;
x=-lx/2:lx/Nx:lx/2;
y=-ly/2:ly/Ny:ly/2;
[XR,YR]=meshgrid(x,y); % receiver plane grid
D1=sqrt((XR-XT(1,1)).^2+(YR-YT(1,1)).^2+h^2);
% distance verctor from source 1
cosphi_A1=h./D1; % angle vector
%%
H_A1=(m+1)*Adet.*cosphi_A1.^(m+1)./(2*pi.*D1.^2);
% channel DC gain for source 1
P_rec=P_total.*H_A1.*Ts.*G_Con; % received power from source 1;
P_rec_dBm=10*log10(P_rec);
meshc(x,y,P_rec_dBm);
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Received power (dBm)');
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(P_rec_dBm)) max(max(P_rec_dBm))]);