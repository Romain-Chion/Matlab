%création d'une imagette à partir des dimensions caractéristiques contenues
%dans la signature

function imagette = creaImget(image,H,W)

%cette fonction dépend de l'algorithme considéré et du choix des dimensions pour une imagette
%on choisit ici une simple image centrée de dimension H et W

imagette.cdata = zeros(H,W);
i0=floor(size(image,1)-(H/2));
j0=floor(size(image,2)-(W/2));
for i = 0:H
    for j = 0:W
    imagette.cdata(i,j,0)=image.cdata(i+i0,j+j0,0);
    imagette.cdata(i,j,1)=image.cdata(i+i0,j+j0,1);
    imagette.cdata(i,j,2)=image.cdata(i+i0,j+j0,2);
    end
end
