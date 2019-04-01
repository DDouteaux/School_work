function [ imdb_new ] = split_data( imdb )
% Split the data into train, val, and test sets. In addition we will
% create a small development set as a subset of the training data;
% we can use this for development so our code runs faster.

num_training = 49000;
num_validation = 1000;
num_test = 1000;
num_dev = 500;

% # Our validation set will be num_validation points from the original
% # training set.
mask = (1:num_validation) + num_training;
imdb_new.X_val = imdb.train_data(mask,:,:,:);
imdb_new.y_val = imdb.train_labels(mask,:);

% # Our training set will be the first num_train points from the original
% # training set.
mask = 1:num_training;
imdb_new.X_train = imdb.train_data(mask,:,:,:);
imdb_new.y_train = imdb.train_labels(mask,:);
% 
% # We will also make a development set, which is a small subset of
% # the training set.
mask = randsample(num_training, num_dev);
imdb_new.X_dev = imdb.train_data(mask,:,:,:);
imdb_new.y_dev = imdb.train_labels(mask,:);
% 
% # We use the first num_test points of the original test set as our
% # test set.
mask = 1:num_test;
imdb_new.X_test = imdb.test_data(mask,:,:,:);
imdb_new.y_test = imdb.test_labels(mask,:);

imdb_new.class_names = imdb.class_names;
end

