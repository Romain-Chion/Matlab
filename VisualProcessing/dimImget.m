%renvoie soit les dimensions caract�ristiques de l'imagette

function [H,W] = dimImget(image)
H=floor(size(image.cdata,2)/3); %on pourra d�velopper la fonction pour choisir des imagettes optimis�es en taille et en information pour chaque image 
W=floor(size(image.cdata,1)/3);