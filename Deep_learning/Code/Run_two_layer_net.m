function [ output_args ] = Run_two_layers_net( input_args )
%Two layer net exercise

addpath('./classifier/net');
addpath('./dataset');

%% We will use the function `twolayernet_init` in the folder `./classifier/net/
% ` to initialize instances of our network. The network parameters are stored
% in the struct `model` where values are matrices. Below, we initialize toy
% data and a toy model that we will use to develop your implementation.

% Create a small net and some toy data to check your implementations.
% Note that we set the random seed for repeatable experiments.

input_size = 4;
hidden_size = 10;
num_classes = 3;
num_inputs = 5;

model = init_toy_model(input_size, hidden_size, num_classes);
[X,y] = init_toy_data(num_inputs, input_size);
%% Forward pass: compute scores
% Open the file './classifiers/net/twolayernet_loss.m`. This function is
% very similar to the loss functions you have written for the SVM and 
% Softmax exercises: It takes the data and weights and computes the class 
% scores, the loss, and the gradients on the parameters.

% Implement the first part of the forward pass which uses the weights and 
% biases to compute the scores for all inputs.
[loss, grads, scores] = twolayernet_loss(model,X,y,0);
disp('Your scores:');
disp(scores);
correct_scores = [0.39674245, -0.13838192, -0.48429209;
                  0.85662955,  0.42995926,  0.98941754;
                  0.33614122, -0.26699700, -0.59185479;
                 -0.19349664,  0.29995214,  0.39273830;
                  0.26726185, -0.67868934,  0.09010580];
disp('Correct scores:');
disp(correct_scores);             
%The difference should be very small. We get < 1e-7
fprintf('Difference between your scores and correct scores:\n');
fprintf('%e\n', sum(sum(abs(scores - correct_scores))));

%% Forward pass: compute loss
% In the same function, implement the second part that computes the data and regularizaion loss.
[loss, ~] = twolayernet_loss(model,X,y, 0.1);
correct_loss = 1.330037538281351;
% should be very small, we get < 1e-12
fprintf('Difference between your loss and correct loss:\n');
fprintf('%e\n', abs(loss - correct_loss));

%% Backward pass
%Implement the rest of the function. This will compute the gradient of the loss 
% with respect to the variables W1, b1, W2, and b2. Now that you (hopefully!)
% have a correctly implemented forward pass, you can debug your backward pass 
% using a numeric gradient check:
[loss, grad,] = twolayernet_loss(model, X, y, 0.1);
f =@(m)twolayernet_loss(m, X, y, 0.1);
fields = fieldnames(grad);
for i = 1:length(fields)
    [grad_eval] = eval_numerical_gradient(f, model, fields{i}, 0, 0.1);
    fprintf('%-s max relative error :%e\n', fields{i}, rel_error(grad_eval, grad.(fields{i})));
end

%% Train the network
%To train the network we will use stochastic gradient descent (SGD), 
%similar to the SVM and Softmax classifiers. Look at the function 
%`twoLayernet_train` and fill in the missing sections to implement the
%training procedure. This should be very similar to the training procedure
%you used for the SVM and Softmax classifiers. You will also have to implement 
%`twoLayernet_predict`, as the training process periodically performs prediction 
%to keep track of accuracy over time while the network trains.

%Once you have implemented the method, run the code below to train a two-layer 
%network on toy data. You should achieve a training loss less than 0.3.
model = init_toy_model(input_size, hidden_size, num_classes);
params.learning_rate = 1e-1;
params.reg = 1e-5;
params.num_iters = 100;
params.verbose = 0;
[model, stats] = twolayernet_train(model,X,y,X,y,params);

fprintf('Final training loss: %f\n', stats.loss_history(end));
% plot the loss history
figure;
plot(stats.loss_history);
xlabel('iteration');
ylabel('training loss');
title('Training Loss history');

%% Load the data
% Now that you have implemented a two-layer network that passes gradient checks 
% and works on toy data, it's time to load up our favorite CIFAR-10 data so 
% we can use it to train a classifier on a real dataset.

imdb = prepare_net_datasets();
% As a sanity check, we print out the size of the training and test data.
disp('Training data shape: ');
disp(size(imdb.X_train));
disp('Training labels shape: ');
disp(size(imdb.y_train));
disp('Validation data shape: ');
disp(size(imdb.X_val));
disp('Validation labels shape: ');
disp(size(imdb.y_val));
disp('Test data shape: ');
disp(size(imdb.X_test));
disp('Test labels shape: ');
disp(size(imdb.y_test));
disp('==========================================');

%% Train a network
% To train our network we will use SGD with momentum. In addition, we will 
% adjust the learning rate with an exponential learning rate schedule as 
% optimization proceeds; after each epoch, we will reduce the learning rate
% by multiplying it by a decay rate

input_size = 32 * 32 * 3;
hidden_size = 50;
num_classes = 10;

model = twolayernet_init(input_size, hidden_size, num_classes);
params.num_iters = 1000;
params.batch_size = 200;
params.learning_rate = 1e-4;
params.learning_rate_decay = 0.95;
params.reg = 0.5;
params.verbose = 1;
[model, stats] = twolayernet_train(model, imdb.X_train, imdb.y_train, ...
                                   imdb.X_val, imdb.y_val, params);
%Predict on the validation set
val_acc = mean(twolayernet_predict(model, imdb.X_val) == imdb.y_val');
fprintf('Validation accuracy: %f\n', val_acc);

%% Debug the training
% With the default parameters we provided above, you should get a validation 
% accuracy of about 0.29 on the validation set. This isn't very good.

%One strategy for getting insight into what's wrong is to plot the loss 
%function and the accuracies on the training and validation sets during optimization.

%Another strategy is to visualize the weights that were learned in the first
% layer of the network. In most neural networks trained on visual data, the
% first layer weights typically show some visible structure when visualized.

%Plot the loss function and train / validation accuracies
figure;
subplot(2, 1, 1);
plot(stats.loss_history);
title('Loss history');
xlabel('Iteration');
ylabel('Loss');

subplot(2, 1, 2);
hold on;
plot(stats.train_acc_history);
plot(stats.val_acc_history, 'r');
legend('Train', 'Val');
title('Classification accuracy history');
xlabel('Epoch');
ylabel('Clasification accuracy');
hold off;

%% Visualize the weights of the network
show_net_weights(model);

%% Tune your hyperparameters
% Tuning. Tuning the hyperparameters and developing intuition for how they 
% affect the final performance is a large part of using Neural Networks,
% so we want you to get a lot of practice. Below, you should experiment with 
% different values of the various hyperparameters, including hidden layer size,
% learning rate, numer of training epochs, and regularization strength. 
% You might also consider tuning the learning rate decay, but you should 
% be able to get good performance using the default value.

% #################################################################################
% # TODO: Tune hyperparameters using the validation set. Store your best trained  #
% # model in best_net.                                                            #
% #                                                                               #
% # To help debug your network, it may help to use visualizations similar to the  #
% # ones we used above; these visualizations will have significant qualitative    #
% # differences from the ones we saw above for the poorly tuned network.          #
% #                                                                               #
% # Tweaking hyperparameters by hand can be fun, but you might find it useful to  #
% # write code to sweep through possible combinations of hyperparameters          #
% # automatically like we did on the previous exercises.                          #
% #################################################################################

%%%
%%%  Tous ce code a été remanié plusieurs fois pour générer toutes les
%%%  figures et tous résultats du rapport. L'entraînement du modèle
%%%  optimisé à proprement parler vous est proposé plus bas.
%%%

%%%  Valeurs à tester
% Paramètres pour le nombre d'époque et la taille des batchs
num_iterss = [100 500 1000 1500 2000];
batch_sizes = [100 200 500 750 1000];

% Taux d'apprentissage
learning_rates = [1e-7, 5e-7, 1e-6, 5e-6, 1e-5, 1e-4, 2e-4, 3e-4, 5e-4, 8e-4, 1e-3, 5e-3];
learning_rate_decays = [.5, .75, .85, .9, .95, .98];

% Pour la régularisation
% Recherche ordre de grandeur
regs = [.05, .5, 5, 50, 500, 5000];
% Pour affiner la décision
%regs = [.01, .05, .1, .25, .5, .7, .8, .9, .92, .95];

% Nombre de neurone dans la couche cachée
hidden_sizes = [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

%%% Constantes
best_net = {}; % store the best model into this 
best_val = 0;
val_acc_history = [];

params.num_iters = 1000;
params.batch_size = 200;
params.learning_rate = 1e-4;
params.learning_rate_decay = 0.95;
params.reg = .5;
params.verbose = 0;
hidden_size = 100;

%%% Apprentissage des modèles
for i = 1:size(regs,2)
    model = twolayernet_init(input_size, hidden_size, num_classes);
%     reg = regs(i);
%     params.reg = reg;
    [model, stats] = twolayernet_train(model, imdb.X_train, imdb.y_train, ...
                                       imdb.X_val, imdb.y_val, params);
    %Predict on the validation set
    val_acc = mean(twolayernet_predict(model, imdb.X_val) == imdb.y_val');
    val_acc_history = [val_acc_history, val_acc];
    fprintf('Reg : %f, validation accuracy: %f\n', reg, val_acc);
    
    figure;
    subplot(2, 1, 1);
    plot(stats.loss_history);
    title(['Loss history (Reg = ', num2str(params.reg), ')']);
    xlabel('Iteration');
    ylabel('Loss');

    subplot(2, 1, 2);
    hold on;
    plot(stats.train_acc_history);
    plot(stats.val_acc_history, 'r');
    legend('Train', 'Val');
    title(['Classification accuracy history (Reg = ', num2str(params.reg), ')']);
    xlabel('Epoch');
    ylabel('Clasification accuracy');
    hold off;

    if best_val < val_acc
        best_net = model;
        best_val = val_acc;
    end
end

%%% Affichage des évolutions et des poids
figure;
plot(hidden_sizes, val_acc_history, 'r');
title('Validation accuracy in function of hidden size');
xlabel('Hidden size');
ylabel('Validation accuracy');

show_net_weights(model);
show_net_weights(best_net);

%%%
%%%  Coefficients retenus et entraînement du meilleur modèle
%%%
params.num_iters = 4000;
params.batch_size = 200;
params.learning_rate = 1e-3;
params.learning_rate_decay = 0.9;
params.reg = .92;
params.verbose = 0;
hidden_size = 80;

model = twolayernet_init(input_size, hidden_size, num_classes);
[model, stats] = twolayernet_train(model, imdb.X_train, imdb.y_train, ...
                                   imdb.X_val, imdb.y_val, params);
%Predict on the validation set
val_acc = mean(twolayernet_predict(model, imdb.X_val) == imdb.y_val');
val_acc_history = [val_acc_history, val_acc];
fprintf('Validation accuracy: %f\n', val_acc);

figure;
subplot(2, 1, 1);
plot(stats.loss_history);
title(['Loss history (Reg = ', num2str(params.reg), ')']);
xlabel('Iteration');
ylabel('Loss');

subplot(2, 1, 2);
hold on;
plot(stats.train_acc_history);
plot(stats.val_acc_history, 'r');
legend('Train', 'Val');
title(['Classification accuracy history (Reg = ', num2str(params.reg), ')']);
xlabel('Epoch');
ylabel('Clasification accuracy');
hold off;

best_net = model;

% #################################################################################
% #                               END OF YOUR CODE                                #
% #################################################################################

%%  visualize the weights of the best network
show_net_weights(best_net);

%% Run on the test set
test_acc = mean(twolayernet_predict(best_net, imdb.X_test) == imdb.y_test');
fprintf('Test accuracy: %f\n', test_acc);
end

