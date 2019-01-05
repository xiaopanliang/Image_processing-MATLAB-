% Created by Prakash Ishwar on May 1998 at the University of Illinois at Urbana-Champaign

clear;clc;
tic
image=imread('lena.raw');
image = double(image);


Timage = blkproc(image,[8 8],'dct2');
[dummy avgenergy] = newblkproc(Timage,[8,8],'avgblkenergy');
%sort find index
E = avgenergy;
S = sum(E(:));
[sorted index] = sort(avgenergy(:));
mask = zeros(64,1);
%keep top 10
mask(index(55:64))=1;
mask = reshape(mask,8,8);
EEE = avgenergy.*mask;
SSS = sum(EEE(:));
percentage = SSS/S
cmprss = blkproc(Timage,[8 8],'applymask',mask);
uncmpress = blkproc(cmprss,[8 8],'idct2');
diff = image - uncmpress;
mse = norm(diff,'fro');
mse = (mse*mse)/(512*512)
psnr = 10*log10(255^2/mse)
figure(1); imshow(uncmpress,[0 255]);
%[X,Y] = meshgrid(1:8,1:8);
%figure(2); surf(X,Y,avgenergy);colorbar
%figure(2); surface(avgenergy);colorbar;
figure(2); mesh(avgenergy);
%figure(2); loglog(avgenergy);colorbar;
toc