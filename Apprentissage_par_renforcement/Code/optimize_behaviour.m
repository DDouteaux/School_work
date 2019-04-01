%% BE Apprentissage automatique
%  DOUTEAUX Damien - 3A ECL
%  Avril 2017

function [ seq ] = optimize_behaviour( Q, init_state )
    %% D�terminer le meilleur comportement � partir d'un �tat initial.
    %
    %  Params :
    %       - Q            : la matrice d'action-valeur entra�n�e.
    %       - init_state   : le point de d�part pour lequel on optimise.
    %
    %  Return :
    %       - seq        : la s�quence optimale pour arriver � un �tat
    %                      final depuis l'�tat init_state.
    
    %% Variables globales pour l'algorithme.
    seq = [init_state];     % Pour stocker la s�quence finale.
    final_state = false;    % Savoir que l'on est dans un �tat final.
    
    % Un petit peut d'affichage pour l'utilisateur.
    disp('-------------------------------');
    disp(['D�part depuis l''�tat ' num2str(init_state)]);
    
    %% Boucle principale de lecture de la matrice Q.
    while(~final_state)
        % Ensemble des prochains �tats optimaux � atteindre.
        optim_next_state_value = max(Q(init_state, :));
        optim_next_states = find(Q(init_state, :) == optim_next_state_value);
       
        % Si plusieurs �tats optimaux possibles, on pr�vient l'utilisateur.
        if(size(optim_next_states,2) > 1)
            disp(['--> Plusieurs chemins optimaux possibles � l''indice ' num2str(size(init_state,2)+1)]); 
        end

        % On d�finit le prochain �tat optimal (s'il y a le choix).
        init_state = optim_next_states(randi([1 size(optim_next_states,2)]));
        
        % On regarde si on est � un �tat final. Pour cela, on regarde si 
        % l'algo boucle sur lui m�me (la meilleure transition est vers 
        % l'�tat courant.
        final_state = (init_state == seq(size(seq,2)));
        
        if(~final_state)
            seq = [seq init_state];
        end
    end
    
    disp('S�quence optimale propos�e : ');
    disp(seq);
end