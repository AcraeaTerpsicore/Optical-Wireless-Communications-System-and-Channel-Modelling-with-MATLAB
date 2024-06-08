clear;clc;


% Program 8.3: Matlab codes to calculate D_{rms} values at different receiver positions.

%%
C=3e8*1e-9; % the time is measured in ns
theta=70; % the semi-angle at half power
m=-log10(2)/log10(cosd(theta)); %Lambertian order of emission;
P_total=1; % the total transmitted power
Adet=1e-4; % the detector physical area of a PD
rho=0.8; % the reflection coefficient
Ts=1; % the gain of an optical filter; ignore if no filter is used
index=1.5; % the refractive index of a lens at a PD; ignore if no lens is used
FOV=60; % FOV of the receiver
G_Con=(index^2)/(sind(FOV).^2); % the gain of an optical concentrator;
lx=5; ly=5; lz=3-0.85;% the room dimensions all in meter
Nx=lx*10; Ny=ly*10; Nz=round(lz*10); % the number of grid in each surface
dA=lz*ly/((Ny)*(Nz));% calculating the grid area
x=linspace(-lx/2,lx/2,Nx);
y=linspace(-ly/2,ly/2,Ny);
z=linspace(-lz/2,lz/2,Nz);
%% transmitter’s position
TP1=[-lx/4 -ly/4 lz/2];
TP2=[ lx/4 ly/4 lz/2];
TP3=[ lx/4 -ly/4 lz/2];
TP4=[-lx/4 ly/4 lz/2];
TPV=[0 0 -1];% the transmitter position vector
RPV=[0 0 1]; % the receiver position vector
%%
WPV1=[1 0 0];
WPV2=[0 1 0];
WPV3=[-1 0 0];
WPV4=[0 -1 0];
delta_t=1/2; % the time resolution in ns, use in the form of 1/2^m
for ii=1:Nx
    for jj=1:Ny
        RP=[x(ii) y(jj) -lz/2];
        t_vector=0:30/delta_t; % time vector in ns
        h_vector=zeros(1,length(t_vector));
        % the receiver position vector
        % the LOS channel gain
        D1=sqrt(dot(TP1-RP,TP1-RP));
        cosphi= lz/D1;
        tau0=D1/C;
        index=find(round(tau0/delta_t)==t_vector);
        if abs(acosd(cosphi))<=FOV
            h_vector(index)=h_vector(index)+(m+1)*Adet.*cosphi.^(m+1)./(2*pi.*D1.^2);
        end
        %% the reflection from first wall
        count=1;
        for kk=1:Ny
            for ll=1:Nz
                WP1=[-lx/2 y(kk) z(ll)];
                D1=sqrt(dot(TP1-WP1,TP1-WP1));
                cos_phi= abs(WP1(3)-TP1(3))/D1;
                cos_alpha = abs(TP1(1)-WP1(1))/D1;

                D2=sqrt(dot(WP1-RP,WP1-RP));
                cos_beta=abs(WP1(1)-RP(1))/D2;
                cos_psi=abs(WP1(3)-RP(3))/D2;
                tau1=(D1+D2)/C;
                index=find(round(tau1/delta_t)==t_vector);
                if abs(acosd(cos_psi))<=FOV
                    h_vector(index)=h_vector(index)+(m+1)*Adet*rho*dA*...
                        cos_phi^m*cos_alpha*cos_beta*cos_psi/(2*pi^2*D1^2*D2^2);
                end
                count=count+1;
            end
        end
        % calculate the h_vector from all the walls and all the transmitters.
        %%
        t_vector=t_vector*delta_t;
        mean_delay(ii,jj)=sum((h_vector).^2.*t_vector)/sum(h_vector.^2);
        Drms(ii,jj)= sqrt(sum((t_vector-mean_delay(ii,jj)).^2.*h_vector.^2)/sum(h_vector.^2));
    end
end
surf(x,y, Drms);
%surf(x,y,mean_delay);
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(Drms)) max(max(Drms))]);