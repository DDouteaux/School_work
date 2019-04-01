function [ y_pred ] = twolayernet_predict( model, X )
%  Use the trained weights of this two-layer network to predict labels for
%     data points. For each data point we predict scores for each of the C
%     classes, and assign each data point to the class with the highest score.
% 
%     Inputs:
%     - model : a struct having weights of network;
%     - X: A matrix of shape (N, D) giving N D-dimensional data points to
%       classify.
% 
%     Returns:
%     - y_pred: A matrix of shape (N,1) giving predicted labels for each of
%       the elements of X. For all i, y_pred[i] = c means that X[i] is predicted
%       to have class c, where 1 <= c <= C.

    y_pred = [];
      
%     ###########################################################################
%     # TODO: Implement this function; it should be VERY simple!                #
%     ###########################################################################
        [N, D] = size(X);
        number_of_classes = size(model.b2,2);
        hidden_layer = max(0,X*model.W1 + repmat(model.b1,N,1));
        scores = hidden_layer*model.W2+repmat(model.b2,N,1);
        %disp(sum(exp(scores),2))
        scores = exp(scores)./repmat(sum(exp(scores),2),1,number_of_classes);
        for i = 1:size(X,1)
            [~, index] = max(scores(i,:));
            y_pred(i) = index;
        end 
      
%     ###########################################################################
%     #                              END OF YOUR CODE                           #
%     ###########################################################################

end

