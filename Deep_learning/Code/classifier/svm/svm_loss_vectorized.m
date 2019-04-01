function [ loss, dW  ] = svm_loss_vectorized( W, X, y, reg )
% """
% Structured SVM loss function, vectorized implementation.
% Inputs and outputs are the same as svm_loss_naive.
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

loss = 0.0;
dW = zeros(size(W)); % initialize the gradient as zero
num_train = size(X, 1);

% #############################################################################
% # TODO:                                                                     #
% # Implement a vectorized version of the structured SVM loss, storing the    #
% # result in loss.                                                           #
% #############################################################################

    % Les scores calculés
    scores = W*X';
    % Construction de la matrice des scores des labels théoriques
    prov_ = eye(max(y));
    theoric_labels = prov_(y,:); % 1 si c'est le bon label, 0 sinon
    theoric_scores = theoric_labels'.*scores; % scores des labels théoriques
    theoric_scores_all = repmat(max(theoric_scores) + min(theoric_scores), 10, 1);
    % On reprend un delta de 1
    deltas = ones(10, num_train);
    % Calcul final des scores pour les différentes images
    L = scores - theoric_scores_all + deltas;
    % On met à 0 les cases correspondants aux classes théoriques
    L = L-theoric_labels'.*L;
    % On applique le max sur les scores calculés
    L(L<0)=0;
    % Calcul des gains pour chaque image et régularisation
    loss = sum(sum(transpose(L))/num_train + 0.5 * reg * sum(W'.*W'));

% #############################################################################
% #                             END OF YOUR CODE                              #
% #############################################################################

% #############################################################################
% # TODO:                                                                     #
% # Implement a vectorized version of the gradient for the structured SVM     #
% # loss, storing the result in dW.                                           #
% #                                                                           #
% # Hint: Instead of computing the gradient from scratch, it may be easier    #
% # to reuse some of the intermediate values that you used to compute the     #
% # loss.                                                                     #
% #############################################################################

    % On reprend le calcul intermédiaire du coût, calcul du premier terme
    L = scores - theoric_scores_all + deltas;
    % Calcul de la "dérivée du max"
    L(L<0) = 0;
    L(L>0) = 1;
    % On retire la valeur du label théorique
    L = L - theoric_labels'.*L;
    % On retire la somme par colonne que l'on ajoute au label théorique
    L = L - theoric_labels'.*(ones(10,1)*sum(L,1));
    % On ajouter un terme
    dW = L*X/num_train + reg*W;

% #############################################################################
% #                             END OF YOUR CODE                              #
% #############################################################################

end