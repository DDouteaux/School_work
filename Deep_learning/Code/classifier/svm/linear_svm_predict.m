function [ y_pred ] = linear_svm_predict( model, X )
% Use the trained weights of this linear classifier to predict labels for
% data points.
% 
% Inputs:
% - model : a trained model containing svm weights.
% - X: N x D array of training data. Each row is a D-dimensional point.
% 
% Returns:
% - y_pred: Predicted labels for the data in X. y_pred is a 1-dimensional
%   array of length N, and each element is an integer giving the predicted
%   class.
    y_pred = zeros(1,max(size(X,1)));
    
%     ###########################################################################
%     # TODO:                                                                   #
%     # Implement this method. Store the predicted labels in y_pred.            #
%     ###########################################################################
        scores = model.W*X';
        for i = 1:size(X,1)
           [~, index] = max(scores(:,i));
           y_pred(i) = index;
        end
%     ###########################################################################
%     #                           END OF YOUR CODE                              #
%     ###########################################################################
end

