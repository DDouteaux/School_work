%% BE Apprentissage automatique
%  DOUTEAUX Damien - 3A ECL
%  Avril 2017

function [ seq ] = optimize_behaviour( Q, init_state )
    %% Déterminer le meilleur comportement à partir d'un état initial.
    %
    %  Params :
    %       - Q            : la matrice d'action-valeur entraînée.
    %       - init_state   : le point de départ pour lequel on optimise.
    %
    %  Return :
    %       - seq        : la séquence optimale pour arriver à un état
    %                      final depuis l'état init_state.
    
    %% Variables globales pour l'algorithme.
    seq = [init_state];     % Pour stocker la séquence finale.
    final_state = false;    % Savoir que l'on est dans un état final.
    
    % Un petit peut d'affichage pour l'utilisateur.
    disp('-------------------------------');
    disp(['Départ depuis l''état ' num2str(init_state)]);
    
    %% Boucle principale de lecture de la matrice Q.
    while(~final_state)
        % Ensemble des prochains états optimaux à atteindre.
        optim_next_state_value = max(Q(init_state, :));
        optim_next_states = find(Q(init_state, :) == optim_next_state_value);
       
        % Si plusieurs états optimaux possibles, on prévient l'utilisateur.
        if(size(optim_next_states,2) > 1)
            disp(['--> Plusieurs chemins optimaux possibles à l''indice ' num2str(size(init_state,2)+1)]); 
        end

        % On définit le prochain état optimal (s'il y a le choix).
        init_state = optim_next_states(randi([1 size(optim_next_states,2)]));
        
        % On regarde si on est à un état final. Pour cela, on regarde si 
        % l'algo boucle sur lui même (la meilleure transition est vers 
        % l'état courant.
        final_state = (init_state == seq(size(seq,2)));
        
        if(~final_state)
            seq = [seq init_state];
        end
    end
    
    disp('Séquence optimale proposée : ');
    disp(seq);
end