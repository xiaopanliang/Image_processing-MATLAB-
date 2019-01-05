
function run(datadir1,datadir2)
%datadir1 will be the directory on my system to the folder containing all the images (i.e. jpg/) 
%datadir2 will be the directory to the folder containing 'allrects.txt'
%To run the code, give datadir1 and datadir2 then use command run(datadir1,datadir2)

%==========================Read in rectangles==============================
%datadir2 = '/Users/mingqindai/Documents/MATLAB/MP6_mingqin2/rects';
datadir_rect = fullfile(datadir2,'*.txt');
files_txt = dir(datadir_rect);
filename = strcat(files_txt.name);
disp(filename);
allrects = importdata(filename);

%===============================Read in images=============================
%datadir1 = '/Users/mingqindai/Documents/MATLAB/MP6_mingqin2/jpg';
datadir_jpeg = fullfile(datadir1,'*.jpeg');
files_jpeg = dir(datadir_jpeg);
images = files_jpeg(1:length(files_jpeg));

%===============================train adaboost=============================
%numtrain is the number of tokens to use for training: 0.75 of total
numtrain = round(0.75*length(images));
%load all of the integral images
for k = 1:numtrain
    A = imread([datadir1,'/',images(k).name]);
    II(:,:,k) = integralimage(A);
end

DOFULL = 1;
[CLASSIFIERS,bestwtderrout] = Adaboost_learn(allrects,II,numtrain,DOFULL);

%===============================test data==================================
K = length(images);
for k = (numtrain+1):K
     A = imread([datadir1,'/',images(k).name]);
     III(:,:,k-numtrain) = integralimage(A);
end
[toterr,sngerr,BETAS,T] = Adaboost_test(CLASSIFIERS,allrects,III,K,numtrain,DOFULL);

%==============================plot result=================================

wtederrorrate = BETAS./ (ones(40,1)+ BETAS);
figure(1);
plot(1:T,toterr,1:T,sngerr,1:T,wtederrorrate);
legend({'Total unweighted test-corpus error rate of the strong classifier','Total unweighted error rate of the tth weak classifier','Weighted error rate (=beta/(1+beta)) of the tth weak classifier'});
xlabel('Adaboost Iteration');
ylabel('Error rate');

BB = zeros(40,3);
BB(:,1) = toterr';
BB(:,2) = sngerr';
BB(:,3) = wtederrorrate;

fprintf('\n--------- Visul Face Detection -----------\n');
array2table(BB, 'VariableNames', {'Total_Error', 'Single_Error', 'weighted_error_rate'}, 'RowNames', {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40'})   % Acc = [5 x 9] matrix of accuracies
fprintf('--------------------\n'); 

save('BB.txt','BB','-ascii');
end
