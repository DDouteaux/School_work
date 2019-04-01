function [dists] = knn_compute_distances_two_loops(model, X)
% Compute the distance between each test point in X and each training point
% in model.X_train using a nested loop over both the training data and the 
% test data.

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
    for i = 1:num_test
      for j = 1:num_train
%         #####################################################################
%         # TODO:                                                             #
%         # Compute the l2 distance between the ith test point and the jth    #
%         # training point, and store the result in dists[i, j]               #
%         #####################################################################

          dists(i,j) = sqrt(sum((X(i,:) - model.X_train(j,:)).^2));
          
%         #####################################################################
%         #                       END OF YOUR CODE                            #
%         #####################################################################
      end
    end
end
