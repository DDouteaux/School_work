function [ dists ] = knn_compute_distances_one_loops( model, X )
% Compute the distance between each test point in X and each training point
% in self.X_train using a single loop over the test data.

%    Inputs:
%    - model: KNN model struct, it has two members:
%       model.X_train : A matrix of shape (num_train, D) containing train data.
%       model.y_train : A matrix of shape (num_train, 1) containing train labels.
%    - X: A matrix of shape (num_test, D) containing test data.
%    Returns:
%    - dists: A matrix of shape (num_test, num_train) where dists[i, j]
%      is the Euclidean distance between the ith test point and the jth training
%      point.
    num_test = size(X,1);
    num_train = size(model.X_train, 1);
    dists = zeros(num_test, num_train);
    
    for i=1:num_test
%       #######################################################################
%       # TODO:                                                               #
%       # Compute the l2 distance between the ith test point and all training #
%       # points, and store the result in dists[i, :].                        #
%       #######################################################################
        
        dists(i,:) = sqrt(sum(transpose((model.X_train - repmat(X(i,:), num_train, 1)).^2)));
        
%       #####################################################################
%       #                       END OF YOUR CODE                            #
%       #####################################################################
    end
end

