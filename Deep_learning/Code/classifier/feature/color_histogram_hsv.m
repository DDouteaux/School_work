function [ imhist ] = color_histogram_hsv( im, nbin, xmin, xmax, normalized )
% Compute color histogram for an image using hue.
% 
% Inputs:
% - im: H x W x C array of pixel data for an RGB image.
% - nbin: Number of histogram bins. (default: 10)
% - xmin: Minimum pixel value (default: 0)
% - xmax: Maximum pixel value (default: 255)
% - normalized: Whether to normalize the histogram (default: True)
% 
% Returns:
% 1D vector of length nbin giving the color histogram over the hue of the
% input image.
    if (nargin<5)
        normalized = 1;
    end
    
    if (nargin<4)
        xmax = 255;
    end
    
    if (nargin<3)
        xmin = 0;
    end
    
    if (nargin<2)
        nbin = 10;
    end

    bins = linspace(xmin, xmax, nbin+1);
    hsv = rgb2hsv(im/xmax)*xmax;
    [imhist, ~] = histcounts(hsv(:,:,1), bins,'Normalization', 'probability');
end

