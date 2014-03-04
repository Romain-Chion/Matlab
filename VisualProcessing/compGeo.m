% Comparaison g�om�trique (logique) de deux images binaires dilat�es
% Retourne la matrice de similarit� et l'indice de similarit� D

% Pub1 = VideoReader('Pub_C+_176_144.mp4');
% img1.cdata = read(Pub1,1026);
% img2.cdata = read(Pub1,1027);
% img3.cdata = read(Pub1,1028);

function [matrice,D] = compGeo(img1,img2,b) % b = 0 : Affichage des images cr�es, b = 1 : XOR, b <> 1 : AND

%cr�ation des images de contour
contour1=edge(rgb2gray(img1.cdata),'canny');
contour2=edge(rgb2gray(img2.cdata),'canny');

%�paississement des contours
se=strel('square',5); %carr� de 5*5 pixel
    dil1=imdilate(contour1,se);
    dil2=imdilate(contour2,se);

%initialisation des param�tres
matrice = zeros(size(dil1,1),size(dil1,2));
D=0; % indice de similarit�
k=0; % nombre de pixels blancs communs aux deux images binaris�es
u=sum(sum(dil1));
v=sum(sum(dil2));

%application de la comparaison
if b %comparaison XOR
    matrice=xor(dil1,dil2);
    k=sum(sum(matrice));
    D= 1-k/(u+v); % rapport entre le nombre de pixels diff�rents et le nombre moyens de pixels blancs initiaux
else %comparaison AND
    matrice=dil1.*dil2;
    k=sum(sum(matrice));
    D=k/min(u,v); % rapport entre le nombre de pixels blancs communs et le plus petit nombre de pixels blancs initiaux
end
if not(b)
    figure; imshow(image1);
    figure; imshow(image2);
    figure; imshow(contour1);
    figure; imshow(contour2);
    figure; imshow(dil1);
    figure; imshow(dil2);
    figure; imshow(matrice);
end
