% création d'une signature pour une unique pub
% retourne la matrice des h, w, et DeltaT
function [S] = signature(Path)

%chargement de la vidéo
Pub=VideoReader(Path);

%séquençage des plans;
img1.cdata=read(Pub,1);
img2.cdata=read(Pub,1);
k=1;
n=0;
m=0;
T=zeros(Pub.NumberOfFrames,1);
T(1)=1;
for i=1:Pub.NumberOfFrames;
    img1.cdata=img2.cdata;
    img2.cdata=read(Pub,i);
    [~,n]=compGeo(img1,img2,2);
%     [~,m]=compHisto(img1,img2);
    if n+m<0.5 %une étude devrait être nécessaire pour déterminer le meilleur rapport entre n, m et valeur de seuil.
        k=k+1;
        T(k)=i;
    end
end

%initialisation de la signature;
T=T(1:k)
deltaT=zeros(k-1,1);
W=zeros(k-1,1);
H=zeros(k-1,1);

%détection d'images médianes;
for i=2:k
    for j=T(i-1):T(i);
        X(:,:,:,j) = read(Pub,j);
    end
    Y.cdata=median(X,4);
    D=zeros(T(i)-T(i-1)+1,1);
    for j=T(i-1):T(i);
        Z.cdata = X(:,:,:,j);
        [~,D(j)]=compGeo(Y,Z,2);
%         D(j)=D(j)+compHisto(Y,Z);
    end
    [~,deltaT(i-1)]=max(D);
end
deltaT
%création d'imagettes;
for i=1:k-1
    img.cdata=read(Pub,deltaT(i));
    [H(i),W(i)]=dimImget(img);
end

S=[deltaT,H,W];