%adaboost_learn£º
%learn a classifier using adaboost over integral images

function [CLASSIFIERS,bestwtderrout] = Adaboost_learn(allrects,II,numtrain,DOFULL)

posrects = allrects(:,17:32);
negrects = allrects(:,33:48);
%Adaboost weights: initialize to uniform, eight per image
W = ones([numtrain,8]);
%Classifier label: 1,0
Y = [ones(numtrain,4), zeros(numtrain,4)];

%Adaboost classifier strength vector
%BETAS = [];
BETAS = zeros(40,1);
bestwtderrout = zeros(40,1);
CLASSIFIERS = zeros(0,9);
%NSAMPS = 24;
NSAMPS = 6;

%Learn a 40-layer adaboost classifier
for t = 1:(40^DOFULL)
    W = W/sum(sum(W));
    
    %Initialize bestwtderr so that it will be immediately replaced
    bestwtderr=Inf;
    
     %Test the error rate of every possible rectfeaature
    for xmin = 0:(DOFULL*(NSAMPS-1))
        for ymin = 0:(DOFULL*(NSAMPS-1))
            %disp(sprintf('%d: [%d,%d]',t,xmin,ymin));
            for rwid = 1:(NSAMPS-xmin)^DOFULL
                for rhgt = 1:(NSAMPS-ymin)^DOFULL
                    rectf = [xmin,ymin,rwid,rhgt]/NSAMPS;
                    for vert = 0:DOFULL
                        for order = (1+vert):(4-vert)^DOFULL
                            X = rectfeature(II,[posrects,negrects],rectf,order,vert);
                            [theta,pola,err] = bestthreshold(X,Y,W);
                            
                            %If this error is the best so far, keep it
                            if err < bestwtderr
%                                 disp(sprintf('%d: [%d,%d,%d,%d],%d,%d: %g<%g with %g,%d',...
%                                     t,xmin,ymin,rwid,rhgt,vert,order,err,bestwtderr,theta,pola));
                                bestclassifier = [xmin,ymin,rwid,rhgt,vert,order,theta,pola];
                                bestwtderr = err;
                            end
                        end
                    end
                end
            end            
        end
    end
    
    %Display results
    bestwtderrout(t) = bestwtderr;
    BETAS(t) = bestwtderr/(1-bestwtderr);
    CLASSIFIERS(t,:) = [bestclassifier, BETAS(t)];
%     disp(sprintf('e(%d)=%g; best rectfeature [%d,%d,%d,%d]:%d,%d,%g,%d',...
%         t,bestwtderr,bestclassifier));
%      
    %Recompute tectfeatures for best classifier
    rectf = bestclassifier(1:4)/NSAMPS;
    vert = bestclassifier(5);
    order = bestclassifier(6);
    theta = bestclassifier(7);
    p = bestclassifier(8);
    X = rectfeature(II,[posrects,negrects],rectf,order,vert);
    
    %Classifier output is 1 if p*X<p*theta, else -1
    H = (p*X < p*theta);
    %Multiply W by beta for each correctly classified example
    W(H==Y) = W(H==Y)*BETAS(t);    
end

% if DOFULL == 0
%     save('learned_classifiers.txt','CLASSIFIERS','-ascii');
% end
end

