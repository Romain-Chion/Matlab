function [u,v]=hsf(im1,im2,alpha,nbiter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Motion estimation with the Horn et Schunck method (TP canvas)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: P. Clarysse, March 12, 2012
% im1, im2: 2 consecutive input images
% l: the lambda regularization parameter
% nbiter: the number of iterations
% u, v: the u and v velocity components
% Issued from B.K.P. Horn, B. G. Schunck, 'Determining optical flow',
% Artificial Intelligence, 1981
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DEBUG=1 %To track evolution during minimization

%%%%% image sizes (should be the same for im1 and im2)
[M,N] = size(im1);

% Initialization of the velocity components to 0 
u = zeros(M,N);
v = u;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% ENTER YOUR CODE HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%uses convolution to compute gradient estimates
mxy=[[0 0 0;0 -1 1;0 -1 1]]/4; %spatial convolution mask
mt=[ 0 0 0;0 1 1;0 1 1]/4; %time convolution mask

Ix=conv2(im1+im2,mxy,'same');
Iy=conv2(im1+im2,mxy','same');
It=conv2(im2-im1,mt,'same');

%%%%% Iteratively compute the velocity components %%%%%

%intialize mask
muv=[1/2 1 1/2;1 0 1;1/2 1 1/2]/6;
%initialize cost function
Et=zeros(nbiter,1);
E1=Et;
E2=Et;

for m = 1:nbiter;
    %iterate average values of u and v
    um=conv2(u,muv,'same');
    vm=conv2(v,muv,'same');
    
    %iterate gradient values of u and v
    ux=conv2(u,mxy,'same');
    uy=conv2(u,mxy','same');
    vx=conv2(v,mxy,'same');
    vy=conv2(v,mxy','same');
    
    %iterate values of u and v
    A=(um.*Ix+vm.*Iy+It)./(3*alpha*alpha+Ix.*Ix+Iy.*Iy);
    u=um -Ix.*A;
    v=vm -Iy.*A;
    
    %iterate cost function value
    E1(m)=sum(sum((Ix.*u+Iy.*v+It).*(Ix.*u+Iy.*v+It)));
    E2(m)=sum(sum(ux.*ux+uy.*uy+vx.*vx+vy.*vy));
    Et(m)=E1(m)+alpha*alpha*E2(m);
end

%plot cost function
figure(4);
plot(1:nbiter,E1,1:nbiter,E2,1:nbiter,Et);
