function [ imdb_new ] = prepare_datasets_for_feature( input_args )
%Prepare_datasets as SVM exercise, we write it as one function.

imdb = load_datasets();

num_training = 49000;
num_validation = 1000;
num_test = 1000;

% # Our training set will be the first num_train points from the original
% # training set.
mask = 1:num_training;
imdb_new.X_train = imdb.train_data(mask,:,:,:);
imdb_new.y_train = imdb.train_labels(mask,:);

% # Our validation set will be num_validation points from the original
% # training set.
mask = (1:num_validation) + num_training;
imdb_new.X_val = imdb.train_data(mask,:,:,:);
imdb_new.y_val = imdb.train_labels(mask,:);
 
% # We use the first num_test points of the original test set as our
% # test set.
mask = 1:num_test;
imdb_new.X_test = imdb.test_data(mask,:,:,:);
imdb_new.y_test = imdb.test_labels(mask,:);

imdb_new.class_names = imdb.class_names;

end

