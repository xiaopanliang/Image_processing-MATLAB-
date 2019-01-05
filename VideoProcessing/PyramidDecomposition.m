clear;clc;

% Reading Tank images
for j=1:9
 s=sprintf('tank_0%d.raw',j);
 fid=fopen(s,'r');
 tank(:,:,j)=(fread(fid,[486,486],'uchar'))';
 fclose(fid);
end

% Pyramid decomposition
%the first compression for i=2,4,6,8
ptank_level1(:,:,1)=(tank(:,:,1)+ tank(:,:,3))/2;
difference_level1(:,:,1)=ptank_level1(:,:,1)-tank(:,:,2);
ptank_level1(:,:,2)=(tank(:,:,3)+ tank(:,:,5))/2;
difference_level1(:,:,2)=ptank_level1(:,:,2)-tank(:,:,4);
ptank_level1(:,:,3)=(tank(:,:,5)+ tank(:,:,7))/2;
difference_level1(:,:,3)=ptank_level1(:,:,3)-tank(:,:,6);
ptank_level1(:,:,4)=(tank(:,:,7)+ tank(:,:,9))/2;
difference_level1(:,:,4)=ptank_level1(:,:,4)-tank(:,:,8);

%the second compression for i=3,7
ptank_level2(:,:,1)=(tank(:,:,1)+ tank(:,:,5))/2;
difference_level2(:,:,1)=ptank_level2(:,:,1)-tank(:,:,3);
ptank_level2(:,:,2)=(tank(:,:,5)+ tank(:,:,9))/2;
difference_level2(:,:,2)=ptank_level2(:,:,2)-tank(:,:,7);


%the first reconstruction for i=3,7
recon(:,:,1)=tank(:,:,1);
recon(:,:,5)=tank(:,:,5);
recon(:,:,9)=tank(:,:,9);
recon(:,:,3)=(tank(:,:,1)+ tank(:,:,5))/2-difference_level2(:,:,1);
recon(:,:,7)=(tank(:,:,5)+ tank(:,:,9))/2-difference_level2(:,:,2);
%the second reconstruction for i=2,4,6,8
recon(:,:,2)=(tank(:,:,1)+ tank(:,:,3))/2-difference_level1(:,:,1);
recon(:,:,4)=(tank(:,:,3)+ tank(:,:,5))/2-difference_level1(:,:,2);
recon(:,:,6)=(tank(:,:,5)+ tank(:,:,7))/2-difference_level1(:,:,3);
recon(:,:,8)=(tank(:,:,7)+ tank(:,:,9))/2-difference_level1(:,:,4);
%*******************************************************************************
% Your code goes in here.
% Generate the coded and diff images and display them 
% after appropriate intensity rescaling
%*******************************************************************************

% Conceptually, if images have to be transmitted, the following frames will be sent:
% coded(:,:,k); k=1,5,9 and diff(:,:,k); k=2,3,4,6,7,8.

%*******************************************************************************
% Your code goes in here
% Getting back the data (decoding)
% recon=coded+diff;
% Check for Perfect Reconstruction by computing MSE:
%*******************************************************************************

MSE=0;
for j=1:9
 MSE=MSE+norm(recon(:,:,j)-tank(:,:,j),'fro')^2;
end
MSE % Should be zero
