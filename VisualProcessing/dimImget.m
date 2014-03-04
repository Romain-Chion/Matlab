%renvoie soit les dimensions caractéristiques de l'imagette

function [H,W] = dimImget(image)
H=floor(size(image.cdata,2)/3); %on pourra développer la fonction pour choisir des imagettes optimisées en taille et en information pour chaque image 
W=floor(size(image.cdata,1)/3);