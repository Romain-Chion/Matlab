% detecte la pub en cours de flux
% retourne la densité de probabilité discrète que chaque signature corresponde à la pub en cours
%Signatures est un vecteur de matrices, Stream la pub en cours, BDD les
%pubs en base de donnée

function P = detectionPub(Signatures,Stream)

%Stream = VideoReader('Pub_C+_176_144.mp4');
BDD = [VideoReader('Pub_C+_352_288_1.mp4')];

% initialisation
P=zeros(size(Signatures,1),size(Signatures(1),1)); %on considère que toutes les signatures ont la même taille par exemple en complètant avec des zéros
Taux=zeros(size(Signatures,1),1);

% début de l'itération selon les signatues
for i=1:size(Signatures,2)
    deltaT=Signatures(:,1,i);
    H=Signatures(:,2,i);
    W=Signatures(:,3,i);
    % début de l’itération selon les timecodes
    j=1;
    while j<size(deltaT,1)&&(deltaT(j)>0)
        % récupération de l’image au timecode
        img1.cdata = read(VideoReader(Stream),deltaT(j));
        % création d’une imagette à partir de h et w
        imget1=creaImget(img1,H(j),W(j));
        % comparaison de l’imagette avec la BDD
        img2.cdata = read(BDD(i),T(j));
        imget2=creaImget(img2,H(j),W(j));
        % vecteur de proba
        [~,n]=compGeo(imget1,imget2,2);
        [~,m]=compHisto(imget1,imget2);
        P(i,j)= n+m/2;
        Taux(i)= Taux(i)+(n+m)/2;
        j=j+1;
    end % fin des itérations, on pourra utiliser une boucle while pemettant d'arreter le calcul après quelques itérations si P est trop faible ou trop élevé
    Taux(i)=Taux(i)/j;
end