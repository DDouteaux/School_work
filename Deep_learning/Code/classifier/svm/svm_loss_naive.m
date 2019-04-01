function [ loss, dW ] = svm_loss_naive( W, X, y, reg )
% """
% Structured SVM loss function, naive implementation (with loops)
% Inputs:
% - W: C x D matrix of weights
% - X: N x D matrix of data. Data are D-dimensional columns
% - y: 1-dimensional array of length N with labels 0...K-1, for K classes
% - reg: (float) regularization strength
% Returns:
% a tuple of:
% - loss as single float
% - gradient with respect to weights W; an array of same shape as W
% """

dW = zeros(size(W));
num_classes = size(W,1);
num_train = size(X, 1);

loss = 0.0;
for i = 1:num_train
    scores = W*X(i, :)';
    correct_class_score = scores(y(i));
    for j = 1:num_classes
      if j == y(i)
        continue;
      end
      margin = scores(j) - correct_class_score + 1; % note delta = 1
      if margin > 0
        loss = loss + margin;
        %your code 
        % Ligne incorrect, on ajoute le vecteur X_i
        dW(j,:) = dW(j,:) + X(i,:);
        % Ligne correct, on retranche le vecteur X_i
        dW(y(i),:) = dW(y(i),:) - X(i,:);
      end
    end
end

% Right now the loss is a sum over all training examples, but we want it
% to be an average instead so we divide by num_train
loss = loss/num_train;

% Average gradients as well
% your code 
dW = dW/num_train;

% Add regularization to the loss.
loss = loss + 0.5 * reg * sum(sum((W.*W)));

% Add regularization to the gradient
% your code
dW = dW + reg*W; % On ajoute la dérivée de 0.5*y*||W||
  
% #############################################################################
% # TODO:                                                                     #
% # Compute the gradient of the loss function and store it dW.                #
% # Rather that first computing the loss and then computing the derivative,   #
% # it may be simpler to compute the derivative at the same time that the     #
% # loss is being computed. As a result you may need to modify some of the    #
% # code above to compute the gradient.                                       #
% #############################################################################

end

