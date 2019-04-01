%% BE Apprentissage automatique
%  DOUTEAUX Damien - 3A ECL
%  Avril 2017

function [ Q ] = train_q_model( R, Q_init, alpha, gamma, nb_iter, nb_convergence, epsilon )
    %% Fonction entraînant un modèle par renforcement (algo de Q-Learning).
    %
    %  Params :
    %       - R              : la matrice de récompenses.
    %       - Q_init         : valeur initiale de la matrice action-valeur.
    %       - alpha          : la vitesse d'apprentissage.
    %       - gamma          : le facteur d'actualisation.
    %       - nb_iter        : nombre maximum d'épisodes à réaliser.
    %       - nb_convergence : nombre d'épisodes successifs où il faut que 
    %                                  ||prov_Q - Q||_2 < epsilon
    %                          pour considérer qu'il y a eu convergence.
    %       - epsilon        : seuil pour déterminer la convergence.
    %
    %  Return :
    %       - Q              : la matrice action-valeur entraînée.
    
    %% Initialisation des grandeurs génériques de l'algorihthme.
    % Initialisation de la matrice d'action-valeur (Q).
    Q = Q_init;
    
    % Nombre d'épisodes successif où ||prov_Q - Q||_2 < epsilon.
    conv_count = 0;
    
    % Un peu d'affichage pour l'utilisateur
    disp('-------------------------------');
    
    % Pour les graphes d'évolution de ||Q||_2 et ||prov_Q - Q||_2.
    diff_Q = [];
    norm_Q = [];
    
    %% Boucle principale de l'algorithme.
    %  Les étapes de l'algorithme sont spécifiées directement dans
    %  le code de ce dernier.
    for i=1:nb_iter
        % Booléen pour savoir si l'épisode a abouti à un été final.
        final_state = false;

        % Tirage au sort de l'état de départ.
        init_state = randi(size(R,1));

        % Sauvegarde de la matrice Q pour regarder || prev_Q - Q ||_2.
        norm_Q = [norm_Q norm(Q)];
        previous_Q = Q;    

        while(~final_state)        
            % Recherche des potentiels états suivants.
            recompense_states = find(R(init_state,:)+1);
            
            % Sélection d'un état suivant au hasard.
            future_state = recompense_states(randi([1 size(recompense_states,2)]));

            % Mise à jour de la matrice action-valeur.
            q_actuel = Q(init_state, future_state);                 % La valeur actuelle
            recompense = R(init_state, future_state);               % La récompense de la transition
            val_opt_estimee = max(Q(future_state,:));               % Valeur optimale estimée
            valeur_apprise = recompense + gamma*val_opt_estimee;    % Valeur apprise
            Q(init_state, future_state) = q_actuel + alpha*(valeur_apprise - q_actuel);

            % On regarde si l'on est dans un état final.
            final_state = (R(init_state, future_state) == 100);
            
            % On repard du nouvel état pour la suite.
            init_state = future_state;
        end

        % On regarde s'il y a convergence (ie. ||prev_Q - Q||_2 < epsilon).
        diff_norms = norm(previous_Q-Q);
        %disp(['Valeur de la ||Q_(t+1)-Q(t)||_2 : ' num2str(diff_norms)]);
        diff_Q = [diff_Q diff_norms];
        if(norm(previous_Q-Q) < epsilon)
            conv_count = conv_count + 1;
        else
            % Condition non vérifiée, on repasse à 0 épisodes successifs.
            conv_count = 0;
        end

        % Si au moins nb_convergence épisodes sucessifs où 
        %                   ||prev_Q - Q||_2 < epsilon
        % alors on conclue qu'il y a eu convergence et on arrête.
        if(conv_count > nb_convergence)
            disp('Convergence de Q avant le nombre total d''étapes');
            disp(['Nombre d''étapes pour convergence : ' num2str(i)]);
            disp(['Valeur de la ||Q_(t+1)-Q(t)||_2 à la convergence : ' num2str(norm(previous_Q-Q))]);
            break;
        end
    end
    
    % Affichage des graphes d'évolution des normes.
    figure
    ax1 = subplot(1,2,1);
    plot(ax1,norm_Q)
    title(ax1,'Évolution de ||Q||_2')
    ylabel(ax1,'||Q||_2')
    xlabel(ax1,'Itération')

    ax2 = subplot(1,2,2);
    hold on
    plot(ax2,diff_Q)
    plot(ax2,epsilon*ones(size(diff_Q)),'r-')
    hold off
    title(ax2,'Évolution de ||Q_{t-1}-Q_t||_2')
    ylabel(ax2,'||Q_{t-1}-Q_t||_2')
    xlabel(ax2,'Itération')

    % Normalisation de Q en fonction de sa valeur maximale
    Q = 100*Q/max(max(Q));
    
    % Affichage de la matrice obtenue
    disp([char(10) 'Q final : ' char(10)]);
    disp(Q)
end
