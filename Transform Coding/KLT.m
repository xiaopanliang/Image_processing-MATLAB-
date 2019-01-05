% Created by Prakash Ishwar on May 1998 at the University of Illinois at Urbana-Champaign

clear;clc;
tic
image=imread('lena.raw');
image = double(image);


[dummy mu] = newblkproc(image,[16 16],'blockmean');
[dummy Rx] = newblkproc(image,[16 16],'covar',mu);
[KLT D] = eig(Rx);
KLT = KLT';
Timage = blkproc(image,[16 16],'KLtransform',KLT);
[dummy avgenergy] = newblkproc(Timage,[16,16],'avgblkenergy');
E = avgenergy;
S = sum(E(:));
[sorted index] = sort(avgenergy(:));
mask = zeros(256,1);
mask(index(247:256))=1;
mask = reshape(mask,16,16);
EEE = avgenergy.*mask;
SSS = sum(EEE(:));
percentage = SSS/S
cmprss = blkproc(Timage,[16 16],'applymask',mask);
iKLT = KLT';
uncmpress = blkproc(cmprss,[16 16],'invKLT',iKLT);
diff = image - uncmpress;
mse = norm(diff,'fro');
mse = (mse*mse)/(512*512)
psnr = 10*log10(255^2/mse)
figure;imshow(uncmpress,[0 255]);
figure(2); mesh(avgenergy);colorbar;
toc