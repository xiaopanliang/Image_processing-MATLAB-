%adaboost_test
%load the adaboost classifier, and apply it to test images
function [toterr,sngerr,BETAS,T] = Adaboost_test(CLASSIFIERS,allrects,II,K,numtrain,DOFULL)

%load('learned_classifiers.txt','-ascii');
[T,foo] = size(CLASSIFIERS);
BETAS = CLASSIFIERS(:,9);
ALPHAS = -log(BETAS);
NSAMPS = 6;


%jpgdir should be the place we can find all JPG images
% jpgdir = '/Users/mingqindai/Documents/MATLAB/mp6/jpg';
% files = dir(jpgdir);
% images = files(3:length(files));

%numtrain is the number of tokens to use for training : 0.75 of total
% K = length(images);
% numtrain = round(0.75*length(images));
% numtest = K-numtrain;
numtest = K-numtrain;
%postrcts should contain positive rectangles, four per image
%negrects should contain negative rectangles, four per image
%load('/Users/mingqindai/Documents/MATLAB/mp6/rects/allrects.txt','-ascii');
posrects = allrects((numtrain+1):K,17:32);
negrects = allrects((numtrain+1):K,33:48);

%Load all of the test-corpus integral images
% for k = (numtrain+1):K
%     A = imread([jpgdir,'/',images(k).name]);
%     II(:,:,k-numtrain) = integralimage(A);
% end

%Get all the rectfeatures and single-rectfeature classifier outputs
F = zeros(numtest,8,T);
H = zeros(numtest,8,T);
Hcum = zeros(numtest,8,T);
for t = 1:T
    fr = CLASSIFIERS(t,1:4)/NSAMPS;
    vert = CLASSIFIERS(t,5);
    order = CLASSIFIERS(t,6);
    theta = CLASSIFIERS(t,7);
    p = CLASSIFIERS(t,8);
    beta = CLASSIFIERS(t,9);
    F(:,:,t) = rectfeature(II,[posrects,negrects],fr,order,vert);
    H(:,:,t) = p*sign(theta-F(:,:,t));
end
%Final classifier: cumulative sum of ALPHAS times H
Hcum= cumsum(H .* repmat(reshape(ALPHAS,[1,1,T]),[numtest,8]),3);
%correct labels
Y = [ones(numtest,4),-ones(numtest,4)];
for t = 1:T
    toterr(t) = mean(mean(sign(Hcum(:,:,t)) ~= Y));
    sngerr(t) = mean(mean(sign(H(:,:,t)) ~= Y));
end
% figure(1);
% plot(1:T,toterr,1:T,sngerr,1:T,BETAS);
% legend({'Total Error','Single Error','Beta'});
% xlabel('Adaboost Iteration');
% ylabel('Error rate');



    