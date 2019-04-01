function [ loss, grads, scores ] = twolayernet_loss( model, X, y, reg )
% Compute the loss and gradients for a two layer fully connected neural
%     network.
% 
%     Inputs:
%     - model : a struct containing network wegihts;
%     - X: Input data of shape (N, D). Each X[i] is a training sample.
%     - y: Vector of training labels. y[i] is the label for X[i], and each y[i] is
%       an integer in the range 1 <= y[i] <= C. This parameter is optional; if it
%       is not passed then we only return scores, and if it is passed then we
%       instead return the loss and gradients.
%     - reg: Regularization strength.
% 
%     Returns:
%     If y is None, return a matrix scores of shape (N, C) where scores[i, c] is
%     the score for class c on input X[i].
% % 
%     If y is not None, instead return a tuple of:
%     - loss: Loss (data loss and regularization loss) for this batch of training
%       samples.
%     - grads: Dictionary mapping parameter names to gradients of those parameters
%       with respect to the loss function; has the same keys as self.params.
    if nargin < 4
        reg = 0.0;
    end
    
    [N, D] = size(X);
    % Compute the forward pass
    scores = 0;
    
%   #############################################################################
%   # TODO: Perform the forward pass, computing the class scores for the input. #
%   # Store the result in the scores variable, which should be an array of      #
%   # shape (N, C).                                                             #       
%   # Hint: input - fully connected layer - ReLU - fully connected layer        #
%   #############################################################################
    hidden_layer = max(0,X*model.W1 + repmat(model.b1,N,1));
    scores = hidden_layer*model.W2+repmat(model.b2,N,1);
    
%   #############################################################################
%   #                              END OF YOUR CODE                             #
%   #############################################################################
%     if (nargin == 2) || (nargin==3 && isscalar(y))
%         loss = layer2;
%         return;
%     end
    
    % Compute the loss
    loss = 0;
%   #############################################################################
%   # TODO: Finish the forward pass, and compute the loss. This should include  #
%   # both the data loss and L2 regularization for W1 and W2. Store the result  #
%   # in the variable loss, which should be a scalar. Use the Softmax           #
%   # classifier loss. So that your results match ours, multiply the            #
%   # regularization loss by 0.5                                                #
%   #############################################################################

    sum_by_images = log(sum(exp(scores),2));   % Vecteur dans M(5,1)
    % Calcul des termes hors normalisation
    prov_ = eye(max(y));
    theoric_labels = prov_(y,:); % 1 si c'est le bon label, 0 sinon
    theoric_scores = theoric_labels.*scores; % scores des labels théoriques, dans M(5,3)
    % On combine le tout ensemble
    data_loss = sum(- sum(theoric_scores,2) + sum_by_images)/N;
    l2_reg = .5*reg*sum(sum(model.W1'.*model.W1')) + .5*reg*sum(sum(model.W2'.*model.W2'));
    loss = data_loss + l2_reg;

%   #############################################################################
%   #                              END OF YOUR CODE                             #
%   #############################################################################


%   Backward pass: compute gradients
    grads = {};
%   #############################################################################
%   # TODO: Compute the backward pass, computing the derivatives of the weights #
%   # and biases. Store the results in the grads struct. For example,           #
%   # grads.W1 should store the gradient on W1, and be a matrix of same size    #
%   #############################################################################
    % Calcul du gradient sur le softmax (en sortie)
    max_score = max(max(scores));
    delta_L = exp(scores-max_score*ones(size(scores)))./(sum(exp(scores-max_score*ones(size(scores))),2)*ones(1,size(model.b2,2)));
    delta_L = delta_L - theoric_labels;
    
    % Gradient pour W2 et b2
    grads.W2 = hidden_layer'*delta_L;
    grads.b2 = sum(delta_L); % taille 1x3 (trois classes)
    
    % Back-propagation de ReLU
    grad_hidden = delta_L*model.W2';
    grad_hidden(hidden_layer<=0) = 0;

    % Gradient pour W1 et b1
    grads.W1 = X'*grad_hidden;
    grads.b1 = sum(grad_hidden);

    % Moyenner les valeurs
    grads.W2 = grads.W2/N;
    grads.b2 = grads.b2/N;
    grads.W1 = grads.W1/N;
    grads.b1 = grads.b1/N;
    
    % Ajout de la régularisation
    grads.W2 = grads.W2 + reg*model.W2;
    grads.W1 = grads.W1 + reg*model.W1;
    
%   #############################################################################
%   #                              END OF YOUR CODE                             #
%   #############################################################################
end

