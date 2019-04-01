function [ imdb_new ] = prepare_net_datasets( input_args )
%Prepare_datasets as SVM exercise, we write it as one function.

disp('Begin loading')
imdb = load_datasets();
disp('End loading')

disp('Begin setting samples')
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
disp('End setting samples')

%% Preprocessing: reshape the image data into rows
disp('Begin reshape')
imdb_new.X_train = reshape(imdb_new.X_train, size(imdb_new.X_train,1), []);
imdb_new.X_val   = reshape(imdb_new.X_val,   size(imdb_new.X_val  ,1), []);
imdb_new.X_test  = reshape(imdb_new.X_test,  size(imdb_new.X_test ,1), []);
disp('End reshape')

%% Preprocessing: subtract the mean image
% first: compute the image mean based on the training data
disp('Begin substract mean')
mean_image = mean(imdb_new.X_train, 1);

%second: subtract the mean image from train and test data
imdb_new.X_train = bsxfun(@minus, imdb_new.X_train, mean_image);
imdb_new.X_val   = bsxfun(@minus, imdb_new.X_val  , mean_image);
imdb_new.X_test  = bsxfun(@minus, imdb_new.X_test , mean_image);
disp('End substract mean')
end

