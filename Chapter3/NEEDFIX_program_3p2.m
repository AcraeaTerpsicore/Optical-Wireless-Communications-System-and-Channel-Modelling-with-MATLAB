clear;clc;

% Calculation time too long

% Program 3:2: Matlab codes for plotting the optical power distribution 
% in a diffuse channel.

C=3e8*1e-9; %time will be measured in ns in the program
theta=70; % semi-angle at half power
m=-log10(2)/log10(cosd(theta)); %Lambertian order of emission
P_total=1; %Total normalised transmitted power
Adet=1e-4; %detector physical area of a PD
rho=0.8;%reflection coefficient
Ts=1; %gain of an optical filter;
index=1.5; %refractive index of a lens at a PD
FOV=60; %FOV of a receiver
G_Con=(index^2)/(sind(FOV).^2); %gain of an optical concentrator


h2=1;
h3=1;
h4=1;


P_total=1;%Total transmitted power
rho=0.8; %reflection coefficent
lx=5; ly=5; lz=2.15; % room dimension in meter
Nx=lx*30; Ny=ly*30; Nz=round(lz*30);% number of grid in each surface
dA=lz*ly/(Ny*Nz);% calculation grid area
x=linspace(-lx/2,lx/2,Nx);
y=linspace(-ly/2,ly/2,Ny);
z=linspace(-lz/2,lz/2,Nz);
[XR,YR,ZR] = meshgrid(x,y,-lz/2);
TP1=[0 0 lz/2]; % transmitter position
%%%%%%%%%%%%%%%calculation for wall 1%%%%%%%%%%%%%%%%%%
for ii=1:Nx
    for jj=1:Ny
        RP=[x(ii) y(jj) -lz/2];
        % receiver position vector
        h1(ii,jj)=0;
        % reflection from North face
        for kk=1:Ny
            for ll=1:Nz
                WP1=[-lx/2 y(kk) z(ll)];
                % point of incidence in wall
                D1=sqrt(dot(TP1-WP1,TP1-WP1));
                % distance from transmitter to WP1
                cos_phi= abs(WP1(3)-TP1(3))/D1;
                cos_alpha = abs(TP1(1)-WP1(1))/D1;
                D2=sqrt(dot(WP1-RP,WP1-RP));
                % distance from WP1 to receiver
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
% calculate channel gain (h2, h3 and h4) from other walls
P_rec_A1=(h1+h2+h3+h4)*P_total.*Ts.*G_Con;