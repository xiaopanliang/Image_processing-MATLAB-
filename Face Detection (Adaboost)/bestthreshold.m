function [THETA,POLA,ERR] = bestthreshold(X,Y,W)
% function [THETA,POLA,ERR] = bestthreshold(X,Y,W)
% Find threshold, polarity, and error of the best 1-dimensional classifier.
%
% The three inputs have arbitrary size, KxNR, but must all be the same size:
% X [KxNR] - a matrix of real-valued scalar observations
% Y [KxNR] - a matrix of binary class labels, either zero or one
% W [KxNR] - a matrix of non-negative weights such that sum(sum(W))==1
%
% The classifier is tested as follows, for scalar POLA and THETA:
%   H = (POLA*X < POLA*THETA) ? 1 : 0
% The scalar error rate is then
%   ERR = sum(sum(W.*H))
% The sign and threshold are chosen to minimize ERR.
%
% Mark Hasegawa-Johnson, 4/3/2016
% Modified 4/16/2016 to have more consistent notation

% Sort the features, then order the weights and labels to match
xvec = X(:);
yvec = Y(:);
wvec = W(:);
[xsort,isort] = sort(xvec);
ysort = yvec(isort);
wsort = wvec(isort);

% xsort is now sorted from small to large; each x is a possible threshold.
% For POLA==1: at each threshold x(i),
%   prob(correct detect|i,POLA) = sum(w(1:i) .* (y(1:i)==1))
%   prob(incorrect accept|i,POLA) = sum(w(1:i) .* (y(1:i)==0))
%   diffprob = p(correct detect|i,POLA) - p(incorrect accept|i,POLA)
% For POLA==-1: at each threshold x(i),
%   prob(missed detect|i,POLA) = sum(w(1:i) .* (y(1:i)==1))
%   prob(correct reject|i,POLA) = sum(w(1:i) .* (y(1:i)==0))
%   diffprob = p(missed detect|i,POLA) - p(correct reject|i,POLA)
diffprob = cumsum((2*ysort-1).*wsort);

% P(error|sign==1) = p(incorrect accept) + p(missed detect)
%   = p(incorrect accept) + (p(y=1) - p(correct detect))
%   = p(y=1) - diffprob
[dpmax,ipmax]=max(diffprob);
perr_plus = sum(W(Y==1)) - dpmax;

% P(error|sign==-1) = p(missed detect) + p(incorrect accept)
%   = p(missed detect) + (p(y==0) - p(correct reject))
%   = p(y==0) + diffprob
[dpmin,ipmin]=min(diffprob);
perr_minus = sum(W(Y==0)) + dpmin;

if perr_plus < perr_minus,
 THETA = xsort(ipmax);
 POLA = 1;
 ERR = perr_plus;
else,
 THETA = xsort(ipmin);
 POLA = -1;
 ERR = perr_minus;
end

