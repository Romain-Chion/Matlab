%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Motion estimation test program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
% clear all;

% Fix the regularization parameter
lambda = 10;

% fix the iteration number
nbiter = 50;

%%%%% Read images %%%%%
%im1=rawimread('Data/taxi/taxi1.raw', 256, 190, '*int16');
%im2=rawimread('Data/taxi/taxi2.raw', 256, 190, '*int16');
im1 = rawimread('Data/rubiks_cube/rubik1.raw', 256, 240, '*int16');
im2 = rawimread('Data/rubiks_cube/rubik2.raw', 256, 240, '*int16');

[dx,dy] = size(im1);

% Compute motion components
[u,v]=hsf_tp(im1,im2,lambda,nbiter);

%%%%% Display results %%%%%

% Input image 1
figure(1);
subplot(1,3,1);
imagesc(im1);
title('1st image');
axis off;
axis('image');
colormap(gray(256));

% Input image 2
subplot(1,3,2);
imagesc(im2);
title('2nd image');
axis off;
axis('image');
colormap(gray(256));

% Difference image
subplot(1,3,3);
imagesc(im2-im1);
title('Difference image');
axis off;
axis('image');
colormap(gray(256));

% Component images
figure(2);
subplot(1,2,1); imshow(u,[-2 2]); title('u component');
subplot(1,2,2); imshow(v,[-2 2]); title('v component');colorbar;
axis off;
axis('image');
colormap(gray(256));

% Champs de mouvement
figure(3);
imagesc(im1);
hold on
quiver(5:5:dy-5,dx-5:-5:5,-u(dx-5:-5:5,5:5:dy-5),-v(dx-5:-5:5,5:5:dy-5));
title('Horn et Schunck - Estimated motion field');
axis tight;
axis equal;
colormap(gray);
