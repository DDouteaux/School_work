function [ model, stats ] = twolayernet_train( model, X, y, X_val, y_val, params)
% Train this neural network using stochastic gradient descent.
% 
% Inputs:
% - X: A numpy array of shape (N, D) giving training data.
% - y: A numpy array f shape (N,) giving training labels; y[i] = c means that
%   X[i] has label c, where 0 <= c < C.
% - X_val: A numpy array of shape (N_val, D) giving validation data.
% - y_val: A numpy array of shape (N_val,) giving validation labels.
% - params: a struct containing parameters
%   - learning_rate: Scalar giving learning rate for optimization.
%   - learning_rate_decay: Scalar giving factor used to decay the learning rate
%     after each epoch.
%   - reg: Scalar giving regularization strength.
%   - num_iters: Number of steps to take when optimizing.
%   - batch_size: Number of training examples to use per step.
%   - verbose: boolean; if true print progress during optimization.
    
    if ~isfield(params, 'learning_rate')
        params.learning_rate = 1e-3;
    end
    if ~isfield(params, 'learning_rate_decay')
        params.learning_rate_decay = 0.95;
    end    
    if ~isfield(params, 'reg')
        params.reg = 1e-5;
    end
    if ~isfield(params, 'num_iters')
        params.num_iters = 100;
    end
    if ~isfield(params, 'batch_size')
        params.batch_size = 200;
    end
    if ~isfield(params, 'verbose')
        params.verbose = 0;
    end
    
    lr = params.learning_rate;
    batch_size = params.batch_size;
    num_train = size(X,1);
    batch_size = min(batch_size, num_train);
        
    iterations_per_epoch = max(num_train / batch_size,1);
    %Use SGD to optimize the parameters in model
    loss_history = zeros(params.num_iters, 1);
    train_acc_history = [];
    val_acc_history = [];
    
    for i =1:params.num_iters
        X_batch = [];
        y_batch = [];
        
%       #########################################################################
%       # TODO: Create a random minibatch of training data and labels, storing  #
%       # them in X_batch and y_batch respectively.                             #
%       #########################################################################
        random_indexes = randsample(1:num_train, batch_size);
        X_batch = X(random_indexes,:);
        y_batch = y(random_indexes,:);
        
%       #########################################################################
%       #                             END OF YOUR CODE                          #
%       #########################################################################
        
        %Compute loss and gradients using the current minibatch
        [loss, grads] = twolayernet_loss(model, X_batch, y_batch, params.reg);
        loss_history(i) = loss;
%       #########################################################################
%       # TODO: Use the gradients in the grads dictionary to update the         #
%       # parameters of the network (stored in the dictionary params)           #
%       # using stochastic gradient descent. You'll need to use the gradients   #
%       # stored in the grads dictionary defined above.                         #
%       #########################################################################
        fields = fieldnames(grads);       
        for j = 1:length(fields)
            grad = grads.(fields{j});
            model.(fields{j}) = model.(fields{j}) - params.learning_rate*grad;
        end
        
%       #########################################################################
%       #                             END OF YOUR CODE                          #
%       #########################################################################
        if (params.verbose) && (mod(i,100) == 0)
            fprintf('iteration %d / %d: loss %f\n', i, params.num_iters, loss);
        end
        
        %Every epoch, check train and val accuracy and decay learning rate.
        if mod(i, iterations_per_epoch) == 0
            % Check accuracy
            train_acc = mean(twolayernet_predict(model, X_batch) == y_batch');
            val_acc = mean(twolayernet_predict(model,X_val) == y_val');
            train_acc_history = [train_acc_history, train_acc];
            val_acc_history = [val_acc_history, val_acc];
            
            %Decay learning rate
            lr = lr*params.learning_rate_decay;
        end
    end
    
    stats.loss_history = loss_history;
    stats.train_acc_history = train_acc_history;
    stats.val_acc_history = val_acc_history;
end

