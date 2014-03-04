%CLOSE & CLEAR
clear all;
close all;

%PARAMETRES
dT=0.002;
dX=0.1;
dY=0.1;

Tmax=1;
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

n=zeros(Xmax/dX,Ymax/dY);
n2=n;
n(40:60,40:60)=1;

%BOUCLE DE RESOLUTION
while t<Tmax
    for j=1:(Xmax/dX)
        for k=1:(Ymax/dY)
            vx(j,k)=0.01*t*cos(t)-j*dX;
            vy(j,k)=0.01*t*sin(t)-k*dY;
            a(j,k) = 1 - abs(vx(j,k)) * dT/dX - abs(vy(j,k)) * dT/dY;
        end
    end
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
