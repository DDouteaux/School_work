function [ imgs_features ] = extract_features( imgs, feature_fns, verbose)
% """
% Given pixel data for images and several feature functions that can operate on
% single images, apply all feature functions to all images, concatenating the
% feature vectors for each image and storing the features for all images in
% a single matrix.
% 
% Inputs:
% - imgs: N x H X W X C array of pixel data for N images.
% - feature_fns: List of k feature functions. The ith feature function should
% take as input an H x W x D array and return a (one-dimensional) array of
% length F_i.
% - verbose: Boolean; if true, print progress.
% 
% Returns:
% A matrix of shape (N, F_1 + ... + F_k) where each row is the concatenation
% of all features for a single image.
% """
    if (nargin<3)
        verbose = 0;
    end
    
    num_images = size(imgs,1);
    %Use the first image to determine feature dimensions
    feature_dims = [];
    first_image_features = [];
    for i =1:length(feature_fns)
        feats = feature_fns{i}(squeeze(imgs(1,:,:,:)));
        feature_dims = [feature_dims, length(feats)];
        first_image_features = [first_image_features, reshape(feats, 1, [])];
    end
    
    total_feature_dim = sum(feature_dims);
    imgs_features = zeros(num_images, total_feature_dim);
    imgs_features(1,:) = first_image_features;
    
    %Extract features for the rest of the images.
    for k = 2:num_images
        idx = 1;
        for i = 1:length(feature_fns)
            next_idx = idx + feature_dims(i);
            imgs_features(k, idx:next_idx-1) = feature_fns{i}(squeeze(imgs(k,:,:,:)));
            idx = next_idx;
        end
        
        if verbose && mod(k, 1000) == 0
            fprintf('Done extracting features for %d / %d images\n', k, num_images);
        end
    end

end

