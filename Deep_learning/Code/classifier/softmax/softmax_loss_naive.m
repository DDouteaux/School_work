function [ loss, dW ] = softmax_loss_naive( W, X, y, reg )
% Softmax loss function, naive implementation (with loops)
% Inputs:
% - W: C x D matrix of weights
% - X: N x D matrix of data. Data are D-dimensional columns
% - y: 1-dimensional array of length N with labels 1..k , for K classes
% - reg: (float) regularization strength
% Returns:
% a tuple of:
% - loss
% - gradient with respect to weights W, an array of same size as W
  
% Initialize the loss and gradient to zero.
  loss = 0.0;
  dW = zeros(size(W));

% #############################################################################
% # TODO: Compute the softmax loss and its gradient using explicit loops.     #
% # Store the loss in loss and the gradient in dW. If you are not careful     #
% # here, it is easy to run into numeric instability. Don't forget the        #
% # regularization!                                                           #
% #############################################################################

  % Grandeurs générales
  num_class = size(W,1);
  num_train = size(X,1);
  
  for i = 1:num_train
%     if(mod(i,1000) == 0)
%       disp(i);
%     end
    % Calcul des scores pour l'image
    scores = W*X(i, :)';
    % Le score théorique
    correct_class_score = scores(y(i));    
    % Calcul du dénominateur (somme des exponentielles).
    exp_scores = exp(scores);              
    exp_regularization = sum(exp_scores);   
    % Calcul explicite du loss
    loss = loss - correct_class_score + log(exp_regularization);
    for j = 1:num_class
        if(j == y(i))
            dW(j,:) = dW(j,:) + (exp_scores(j)/exp_regularization-1)*X(i,:);
        else
            dW(j,:) = dW(j,:) + (exp_scores(j)/exp_regularization)*X(i,:);
        end
    end
  end
  
  loss = loss/num_train + .5*reg*sum(sum(W.*W));
  dW = dW/num_train + reg*W;
  
% #############################################################################
% #                          END OF YOUR CODE                                 #
% #############################################################################
end

