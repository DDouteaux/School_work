function [ model, loss_hist ] = linear_svm_train(X, y, learning_rate, reg, num_iters, batch_size, verbose)
%     Train this linear classifier using stochastic gradient descent.
% 
%     Inputs:
%     - X: N x D array of training data. Each training point is a D-dimensional
%      row.
%     - y: 1-dimensional array of length N with labels 0...K-1, for K classes.
%     - learning_rate: (float) learning rate for optimization.
%     - reg: (float) regularization strength.
%     - num_iters: (integer) number of steps to take when optimizing
%     - batch_size: (integer) number of training examples to use at each step.
%     - verbose: (boolean) If true, print progress during optimization.
% 
%     Outputs:
%     -model : a struct containing weights,
%     -hist: A list containing the value of the loss function at each training iteration.
%     """
    if (nargin < 7)
        verbose = 0;
    end
    if (nargin<6)
        batch_size = 200;
    end
    if (nargin<5)
        num_iters = 100;
    end
    if (nargin<4)
        reg = 1e-5;
    end
    if (nargin<3)
        learning_rate = 1e-3;
    end
    
    [num_train, dim] = size(X);
    num_classes = max(y); % assume y takes values 1...K where K is number of classes
    
    %lazily initialize W
    W = randn(num_classes, dim) * 0.001;
    
    %Run stochastic gradient descent to optimize W
    loss_hist = zeros(1,num_iters);
    for it = 1:num_iters
        X_batch = [];
        y_batch = [];

%       #########################################################################
%       # TODO:                                                                 #
%       # Sample batch_size elements from the training data and their           #
%       # corresponding labels to use in this round of gradient descent.        #
%       # Store the data in X_batch and their corresponding labels in           #
%       # y_batch; after sampling X_batch should have shape (batch_size, dim)   #
%       # and y_batch should have shape (batch_size,)                           #
%       #                                                                       #
%       # Hint: Use randsample to generate indices. Sampling with               #
%       # replacement is faster than sampling without replacement.              #
%       #########################################################################
        random_indexes = randsample(1:num_train, batch_size);
        X_batch = X(random_indexes,:);
        y_batch = y(random_indexes,:);
        
%       #########################################################################
%       #                       END OF YOUR CODE                                #
%       #########################################################################
      
        %evaluate loss and gradient
        [loss, grad] = self_loss(W, X_batch, y_batch, reg);
        loss_hist(it) = loss;
        
%       perform parameter update
%       #########################################################################
%       # TODO:                                                                 #
%       # Update the weights using the gradient and the learning rate.          #
%       #########################################################################
        
        W = W - learning_rate*grad;
        
%       #########################################################################
%       #                       END OF YOUR CODE                                #
%       #########################################################################
        
        if (verbose > 0)&&(mod(it, 100) == 0)
            fprintf('iteration %d / %d: loss %f\n', it, num_iters, loss);
        end
    end    
    model.W = W;
end

function [loss,grad] = self_loss(W, X_batch, y_batch, reg)
    [loss,grad] = svm_loss_vectorized(W, X_batch, y_batch, reg);
end

