function plotrect(rect,c)
% plot a rectangle on current axes

xcoords = rect(1)+[0 0 1 1 0]*rect(3);
ycoords = rect(2)+[0 1 1 0 0]*rect(4);
plot(xcoords,ycoords,c);
