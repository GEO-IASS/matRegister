function [val isInside] = evaluate(this, point, varargin)
% Evaluate intensity of image at a given physical position
%
% VAL = INTERP.evaluate(POS);
% where POS is a Nx2 array containing alues of x- and y-coordinates
% of positions to evaluate image, return an array with as many
% values as POS.
%
% VAL = INTERP.evaluate(X, Y)
% X and Y should be the same size. The result VAL has the same size
% as X and Y.
%
% [VAL INSIDE] = INTERP.evaluate(...)
% Also return a boolean flag the same size as VAL indicating
% whether or not the given position as located inside the
% evaluation frame.
%


% eventually convert inputs from x and y to a list of points
dim = [size(point,1) 1];
if ~isempty(varargin)
    var = varargin{1};
    if sum(size(var)~=size(point))==0
        dim = size(point);
        point = [point(:) var(:)];
    end
end

% Evaluates image value for a given position
coord = this.image.pointToContinuousIndex(point);

% Create default result image
defaultValue = NaN;
val = ones(dim)*defaultValue;

% extract x and y
xt = coord(:, 1);
yt = coord(:, 2);

% select points located inside interpolation area
% (smaller than image physical size)
siz = this.image.getSize();
isInside = ~(xt<1 | yt<1 | xt>=siz(1) | yt>=siz(2));
xt = xt(isInside);
yt = yt(isInside);
isInside = reshape(isInside, dim);

% indices of pixels before and after in each direction
i1 = floor(xt);
j1 = floor(yt);

% compute distances to lower-left pixel
dx = (xt-i1);
dy = (yt-j1);

% values of the 4 pixels around each point
val11 = double(this.image.getPixels(i1, j1)).*(1-dx).*(1-dy);
val21 = double(this.image.getPixels(i1, j1+1)).*(1-dx).*dy;
val12 = double(this.image.getPixels(i1+1, j1)).*dx.*(1-dy);
val22 = double(this.image.getPixels(i1+1, j1+1)).*dx.*dy;

% compute result values
val(isInside) = val11 + val12 + val21 + val22;

