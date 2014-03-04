%CLOSE & CLEAR
clear all;
close all;

%PARAMETRES
dT=0.001;
dX=0.1;
dY=0.1;

Tmax=0.8;
Xmax=10;
Ymax=10;
t0=0;
t=t0;
x=linspace(0,Xmax,Xmax/dX);
y=linspace(0,Ymax,Ymax/dY);

%DEFINITIONS CHAMPS DE VITESSE ET CONDITIONS LIMITES
vx=zeros(Xmax/dX,Ymax/dY);
vy=zeros(Xmax/dX,Ymax/dY);
a=zeros(Xmax/dX,Ymax/dY);

%vx(j,k)=1; vy(j,k)=1;
%vx(j,k)=k*dY; vy(j,k)=-j*dX;
for j=1:(Xmax/dX)
   for k=1:(Ymax/dY)
      vx(j,k)=k*dY;
      vy(j,k)=-j*dX;
      a(j,k) = 1 - abs(vx(j,k)) * dT/dX - abs(vy(j,k)) * dT/dY;
   end
end

n=zeros(Xmax/dX,Ymax/dY);
n2=n;
n(5:20,5:20)=1;

%BOUCLE DE RESOLUTION
while t<Tmax
    for j=2:(Xmax/dX-1)
        for k=2:(Ymax/dY-1)
            n2(j,k)=a(j,k)*n(j,k) + abs(vx(j,k))*n(j-1,k)* dT/dX + abs(vy(j,k))*n(j,k+1)*dT/dY;
        end
    end
n=n2;
t=t+dT;
surf(n);
drawnow
end
