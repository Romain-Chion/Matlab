%Fonction permettant de calculer les descripteurs d'un signal.

function x = description(n)

    %INITIALISATION DESCRIPTEURS
    centroides=0;
    etendue=0;
    asymetrie=0;
    kurtosis=0;
    ptcoupure=0;

    centroidet=0;
    deff=0;
    energieglob=0;

    zcr=0;

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
            centroides=centroides+k*p;
        end
        centroides=centroides/length(Sp);

        %CALCUL ETENDUE, ASYMETRIE ET KURTOSIS
        df=ve/(2*length(Sp));
        for k=1:length(Sp)
            p=Sp(k)*p0;
            z=(k*df-centroides);
            etendue=etendue+z*z*p;
            asymetrie=asymetrie+z*z*z*p;
            kurtosis=kurtosis+z*z*z*z*p;
        end
        etendue=df*etendue/length(Sp);
        asymetrie=df*asymetrie/length(Sp);
        kurtosis=df*kurtosis/length(Sp);

        %CALCUL POINT DE COUPURE
        k=1;
        summ=Sp(k);
        lim=0.95*sum(Sp)/length(Sp);
        while (summ<lim)&&(k<length(Sp))
            summ=(k*summ+Sp(k+1))/(k+1);
            k=k+1;
        end
        ptcoupure=k*df;

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
    %     k=0;
    %     while (k<nfs-0.5)         %méthode while
    %         x=s(k*nef:(k+1)*nef-1);
    %         k=k+0.5;
    %         En(2*k)=rms(x);
    %     end

        %CALCUL CENTROIDE, ENERGIE ET DUREE
        thr=0.1*max(En);
        for k=1:length(En)
            centroidet=centroidet+En(k)*(k+0.5)*dT;
            energieglob=energieglob+En(k);
            if (thr<En(k))
                deff=deff+dT;
            end
        end
        centroidet=centroidet/sum(En);
        energieglob=energieglob/length(En);

        %DESCRIPTEURS BRUTES

        %CALCUL TAUX DE PASSAGE PAR ZERO
        for k=2:length(s)
            zcr=zcr+0.5*abs(sign(s(k-1))-sign(s(k)));
        end
x = [centroides,etendue,asymetrie,kurtosis,ptcoupure,centroidet,energieglob,deff,zcr];
end