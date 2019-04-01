function [ hog ] = hog_feature( im )
% Compute Histogram of Gradient (HOG) feature for an image
%   
%        Modified from skimage.feature.hog
%        http://pydoc.net/Python/scikits-image/0.4.2/skimage.feature.hog
%      
%     Reference:
%        Histograms of Oriented Gradients for Human Detection
%        Navneet Dalal and Bill Triggs, CVPR 2005
%      
%     Parameters:
%       im : an input grayscale or rgb image
%       
%     Returns:
%       feat: Histogram of Gradient (HOG) feature
   image = [];
   if ndims(im) == 3
       image = double(rgb2gray(uint8(im)));
   else
       image = im;
   end
   [sx,sy] = size(image);
   orientations = 9;
   cx = 8;
   cy = 8;
   gx = zeros(sx, sy);
   gy = zeros(sx, sy);
   gx(:,1:end-1) = diff(image, 1, 2);
   gy(1:end-1,:) = diff(image, 1, 1);
   grad_mag = sqrt(gx.^2 + gy.^2);
   grad_ori = atan2(gy, (gx+1e-15))* (180/pi) + 90;
   n_cellsx = int16(floor(sx / cx));  %number of cells in x
   n_cellsy = int16(floor(sy / cy));  %number of cells in y
   % compute orientations integral images
   orientation_histogram = zeros(n_cellsx, n_cellsy, orientations);
   
   h = fspecial('average', [cx, cy]);
   for i = 1:orientations
        % create new integral image for this orientation
        % isolate orientations in this range
        temp_ori = grad_ori;
        temp_ori(grad_ori >= (180 / orientations * (i))) = 0;
        temp_ori(grad_ori < (180 / orientations * (i-1))) = 0;
        %select magnitudes for those orientations
        temp_mag = grad_mag;
        temp_mag(temp_ori <= 0) = 0;
        temp_mag = imfilter(temp_mag, h, 'symmetric');
        
        temp_x = cx/2 + cx*(0:(sx/cx-1)) + 1;
        temp_y = cy/2 + cy*(0:(sy/cy-1)) + 1;
        
        orientation_histogram(:,:,i) = temp_mag(temp_x, temp_y);
   end
   hog = orientation_histogram(:);
end
