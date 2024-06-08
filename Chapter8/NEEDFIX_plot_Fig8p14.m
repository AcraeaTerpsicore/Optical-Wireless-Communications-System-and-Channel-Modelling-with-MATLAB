clear;clc;




theta=70; % the semi-angle at half power
m=-log10(2)/log10(cosd(theta)); %Lambertian order of emission
P_LED=20; %tranmistted optical power by individeal LED
nLED=60; % number of LED array nLED*nLED
P_total=nLED*nLED*P_LED; %Total transmitted power
Adet=1e-4; %detector physical area of a PD
rho=0.8; %reflection coefficent
Ts=1; %gain of an optical filter; ignore if no filter is used
index=1.5; %refractive index of a lens at a PD; ignore if no lens is used
FOV=70; %FOV of a receiver
G_Con=(index^2)/(sind(FOV).^2);
%gain of an optical concentrator; ignore if no lens is used
%% room dimension
lx=5; ly=5; lz=2.15; % room dimension in meter
[XT,YT,ZT] = meshgrid([-lx/4 lx/4],[-ly/4 ly/4],lz/2);
% position of Transmitter (LED);
Nx=lx*10; Ny=ly*10; Nz=round(lz*10);
% number of grid in each surface
dA=lz*ly/(Ny*Nz); % calculation grid area
x=linspace(-lx/2,lx/2,Nx);
y=linspace(-ly/2,ly/2,Ny);
z=linspace(-lz/2,lz/2,Nz);
[XR,YR,ZR] = meshgrid(x,y,-lz/2);
%% %first transmitter calculation
TP1=[0 0 lz/2]; % transmitter position
TPV=[0 0 -1]; % transmitter position vector
RPV=[0 0 1]; % receiver position vector
%% %%%%%%%%%%%calculation for wall 1%%%%%%%%%%%%%%%%%%
WPV1=[1 0 0]; % position vector for wall 1
for ii=1:Nx
    for jj=1:Ny
        RP=[x(ii) y(jj) -lz/2]; % receiver position vector
        h1(ii,jj)=0; % reflection from North face
        for kk=1:Ny
            for ll=1:Nz
                WP1=[-lx/2 y(kk) z(ll)];
                D1=sqrt(dot(TP1-WP1,TP1-WP1));
                cos_phi= abs(WP1(3)-TP1(3))/D1;
                cos_alpha = abs(TP1(1)-WP1(1))/D1;
                D2=sqrt(dot(WP1-RP,WP1-RP));
                cos_beta=abs(WP1(1)-RP(1))/D2;
                cos_psi=abs(WP1(3)-RP(3))/D2;
                if abs(acosd(cos_psi))<=FOV
                    h1(ii,jj)=h1(ii,jj)+(m+1)*Adet*rho*dA*...
                        cos_phi^m*cos_alpha*cos_beta*cos_psi/(2*pi^2*D1^2*D2^2);
                end
            end
        end
    end
end
WPV2=[0 1 0]; % position vector for wall 2


h2=h1;
h3=h1;
h4=h1;


% the position vector for wall 2; %% calculation of the channel gain is similar to wall1
P_rec_total_1ref=(h1+h2+h3+h4)*P_total.*Ts.*G_Con;
P_rec_1ref_dBm=10*log10(P_rec_total_1ref);
figure(1)
surf(x,y,P_rec_1ref_dBm)