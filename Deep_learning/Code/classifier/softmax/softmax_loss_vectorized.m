function [ loss, dW ] = svm_loss_vectorized( W, X, y, reg )
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
% # Compute the softmax loss and its gradient using no explicit loops.  #
% # Store the loss in loss and the gradient in dW. If you are not careful     #
% # here, it is easy to run into numeric instability. Don't forget the        #
% # regularization!                                                           #
% #############################################################################
      
  num_class = size(W,1);
  num_train = size(X,1);
  
  % Calcul des scores
  scores = W*X';
  
  %% Calcul de la perte
  % Calcul des termes de normalisation
  sum_by_images = log(sum(exp(scores)));
  % Calcul des termes hors normalisation
  prov_ = eye(max(y));
  theoric_labels = prov_(y,:); % 1 si c'est le bon label, 0 sinon
  theoric_scores = theoric_labels'.*scores; % scores des labels théoriques
  % On combine le tout ensemble
  loss = - sum(theoric_scores) + sum_by_images;
  % On ajoute la régularisation
  loss = sum(transpose(loss))/num_train + .5*reg*sum(sum(W'.*W'));

  %% Calcul du gradient
  dS = exp(scores)./(ones(10,1)*sum(exp(scores))) - theoric_labels' ;
  dW = dS*X/num_train + reg*W;
    
% #############################################################################
% #                          END OF YOUR CODE                                 #
% #############################################################################
end

