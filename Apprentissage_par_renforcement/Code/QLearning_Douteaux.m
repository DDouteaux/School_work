%% BE Apprentissage automatique
%  DOUTEAUX Damien - 3A ECL
%  Avril 2017

%% Matrice de récompense
%  Cette matrice représente les récompenses que recevra l'agent
%  en fonction des décisions de mouvement qu'il prendra.
%  Les valeurs sont celles proposées dans le support de cours.
R = [[-1 -1 -1 -1  0 -1];
     [-1 -1 -1  0 -1 100];
     [-1 -1 -1  0 -1 -1];
     [-1  0  0 -1  0 -1];
     [ 0 -1 -1  0 -1 100];
     [-1  0 -1 -1  0 100]];

%% Matrice d'action-valeur
%  Représente la valeur des actions calculées par l'algorithme.
%  Cette matrice sera mise à jour par essais successifs.
%  Par défaut on ne saît rien, donc tous les coefficients à 0.
Q = zeros(size(R));

%% Paramètres de l'algorithme
%  Alpha : la vitesse d'apprentissage.
%  Gamma : facteur d'actualisation.
%  Nb_iter : nombre d'épisodes à réaliser (au plus).
%  Nb_convergence : nombre d'étapes où il faut que ||prev_Q-Q||_2 < epsilon
%                   pour considérer qu'il y eu convergence de l'algorithme.
%  Epsilon : seuil pour ||prev_Q - Q||_2 pour déterminer la convergence.
alpha = 1;
gamma = .8;
nb_iter = 50000;
nb_convergence = 75;
epsilon = .001;

%% On entraîne un modèle, le résultat est stocké dans Q
%  Tous les détails de l'algorithme sont fournis dans le script.
Q = train_q_model(R, Q, alpha, gamma, nb_iter, nb_convergence, epsilon);

%% Utilisation du modèle pour déterminer les trajets optimaux
%  Tous les détails de l'algorithme sont fournis dans le script.
optimize_behaviour(Q, 1);
optimize_behaviour(Q, 2);
optimize_behaviour(Q, 3);
optimize_behaviour(Q, 4);
optimize_behaviour(Q, 5);
optimize_behaviour(Q, 6);