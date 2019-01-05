function DI = differimage(II)
% DI = integralimage(II)
% Assume input is an integral image; difference it to get the image back again
%

[m,n] = size(II);
B = zeros(m+1,n+1);
B(2:(m+1),2:(n+1)) = II;

DI = diff(diff(B,1,1),1,2);

