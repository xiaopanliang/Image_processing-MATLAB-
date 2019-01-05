function MATCHVAL = rectsmatch(TESTRECT, RECTSET)
% function MATCHVAL = rectsmatch(TESTRECT, RECTSET)
% Determine whether testrect matches any rect in rectset.
% If so, return indices of all first matching rectangle.
% If not, return an empty array
% TESTRECT [1x4] = rectangle to test
% RECTSET [NRECTSx4] = each row is a rectangle against which to compare
% Match is defined as:
%   Testrect x-range overlaps Rectset x-range by at least 50%, and
%   Rectset x-range overlaps Testrect x-range by at least 50%, and
%   Likewise (both directions) for the y-range
%

% Find maximum x and y coords of RECTSET and TESTRECT
setmax = RECTSET(:,1:2)+RECTSET(:,3:4);
testmax = TESTRECT(1:2)+TESTRECT(3:4);

% Find x-overlap and y-overlap between TESTRECT and RECTSET
overlap = max(0,...
	      [min(setmax(:,1),testmax(1))-max(RECTSET(:,1),TESTRECT(1)),...
	      min(setmax(:,2),testmax(2))-max(RECTSET(:,2),TESTRECT(2))]);

% Measure the fractional overlap with RECTSET, and with TESTRECT
setfractionaloverlap = overlap ./ RECTSET(:,3:4);
testfractionaloverlap = overlap ./ repmat(TESTRECT(3:4),[size(RECTSET,1),1]);

MATCHVAL = find((setfractionaloverlap(:,1) >= 0.5) .* ...
	 (setfractionaloverlap(:,2) >= 0.5) .* ...
	 (testfractionaloverlap(:,1) >= 0.5) .* ...
	 (testfractionaloverlap(:,2) >= 0.5));


