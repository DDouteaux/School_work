function [ model ] = knn_train( X, y)
% Train the classifier. For k-nearest neighbors this is just 
% memorizing the training data.
% Inputs:
%  - X: A matlab matrix of shape (num_train, D) containing the training data
%      consisting of num_train samples each of dimension D.
%  - y: A matlab matrix of shape (N,) containing the training labels, where
%         y[i] is the label for X[i].

    model.X_train = X;
    model.y_train = y;
end

