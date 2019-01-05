function II = integralimage(A)
% II = integralimage(A)
% Compute the integral image of the B/W version of image A.
%

% sum all colors, then cumsum in rows, then in columns
II = cumsum(cumsum(sum(A,3),2),1);

