%CLOSE & CLEAR
clear all;
close all;

%PARAMETRES
dT=0.1;
dX=0.1;
dY=0.1;

Tmax=10;
Xmax=10;
Ymax=10;
t0=0;
t=t0;
x=linspace(0,Xmax,Xmax/dX);
y=linspace(0,Ymax,Ymax/dY);

%[Y X] = meshgrid(y,x);
%NX=X./sqrt(X.^2+Y.^2);
%NY=Y./sqrt(X.^2+Y.^2);

%DEFINITIONS CHAMPS DE VITESSE ET CONDITIONS LIMITES
vx=1;
vy=1;
b=[vx vy];
a = 1 - abs(vx) * dT/dX - abs(vy) * dT/dY;
n=0.;
n2=n;

%BOUCLE DE RESOLUTION
while t<Tmax
    
    for j=2:(Xmax/dX-1)
        for k=2:(Ymax/dY-1)
            n2(j,k)=a*n(j,k) + vx*n(j-1,k)* dT/dX +vy*n(j,k-1)*dT/dY;
        end
    end
n=n2;
t=t+dT;
surf(n);
DRAWNOW;
end
