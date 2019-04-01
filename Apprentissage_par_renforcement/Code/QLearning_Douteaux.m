%% BE Apprentissage automatique
%  DOUTEAUX Damien - 3A ECL
%  Avril 2017

%% Matrice de r�compense
%  Cette matrice repr�sente les r�compenses que recevra l'agent
%  en fonction des d�cisions de mouvement qu'il prendra.
%  Les valeurs sont celles propos�es dans le support de cours.
R = [[-1 -1 -1 -1  0 -1];
     [-1 -1 -1  0 -1 100];
     [-1 -1 -1  0 -1 -1];
     [-1  0  0 -1  0 -1];
     [ 0 -1 -1  0 -1 100];
     [-1  0 -1 -1  0 100]];

%% Matrice d'action-valeur
%  Repr�sente la valeur des actions calcul�es par l'algorithme.
%  Cette matrice sera mise � jour par essais successifs.
%  Par d�faut on ne sa�t rien, donc tous les coefficients � 0.
Q = zeros(size(R));

%% Param�tres de l'algorithme
%  Alpha : la vitesse d'apprentissage.
%  Gamma : facteur d'actualisation.
%  Nb_iter : nombre d'�pisodes � r�aliser (au plus).
%  Nb_convergence : nombre d'�tapes o� il faut que ||prev_Q-Q||_2 < epsilon
%                   pour consid�rer qu'il y eu convergence de l'algorithme.
%  Epsilon : seuil pour ||prev_Q - Q||_2 pour d�terminer la convergence.
alpha = 1;
gamma = .8;
nb_iter = 50000;
nb_convergence = 75;
epsilon = .001;

%% On entra�ne un mod�le, le r�sultat est stock� dans Q
%  Tous les d�tails de l'algorithme sont fournis dans le script.
Q = train_q_model(R, Q, alpha, gamma, nb_iter, nb_convergence, epsilon);

%% Utilisation du mod�le pour d�terminer les trajets optimaux
%  Tous les d�tails de l'algorithme sont fournis dans le script.
optimize_behaviour(Q, 1);
optimize_behaviour(Q, 2);
optimize_behaviour(Q, 3);
optimize_behaviour(Q, 4);
optimize_behaviour(Q, 5);
optimize_behaviour(Q, 6);