function im=rawimread(filename,dx,dy,precision)
%Function that reads raw image
%filename: complete filename
%dx,dy: image dimensions
%precision: datatype defined matlab
%im: returned image in the double datatype
%example: im=rawimread('taxi.raw', 256, 190, '*int16')
if ~exist(filename)
    error(sprintf('%s does not exists', filename))
end
f=fopen(filename);
im=double(fread(f,dx*dy,precision));
im=reshape(im,dx,dy); %Argument is such that dy=line number, dx=column number
im=im'; %reshape works column-wise therefore the combination of reshape and transpose  