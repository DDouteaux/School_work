function [ output_args ] = Run_KNN( input_args )
%KNN exercices

addpath('./classifier/knn');
addpath('./dataset');
%% Load the raw CIFAR-10 data.
imdb = load_datasets();

% As a sanity check, we print out the size of the training and test data.
disp('Training data shape: ');
disp(size(imdb.train_data));
disp('Training labels shape: ');
disp(size(imdb.train_labels));
disp('Test data shape: ');
disp(size(imdb.test_data));
disp('Test labels shape: ');
disp(size(imdb.test_labels));

%% Visualize some examples from the dataset.
%We show a few examples of training images from each class.

%show_datasets(imdb);

%% Subsample the data for more efficient code execution in this exercise
imdb = subsample_datasets(imdb);

%% Reshape the image data into rows
imdb.train_data = reshape(imdb.train_data, size(imdb.train_data,1), []);
imdb.test_data = reshape(imdb.test_data, size(imdb.test_data,1), []);

disp('Training data shape: ');
disp(size(imdb.train_data));
disp('Training labels shape: ');
disp(size(imdb.train_labels));
disp('Test data shape: ');
disp(size(imdb.test_data));
disp('Test labels shape: ');
disp(size(imdb.test_labels));

%% Create a kNN classifier instance. 
% Remember that training a kNN classifier is a noop: 
% the Classifier simply remembers the data and does no further processing 
model = knn_train(imdb.train_data, imdb.train_labels);

%% Open classifier/knn/knn_compute_distances_two_loops.m and implement it
%Test your implementation:
dists_two = knn_compute_distances_two_loops(model, imdb.test_data);
disp(size(dists_two))

%% Now implement the function knn_predict_labels.m and run the code below:
% We use k = 1 (which is Nearest Neighbor).
k = 1;
test_labels_pred = knn_predict_labels(model, dists_two, k);
num_correct = sum(sum(test_labels_pred == imdb.test_labels));
num_test = length(imdb.test_labels);
accuracy = double(num_correct)/num_test;
fprintf('Got %d / %d correct => accuracy: %f\n',num_correct, num_test, accuracy);
fprintf('You should expect to see approximately 27%% accuracy\n');

%% Now lets try out a larger k, say k = 5:
k = 5;
test_labels_pred = knn_predict_labels(model, dists_two, k);
num_correct = sum(sum(test_labels_pred == imdb.test_labels));
num_test = length(imdb.test_labels);
accuracy = double(num_correct)/num_test;
fprintf('Got %d / %d correct => accuracy: %f\n',num_correct, num_test, accuracy);
fprintf('You should expect to see a slightly better performance than with k = 1.\n');

%% Now lets speed up distance matrix computation by using partial vectorization 
% with one loop. Implement the function knn_compute_distances_one_loop and run the
% code below:

dists_one = knn_compute_distances_one_loops(model, imdb.test_data);

% To ensure that our vectorized implementation is correct, we make sure that it
% agrees with the naive implementation. There are many ways to decide whether
% two matrices are similar; one of the simplest is the Frobenius norm. In case
% you haven't seen it before, the Frobenius norm of two matrices is the square
% root of the squared sum of differences of all elements; in other words, reshape
% the matrices into vectors and compute the Euclidean distance between them.
difference = norm(dists_two - dists_one, 'fro');
fprintf('Difference was: %f\n', difference);
if difference < 0.001
  fprintf( 'Good! The distance matrices are the same\n');
else
  fprintf( 'Uh-oh! The distance matrices are different\n');
end

%% Now implement the fully vectorized version inside knn_compute_distances_no_loops
% and run the code
dists_no = knn_compute_distances_no_loops(model, imdb.test_data);

%check that the distance matrix agrees with the one we computed before:
difference = norm(dists_two - dists_no, 'fro');
fprintf('Difference was: %f\n', difference);
if difference < 0.001
  fprintf( 'Good! The distance matrices are the same\n');
else
  fprintf( 'Uh-oh! The distance matrices are different\n');
end

%% Let's compare how fast the implementations are
tic;
knn_compute_distances_two_loops(model, imdb.test_data);
two_loop_time = toc;
fprintf('Two loop version took %f seconds\n',two_loop_time);

tic;
knn_compute_distances_one_loops(model, imdb.test_data);
two_loop_time = toc;
fprintf('One loop version took %f seconds\n',two_loop_time);

tic;
knn_compute_distances_no_loops(model, imdb.test_data);
two_loop_time = toc;
fprintf('No loop version took %f seconds\n',two_loop_time);

fprintf('you should see significantly faster performance with the fully vectorized implementation\n');

%% Cross-validation
% We have implemented the k-Nearest Neighbor classifier but we set the value
% k = 5 arbitrarily. We will now determine the best value of this 
% hyperparameter with cross-validation.
num_folds = 5;
k_choices = [1, 3, 5, 8, 10, 12, 15, 20, 50, 100];

X_train_folds = {};
y_train_folds = {};

% ################################################################################
% # TODO:                                                                        #
% # Split up the training data into folds. After splitting, X_train_folds and    #
% # y_train_folds should each be lists of length num_folds, where                #
% # y_train_folds[i] is the label vector for the points in X_train_folds[i].     #
% # Hint: Look up the mat2cell function.                                #
% ################################################################################

n_train = size(model.X_train,1);
folds_lengths = ones(1,num_folds) * ((n_train - mod(n_train, num_folds))/num_folds);
%folds_lengths(1,num_folds) = n_train - (num_folds-1)*(n_train - mod(n_train, num_folds)/num_folds);

X_train_folds = mat2cell(model.X_train, folds_lengths, size(model.X_train,2));
Y_train_folds = mat2cell(model.y_train, folds_lengths, size(model.y_train,2));

% ################################################################################
% #                                 END OF YOUR CODE                             #
% ################################################################################
% 
% # A dictionary holding the accuracies for different values of k that we find
% # when running cross-validation. After running cross-validation,
% # k_to_accuracies[k] should be a list of length num_folds giving the different
% # accuracy values that we found when using that value of k.

k_to_accuracies = zeros(length(k_choices), num_folds);


% ################################################################################
% # TODO:                                                                        #
% # Perform k-fold cross validation to find the best value of k. For each        #
% # possible value of k, run the k-nearest-neighbor algorithm num_folds times,   #
% # where in each case you use all but one of the folds as training data and the #
% # last fold as a validation set. Store the accuracies for all fold and all     #
% # values of k in the k_to_accuracies dictionary.                               #
% ################################################################################

for l = 1:length(k_choices)
    for i = 1:num_folds
        % Création des ensembles de tests et d'apprentissage pour cette boucle. L'ensemble de test
        % est celui associé à la couche i.
        train_data_cross_validation = [];
        test_data_cross_validation = [];
        train_label_cross_validation = [];
        test_label_cross_validation = [];
        for j = 1:num_folds
            if(j ~= i)
                train_data_cross_validation = [train_data_cross_validation; X_train_folds{j}];
                train_label_cross_validation= [train_label_cross_validation; Y_train_folds{j}];
            else
                test_data_cross_validation = X_train_folds{j};
                test_label_cross_validation= Y_train_folds{j};
            end
        end

        % On entraîne un modèle en prenant la valeur de k à l'indice l de k_choices. Il nous faut à chaque fois
        % réentraîner le modèle et recalculer les distances car les ensembles changent à chaque étape.
        k = k_choices(l);
        model_cross_validated = knn_train(train_data_cross_validation, train_label_cross_validation);
        dists_no_cross_validated = knn_compute_distances_no_loops(model_cross_validated, test_data_cross_validation);
        test_labels_pred = knn_predict_labels(model_cross_validated, dists_no_cross_validated, k);

        % Éléments correctement prévus par le modèle pour le calcul de la précision.
        num_correct = sum(sum(test_labels_pred == test_label_cross_validation));
        num_test = length(test_label_cross_validation);

        % Enregistrement de la valeur finale obtenue pour le couple (k, numéro couche de test).
        k_to_accuracies(l, i) = double(num_correct)/num_test;
    end
end


% ################################################################################
% #                                 END OF YOUR CODE                             #
% ################################################################################

%  Print out the computed accuracies
for k = 1:size(k_to_accuracies,1)
    for i = 1:size(k_to_accuracies, 2)
        fprintf('k = %d, accuracy = %f\n',k_choices(k), k_to_accuracies(k, i));
    end
end

% # plot the raw observations
figure;
hold on;
for k = 1:length(k_choices)
    scatter(ones(1, size(k_to_accuracies,2))*k_choices(k), k_to_accuracies(k,:))
end
accuaracies_mean = mean(k_to_accuracies,2);
accuaracies_std  = std(k_to_accuracies,0,2);
errorbar(k_choices, accuaracies_mean, accuaracies_std);
title('Cross-validation on k')
xlabel('k')
ylabel('Cross-validation accuracy')
hold off;

% # Based on the cross-validation results above, choose the best value for k,   
% # retrain the classifier using all the training data, and test it on the test
% # data.
best_k = 10;
model = knn_train(imdb.train_data, imdb.train_labels);
labels_pred = knn_predict(model, imdb.test_data, best_k);
num_correct = sum(sum(labels_pred == imdb.test_labels));
num_test = length(imdb.test_labels);
accuracy = double(num_correct)/num_test;
fprintf('Got %d / %d correct => accuracy: %f\n',num_correct, num_test, accuracy);

end

