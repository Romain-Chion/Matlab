%Fonction de test

function [result] = test()
%result contient les pourcentages de réussites pour chacune des trois
%méthodes.

%INITIALISATION
load('classe','classe');
load('data','m_descripteurs');
x=zeros(1,9);
n=length(m_descripteurs);
m=zeros(4,1);
results=zeros(3,n);
result=zeros(3,4);

%CLASSIFICATION
for i=1:n
    x=m_descripteurs(i,1:9);
    results(1:3,i)=classification_audio(x);
end

%INTERPRETATION
for i=1:n
    k=classe(i);
    m(k)= m(k)+1;
    for j=1:3
        result(j,k)= result(j,k)+(results(j,i)==classe(i))
    end
end
result;
for i=1:4
    result(1:3,i)=result(1:3,i)/m(i);
end
