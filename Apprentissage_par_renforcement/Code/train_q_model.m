%% BE Apprentissage automatique
%  DOUTEAUX Damien - 3A ECL
%  Avril 2017

function [ Q ] = train_q_model( R, Q_init, alpha, gamma, nb_iter, nb_convergence, epsilon )
    %% Fonction entra�nant un mod�le par renforcement (algo de Q-Learning).
    %
    %  Params :
    %       - R              : la matrice de r�compenses.
    %       - Q_init         : valeur initiale de la matrice action-valeur.
    %       - alpha          : la vitesse d'apprentissage.
    %       - gamma          : le facteur d'actualisation.
    %       - nb_iter        : nombre maximum d'�pisodes � r�aliser.
    %       - nb_convergence : nombre d'�pisodes successifs o� il faut que 
    %                                  ||prov_Q - Q||_2 < epsilon
    %                          pour consid�rer qu'il y a eu convergence.
    %       - epsilon        : seuil pour d�terminer la convergence.
    %
    %  Return :
    %       - Q              : la matrice action-valeur entra�n�e.
    
    %% Initialisation des grandeurs g�n�riques de l'algorihthme.
    % Initialisation de la matrice d'action-valeur (Q).
    Q = Q_init;
    
    % Nombre d'�pisodes successif o� ||prov_Q - Q||_2 < epsilon.
    conv_count = 0;
    
    % Un peu d'affichage pour l'utilisateur
    disp('-------------------------------');
    
    % Pour les graphes d'�volution de ||Q||_2 et ||prov_Q - Q||_2.
    diff_Q = [];
    norm_Q = [];
    
    %% Boucle principale de l'algorithme.
    %  Les �tapes de l'algorithme sont sp�cifi�es directement dans
    %  le code de ce dernier.
    for i=1:nb_iter
        % Bool�en pour savoir si l'�pisode a abouti � un �t� final.
        final_state = false;

        % Tirage au sort de l'�tat de d�part.
        init_state = randi(size(R,1));

        % Sauvegarde de la matrice Q pour regarder || prev_Q - Q ||_2.
        norm_Q = [norm_Q norm(Q)];
        previous_Q = Q;    

        while(~final_state)        
            % Recherche des potentiels �tats suivants.
            recompense_states = find(R(init_state,:)+1);
            
            % S�lection d'un �tat suivant au hasard.
            future_state = recompense_states(randi([1 size(recompense_states,2)]));

            % Mise � jour de la matrice action-valeur.
            q_actuel = Q(init_state, future_state);                 % La valeur actuelle
            recompense = R(init_state, future_state);               % La r�compense de la transition
            val_opt_estimee = max(Q(future_state,:));               % Valeur optimale estim�e
            valeur_apprise = recompense + gamma*val_opt_estimee;    % Valeur apprise
            Q(init_state, future_state) = q_actuel + alpha*(valeur_apprise - q_actuel);

            % On regarde si l'on est dans un �tat final.
            final_state = (R(init_state, future_state) == 100);
            
            % On repard du nouvel �tat pour la suite.
            init_state = future_state;
        end

        % On regarde s'il y a convergence (ie. ||prev_Q - Q||_2 < epsilon).
        diff_norms = norm(previous_Q-Q);
        %disp(['Valeur de la ||Q_(t+1)-Q(t)||_2 : ' num2str(diff_norms)]);
        diff_Q = [diff_Q diff_norms];
        if(norm(previous_Q-Q) < epsilon)
            conv_count = conv_count + 1;
        else
            % Condition non v�rifi�e, on repasse � 0 �pisodes successifs.
            conv_count = 0;
        end

        % Si au moins nb_convergence �pisodes sucessifs o� 
        %                   ||prev_Q - Q||_2 < epsilon
        % alors on conclue qu'il y a eu convergence et on arr�te.
        if(conv_count > nb_convergence)
            disp('Convergence de Q avant le nombre total d''�tapes');
            disp(['Nombre d''�tapes pour convergence : ' num2str(i)]);
            disp(['Valeur de la ||Q_(t+1)-Q(t)||_2 � la convergence : ' num2str(norm(previous_Q-Q))]);
            break;
        end
    end
    
    % Affichage des graphes d'�volution des normes.
    figure
    ax1 = subplot(1,2,1);
    plot(ax1,norm_Q)
    title(ax1,'�volution de ||Q||_2')
    ylabel(ax1,'||Q||_2')
    xlabel(ax1,'It�ration')

    ax2 = subplot(1,2,2);
    hold on
    plot(ax2,diff_Q)
    plot(ax2,epsilon*ones(size(diff_Q)),'r-')
    hold off
    title(ax2,'�volution de ||Q_{t-1}-Q_t||_2')
    ylabel(ax2,'||Q_{t-1}-Q_t||_2')
    xlabel(ax2,'It�ration')

    % Normalisation de Q en fonction de sa valeur maximale
    Q = 100*Q/max(max(Q));
    
    % Affichage de la matrice obtenue
    disp([char(10) 'Q final : ' char(10)]);
    disp(Q)
end
