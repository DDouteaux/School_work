function [ pred_labels ] = knn_predict(model, X, k, num_loops)
%Predict labels for test data using this classifier.
%    Inputs:
%    - X: A matrix of shape (num_test, D) containing test data consisting
%         of num_test samples each of dimension D.
%    - k: The number of nearest neighbors that vote for the predicted labels.
%    - num_loops: Determines which implementation to use to compute distances
%      between training points and testing points.

%    Returns:
%    - y: A matrix of shape (num_test,) containing predicted labels for the
%      test data, where y[i] is the predicted label for the test point X[i]. 
    if (nargin <4)
        num_loops = 0;
    end
    
    if (nargin<3)
        k = 1;
    end
    
    if (nargin<2)
        error('Error : No enough Input arguments');
    end
    
    if (num_loops == 0)
      dists = knn_compute_distances_no_loops(model,X);
    elseif (num_loops == 1)
      dists = knn_compute_distances_one_loop(model,X);
    elseif (num_loops == 2)
      dists = knn_compute_distances_two_loops(model,X);
    else
      error('Error : Invalid value %d for num_loops',num_loops);
    end
    
    pred_labels = knn_predict_labels(model, dists, k);
end




