%function showrects(JPGDIR,RECTFILE,INDICES)
% function showrects(JPGDIR,RECTFILE,INDICES)
% This file loads the images in jpgdir, and shows the rectangles.
% JPGDIR [string] - directory from which to read the images
% RECTFILE [string] - file from which to read the rectangles
%   Assumed to contain 12 rects (48 integers) per line,
%   first four are lips, next four are faces, next four are negative examples.
% INDICES [firstfile:lastfile] - indices of the images to show.
%   Default (if not specified): all, one after another.
%
% Mark Hasegawa-Johnson, 3/26/2016
%
% Get image filenames
%if nargin < 1,
  JPGDIR='../jpg';
%end
files = dir(JPGDIR);
images=files(3:length(files));

% Load the rectangles
%if nargin < 2,
  RECTFILE='../rects/allrects.txt';
%end
rects = load(RECTFILE,'-ascii');

% Get the arguments to show
%if nargin < 3,
INDICES = [1:length(images)];
%end
disp(sprintf('Showing images %d:%d from %s, rects from %s',INDICES(1),...
 INDICES(length(INDICES)),JPGDIR,RECTFILE));

rcolors = 'yyyyccccrrrr'; % rectangle colors

% loop for images in indices
for n=INDICES,
 % load the image file
 A=imread([JPGDIR,'/',images(n).name]);
 figure(1); hold off;
 imagesc(A); hold on;

 % [width,height] vector
 wd=fliplr(size(A(:,:,1)));
 
 % Plot rectangles 1:12, if they are nonzero, else revise r
 for m=1:12,
   if rects(n,(m-1)*4+1) <= 0,
     r=m;  % revise r downward
     disp(sprintf('only %d nonzero rects; ready for number %d',r-1,r));
     break;
   else
     plotrect(rects(n,(m-1)*4+[1:4]),rcolors(m));
   end
 end
 % Some instructions (too short)
 g = input(sprintf('%d: %s.  Hit return for next image',n,images(n).name));
end % go on to next image
