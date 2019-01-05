function F = rectfeature(II,RECTS,FR,ORDER,VERT)
% function F = rectfeature(II,RECTS,FR,ORDER,VERT)
% Compute matrix of features from a stack of integral images
%
% II [MxNxK] - stack of K integral images, each MxN
% RECTS [Kx(4*NR)] - NR rectangles per image: integer coordinates
% FR [1x4] - fraction of each rect to use for feature: [fx,fy,fw,fh]
%   0 <= FR(1:4) <= 1
% ORDER [1x1]: 1 <= ORDER <= 4 means the number of sub-rectangles
% VERT [1x1] = 1 if vertical orientation, 0 if horizontal
%
% F [KxNR] - computed values of this feature for each training rectangle
%
% Mark Hasegawa-Johnson
% 4/3/2016
% Modified 4/13/2016 to have more consistent notation

% Number of rectangles per image
NR = size(RECTS,2)/4;
% Number of images in which to compute rectangles
K = min(size(RECTS,1),size(II,3));
% One feature for each rectangle, in each image
F = zeros(K,NR);

for k=1:K,
 for nr=1:NR,
   % Rectangle for this feature in this image:
   % [xmin,ymin]=BASE(xmin,ymin)+FR(1:2)*BASE(width,height)
   % [width,height]=FR(3:4)*BASE(width,height)
   BASE = RECTS(k,(nr-1)*4+[1:4]);
   rect = [BASE(1:2),0,0] + round(FR .* [BASE(3:4),BASE(3:4)]);

   % Default coordinates: one rectangle
   xcoords = max(1,min(size(II,2),rect(1)+[0,rect(3)]));
   ycoords = max(1,min(size(II,1),rect(2)+[0,rect(4)]));
   xcofs = [-1,1];
   ycofs = [-1,1];

   % Coordinates from which to sample II
   if (((ORDER==2) && (VERT==1)) || (ORDER==4)),
     xcoords = max(1,min(size(II,2),rect(1)+round([0,0.5,1]*rect(3))));
     xcofs = [1,-2,1];
   end
   if (((ORDER==2) && (VERT==0)) || (ORDER==4)),
     ycoords = max(1,min(size(II,1),rect(2)+round([0,0.5,1]*rect(4))));
     ycofs = [1,-2,1];
   end
   if ((ORDER==3) && (VERT==1)),
     xcoords = max(1,min(size(II,2),rect(1)+round([0,0.33,0.67,1]*rect(3))));
     xcofs = [-1,2,-2,1];
   end
   if ((ORDER==3) && (VERT==0)),
     ycoords = max(1,min(size(II,1),rect(2)+round([0,0.3,0.67,1]*rect(4))));
     ycofs = [-1,2,-2,1];
   end

   % Sample the integral image
   F(k,nr) = F(k,nr) + ycofs*II(ycoords,xcoords,k)*xcofs';
  end
end
