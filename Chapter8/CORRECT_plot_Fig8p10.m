clear;clc;


% Program 8.1: Matlab codes to calculate the optical power distribution
% of a LOS link at the receiving plane for a typical room.


%% opto-electical parameters
theta=70; % the semi-angle at half power

theta=12.5; % the semi-angle at half power


ml=-log10(2)/log10(cosd(theta)); %Lambertian order of emission
P_LED=20; %the tranmist optical power by individual LED
nLED=60; % the total number of LED array in each cluster (nLED*nLED)
P_total=nLED*nLED*P_LED; %the total transmitted power
Adet=1e-4; %the detector physical area of a PD
Ts=1; %the gain of an optical filter; ignore if no filter is used
index=1.5; %the refractive index of a lens at a PD; ignore if no lens is used
FOV=70; %the FOV of the receiver
G_Con=(index^2)/(sind(FOV).^2); %the gain of an optical concentrator; ignore if no lens is used
%% room parameters
lx=5; ly=5; lz=3;% the room dimensions in meter
h=2.15; %the distance between the source and the receiver plane
[XT,YT] = meshgrid([-lx/4 lx/4],[-ly/4 ly/4]);
% the position of an LED; it is assumed that all LEDs are located at the same %point for the faster simulation
% for one LED simulation located at the centre of the room, use XT=0 and YT=0
Nx=lx*20; Ny=ly*20; % the number of grid in the receiver plane, larger the number, better is the approximation but takes longer time
x=linspace(-lx/2,lx/2,Nx);
y=linspace(-ly/2,ly/2,Ny);
[XR,YR]=meshgrid(x,y);
%% simulation for sournce one
D1=sqrt((XR-XT(1,1)).^2+(YR-YT(1,1)).^2+h^2); % the distance vector fromthe source 1
cosphi_A1=h./D1; % the angle vector
recevier_angle=acosd(cosphi_A1);
H_A1=(ml+1)*Adet.*cosphi_A1.^(ml+1)./(2*pi.*D1.^2); % the channel DC gain for source 1
P_rec_A1=P_total.*H_A1.*Ts.*G_Con;% the received power from source 1;
P_rec_A1(find(abs(recevier_angle)>FOV))=0;
%% assuming symmetric property, no need to calculate other power
% if the transmitter is not symmetrical, you need to calculate power for individual LEDs
P_rec_A2=fliplr(P_rec_A1);
P_rec_A3=flipud(P_rec_A1);
P_rec_A4=fliplr(P_rec_A3);
P_rec_total=P_rec_A1+P_rec_A2+P_rec_A3+P_rec_A4;
P_rec_dBm=10*log10(P_rec_total);
%%
figure
surfc(x,y,P_rec_dBm);
% contour(x,y,P_rec_dBm);hold on; % mesh(x,y,P_rec_dBm);
