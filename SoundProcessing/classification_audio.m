%Fonction permettant de classifier des échantillons audio selon ses descripteurs

function [u,v,w] = classification_audio(x)
%x est un vecteur contenant les 9 descripteurs de l'extrait
%u, v et w renvoient la classe trouvée respectivement selon les K  plus
%proche voisins Euclidiens, Mahalanobis et la méthode Bayésienne.

%INITIALISATION*

load('classe','classe');
load('data','m_descripteurs');
C=pinv(cov(m_descripteurs))

proba=zeros(max(classe),1);
dens=proba;
counte=proba;
countm=counte;
countb=counte;

K=7;
voisinse=zeros(K,1);
voisinsm=voisinse;
y=zeros(length(x),1);

De=zeros(length(m_descripteurs),1);
Dm=De;

%APPRENTISSAGE

    %PROBABILITE DES CLASSES
    for i = 1:length(proba)
        proba(i)=sum(classe==i);
    end
    proba=proba/sum(proba);
    
    %DENSITE DE PROBABILITE
    [~,index]=unique(classe);
    moy=mean(m_descripteurs(1:index(1),:));
    sigma=std(m_descripteurs(1:index(1),:));
    dens(1)=exp(-(x-moy)*sigma*(x-moy).'/2)/sqrt((2*pi)^(length(x))/det(sigma));
    for i=2:length(moy)
        moy=mean(m_descripteurs(index(i-1):index(i),:))
        sigma=pinv(cov(m_descripteurs(index(i-1):index(i))))
        dens(i)=exp(-(x-moy)*sigma*(x-moy).'/2)/sqrt((2*pi)^(length(x))/det(sigma));
    end


%RECONNAISSANCE

    %K PLUS PROCHE VOISIN
    
    %CALCUL DES DISTANCES
    for i=1:length(m_descripteurs)
        y=m_descripteurs(i,:);
        De(i)=(y-x)*(y-x).';
        Dm(i)=(y-x)*C*(y-x).';
    end

    %RECHERCHE DES VOISINS
    [~,Indexe]=sort(De);
    [~,Indexm]=sort(Dm);
    
    voisinse=Indexe(1:K);
    voisinsm=Indexm(1:K);
    
    %RECHERCHE DE LA CLASSE
    for i=1:K
        counte(classe(voisinse(i)))=counte(classe(voisinse(i)))+1;
        countm(classe(voisinsm(i)))=countm(classe(voisinsm(i)))+1;
    end
    [~,u]=max(counte);
    [~,v]=max(countm);


    %BAYESIEN
    for i=1:length(dens)
        countb(i)=dens(i)*proba(i);
    end
    [~,w]=max(countb);
end


