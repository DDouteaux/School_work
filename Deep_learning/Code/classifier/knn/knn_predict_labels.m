function [y_pred] = knn_predict_labels(model, dists, k)
%     Given a matrix of distances between test points and training points,
%     predict a label for each test point.
% 
%     Inputs:
%     - model: KNN model struct, it has two members:
%         model.X_train : A matrix of shape (num_train, D) containing train data.
%         model.y_train : A matrix of shape (num_train, 1) containing train labels.
%     - dists: A matrix of shape (num_test, num_train) where dists[i, j]
%       gives the distance betwen the ith test point and the jth training point.
%     - k : number of nearest neighbors
%     Returns:
%     - y: A matrix of shape (num_test,) containing predicted labels for the
%       test data, where y[i] is the predicted label for the test point X[i].  


%     #########################################################################
%     # TODO:                                                                 #
%     # Use the distance matrix to find the k nearest neighbors of the ith    #
%     # training point, and use model.train_labels to find the labels of these#
%     # neighbors. Store these labels in closest_y.                           #
%     # Hint: Look up the function sort                                       #
%     #########################################################################
        num_test = size(dists,1);
        num_train = size(dists,2);
        closest_y = zeros(num_test, k);
        
        for i = 1:num_test
            [~, sorted_indexes] = sort(dists(i,:));
            for j = 1:k
               closest_y(i, j) = model.y_train(sorted_indexes(j));
            end
        end
% 
%     #########################################################################
%     # TODO:                                                                 #
%     # Now that you have found the labels of the k nearest neighbors, you    #
%     # need to find the most common label in the list closest_y of labels.   #
%     # Store this label in y_pred[i]. Break ties by choosing the smaller     #
%     # label.                                                                
%     # Hint: Look up the function mode
%     #########################################################################
       y_pred = zeros(num_test,1);
       
       for i = 1:num_test
          y_pred(i) = mode(closest_y(i,:)); 
       end
% 
%     #########################################################################
%     #                           END OF YOUR CODE                            # 
%     #########################################################################
end