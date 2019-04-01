function [ imdb ] = load_datasets( input_args )
%Load cifar-10-set
    if ~exist(fullfile('dataset', 'cifar-10-batches-mat'), 'dir')
        run dataset/get_datasets
    end
    
    %-------Loading Train Data----------------------
    train_data = [];
    train_labels = [];
    for i= 1:5 
        filename = sprintf('data_batch_%d.mat', i);
        batch = load_batch(fullfile('dataset', 'cifar-10-batches-mat', filename));
        train_data = cat(1, train_data, batch.data);
        train_labels = cat(1, train_labels, batch.labels);
    end
    
    %-------Loading Test Data-----------------------
    test_data = [];
    test_labels = [];
    filename = 'test_batch.mat';
    batch = load_batch(fullfile('dataset', 'cifar-10-batches-mat', filename));
    test_data = cat(1, test_data, batch.data);
    test_labels = cat(1, test_labels, batch.labels);
    
    %-------Loading Meta Data----------------------
    filename = 'batches.meta.mat';
    class_name = load(fullfile('dataset', 'cifar-10-batches-mat', filename));
    
    
    imdb.train_data  = train_data;
    imdb.train_labels = train_labels;
    imdb.test_data   = test_data;
    imdb.test_labels  = test_labels;
    imdb.class_names  = class_name.label_names;
end

function [batch] = load_batch(filename)
    batch = load(filename);
    batch.data = reshape(batch.data, [],32,32,3);
    batch.data = permute(batch.data, [1,3,2,4]);
    batch.data = double(batch.data);
    batch.labels = batch.labels + 1;
end

