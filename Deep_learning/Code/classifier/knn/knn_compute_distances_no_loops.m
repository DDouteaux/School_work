function [ dists ] = knn_compute_distances_no_loops( model, X )
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

%     #########################################################################
%     # TODO:                                                                 #
%     # Compute the l2 distance between all test points and all training      #
%     # points without using any explicit loops, and store the result in      #
%     # dists.                                                                #
%     # HINT: Try to formulate the l2 distance using matrix multiplication    #
%     #       and two broadcast sums.                                         #
%     #########################################################################
        
      train_data = model.X_train;
      
      X_square = repmat(sum(X.*X, 2), 1, size(train_data,1));
      X_train_square = repmat(transpose(sum(train_data.*train_data, 2)), size(X,1), 1);
      X_X_train = -2*X*train_data';
      
      dists = sqrt(X_square + X_train_square + X_X_train);
          
%     #####################################################################
%     #                       END OF YOUR CODE                            #
%     #####################################################################
end

