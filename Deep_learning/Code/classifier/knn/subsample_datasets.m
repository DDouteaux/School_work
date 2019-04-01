function [ sub_imdb ] = subsample_datasets( imdb )
%SUBSAMPLE_DATASETS Summary of this function goes here
%   Detailed explanation goes here
    num_training = 5000;
    mask = 1:num_training;
    sub_imdb.train_data = imdb.train_data(mask,:,:,:);
    sub_imdb.train_labels = imdb.train_labels(mask);

    num_test = 500;
    mask = 1:num_test;
    sub_imdb.test_data = imdb.test_data(mask,:,:,:);
    sub_imdb.test_labels = imdb.test_labels(mask);
    
    sub_imdb.class_names = imdb.class_names;
end

