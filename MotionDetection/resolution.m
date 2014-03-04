function imr=resolution(im)
[M,N] = size(im);
i=1:2:M;
j=1:2:N;
imr=im(i,j);