%Fonction permettant de calculer et d'enregistrer tous les descripteurs
%pour tous les échantillons.

function [centroides,etendue,asymetrie,kurtosis,ptcoupure,centroidet,energieglob,deff,zcr] = descripteurs()

%LISTE DES REPERTOIRES
rep{1}='Anxiousness/';
rep{2}='Contentment/';
rep{3}='Depression/';
rep{4}='Exuberance/';

DIM=zeros(length(rep)+1,1);

    for i = 1:length(rep)
        %OBTENTION DES DIMENSIONS
        DIM(i+1)=DIM(i)+length(dir(strcat(rep{i},'*.wav')));
    end

    classe=zeros(DIM(length(rep)+1),1);

    %INITIALISATION DESCRIPTEURS
    centroides=classe;
    etendue=classe;
    asymetrie=classe;
    kurtosis=classe;
    ptcoupure=classe;

    centroidet=classe;
    deff=classe;
    energieglob=classe;

    zcr=classe;

    for i = 1:length(rep)
        d=rep{i};
        %LISTE DES FICHIERS SONS
        flist=dir(strcat(d,'*.wav'));

        for j=1:length(flist);
            classe(j+DIM(i))=i;
            n=strcat(d,flist(j).name);
            [s,ve,res]=wavread(n);
        
            %DESCRIPTEURS SPECTRAUX
            
            %CALCUL SPECTRE
            S=fft(s);
            S=S(1:length(S)/2);
            Sp=S.*conj(S);

            %CALCUL CENTROIDE SPECTRAL
            %on fait une simple moyenne puisque Sp est à intervalle df régulier.
            p0=length(Sp)/sum(Sp);
            for k=1:length(Sp)
                p=Sp(k)*p0;
                centroides(j+DIM(i))=centroides(j+DIM(i))+k*p;
            end
            centroides(j+DIM(i))=centroides(j+DIM(i))/length(Sp);

            %CALCUL ETENDUE, ASYMETRIE ET KURTOSIS
            df=ve/(2*length(Sp));
            for k=1:length(Sp)
                p=Sp(k)*p0;
                z=(k*df-centroides(j+DIM(i)));
                etendue(j+DIM(i))=etendue(j+DIM(i))+z*z*p;
                asymetrie(j+DIM(i))=asymetrie(j+DIM(i))+z*z*z*p;
                kurtosis(j+DIM(i))=kurtosis(j+DIM(i))+z*z*z*z*p;
            end
            etendue(j+DIM(i))=df*etendue(j+DIM(i))/length(Sp);
            asymetrie(j+DIM(i))=df*asymetrie(j+DIM(i))/length(Sp);
            kurtosis(j+DIM(i))=df*kurtosis(j+DIM(i))/length(Sp);

            %CALCUL POINT DE COUPURE
            k=1;
            summ=Sp(k);
            lim=0.95*sum(Sp)/length(Sp);
            while (summ<lim)&&(k<length(Sp))
                summ=(k*summ+Sp(k+1))/(k+1);
                k=k+1;
            end
            ptcoupure(j+DIM(i))=k*df;

            %DESCRIPTEURS TEMPORELS

            %CALCUL ENVELOPPE
            dT=0.02;                        %durée d'une fenêtre
            nef=floor(dT*ve);               %nombre d'échantillons dans une fenêtre
            nfs=floor(length(s)/(ve*dT));   %nombre de fenêtre dans s (recouvrement 0%)
            En=zeros(2*nfs,1);
            En(1)=rms(s(1:nef));          %méthode for
            for k=1:(nfs-1)
                s1=s(k*nef+1:(k+1)*nef);
                s2=s((k-0.5)*nef+1:(k+0.5)*nef);
                En(2*k)=rms(s1);
                En(2*k+1)=rms(s2);
            end
    %         k=0;
    %         while (k<nfs-0.5)         %méthode while
    %             x=s(k*nef:(k+1)*nef-1);
    %             k=k+0.5;
    %             En(2*k)=rms(x);
    %         end

            %CALCUL CENTROIDE, ENERGIE ET DUREE
            thr=0.1*max(En);
            for k=1:length(En)
                centroidet(j+DIM(i))=centroidet(j+DIM(i))+En(k)*(k+0.5)*dT;
                energieglob(j+DIM(i))=energieglob(j+DIM(i))+En(k);
                if (thr<En(k))
                    deff(j+DIM(i))=deff(j+DIM(i))+dT;
                end
            end
            centroidet(j+DIM(i))=centroidet(j+DIM(i))/sum(En);
            energieglob(j+DIM(i))=energieglob(j+DIM(i))/length(En);

            %DESCRIPTEURS BRUTES

            %CALCUL TAUX DE PASSAGE PAR ZERO
            for k=2:length(s)
                zcr(j+DIM(i))=zcr(j+DIM(i))+0.5*abs(sign(s(k-1))-sign(s(k)));
            end
        end
    end
m_descripteurs = [centroides,etendue,asymetrie,kurtosis,ptcoupure,centroidet,energieglob,deff,zcr];
save('classe','classe');
save('data','m_descripteurs');
end