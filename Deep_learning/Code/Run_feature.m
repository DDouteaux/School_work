%%%   /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\
%%%   /!\ Code non testé, car je n'ai pas réussi à charger et préparer entièrement/!\
%%%   /!\ les données sur ma machine...                                           /!\
%%%   /!\ Le code à faire personnellement est tout de même fourni, car très proche/!\
%%%   /!\ de ce qui a été fait, bien que j'ai conscience que le plus intéressant  /!\
%%%   /!\ était l'optimisation que je n'ai pas pu mener...                        /!\
%%%   /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\



function [ output_args ] = Run_feature( input_args )
% Image feature exercise

addpath('./classifier/feature');
addpath('./dataset');
%% Load data
% Similar to previous exercises, we will load CIFAR-10 data from disk.
imdb = prepare_datasets_for_feature();
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
%% Extract Features
%For each image we will compute a Histogram of Oriented
%Gradients (HOG) as well as a color histogram using the hue channel in HSV
%color space. We form our final feature vector for each image by concatenating
%the HOG and color histogram feature vectors.

f_hog = @(x)hog_feature(x);
feature_fns{1} = f_hog;
num_color_bins = 10; %Number of bins in the color histogram
f_hsv = @(x)color_histogram_hsv(x, num_color_bins);
feature_fns{2} = f_hsv;
X_train_feats = extract_features(imdb.X_train, feature_fns, 1);
X_val_feats = extract_features(imdb.X_val, feature_fns);
X_test_feats = extract_features(imdb.X_test, feature_fns);

mean_feats = mean(X_train_feats, 1);
std_feats  = std(X_train_feats, 1);

% Preprocessing: Subtract the mean feature
X_train_feats  = bsxfun(@minus, X_train_feats, mean_feats);
X_val_feats    = bsxfun(@minus, X_val_feats, mean_feats);
X_test_feats   = bsxfun(@minus, X_test_feats, mean_feats);

% Preprocessing: Divide by standard deviation.
X_train_feats  = bsxfun(@rdivide, X_train_feats, std_feats);
X_val_feats    = bsxfun(@rdivide, X_val_feats, std_feats);
X_test_feats   = bsxfun(@rdivide, X_test_feats, std_feats);

% Preprocessing: Add a bias dimension
X_train_feats = cat(2, X_train_feats, ones(size(X_train_feats, 1), 1));
X_val_feats =   cat(2, X_val_feats,   ones(size(X_val_feats, 1),   1));
X_test_feats =  cat(2, X_test_feats,  ones(size(X_test_feats, 1),  1));

%% Train SVM on features
% Using the multiclass SVM code developed earlier in the assignment, 
%train SVMs on top of the features extracted above; this should achieve 
% better results than training SVMs directly on top of raw pixels.
addpath('./classifier/svm');

learning_rates = [1e-9, 1e-8, 1e-7];
regularization_strengths = [1e5, 1e6, 1e7];

results = zeros(length(learning_rates), length(regularization_strengths), 2); %a matrix resotres results
best_val = -1;   %The highest validation accuracy that we have seen so far.
best_svm = struct(); %The LinearSVM model that achieved the highest validation rate.

% ################################################################################
% # TODO:                                                                        #
% # Use the validation set to set the learning rate and regularization strength. #
% # This should be identical to the validation that you did for the SVM; save    #
% # the best trained classifer in best_svm. You might also want to play          #
% # with different numbers of bins in the color histogram. If you are careful    #
% # you should be able to get accuracy of near 0.44 on the validation set.       #
% ################################################################################

iter_num = 1000;

for i = 1:size(learning_rates,2)
    disp(i)
    for j = 1:size(regularization_strengths,2)
        learning_rate = learning_rates(i);
        regularization_strength = regularization_strengths(j);
        [model, loss_hist] = linear_softmax_train(imdb.X_train, imdb.y_train, learning_rate , regularization_strength, iter_num, 200, 0);
        validation_accuracy = mean(imdb.y_val == linear_softmax_predict(model, imdb.X_val));
        disp('Learning rate : %f    Regularization strength : %f       -> Validation accuracy : %f', learning_rate, regularization_strength, validation_accuracy);
        results(i,j,:) = validation_accuracy;
        if best_val < validation_accuracy
            best_svm = model;
            best_val = validation_accuracy;
        end
    end
end

% ################################################################################
% #                              END OF YOUR CODE                                #
% ################################################################################

% Print out results.
for i =1:length(learning_rates)
    for j= 1:length(regularization_strengths)
         fprintf('lr %e reg %e train accuracy: %f val accuracy: %f\n', ...
             learning_rates(i), regularization_strengths(j), results(i,j,1), results(i,j,2));
    end
end
fprintf('best validation accuracy achieved during cross-validation: %f\n', best_val);

%Evaluate the best svm on test set
y_test_pred = linear_svm_predict(best_svm, X_test_feats);
test_accuracy = mean(imdb.y_test == y_test_pred');
fprintf('linear SVM on raw pixels final test set accuracy: %f\n', test_accuracy);

% An important way to gain intuition about how an algorithm works is to
% visualize the mistakes that it makes. In this visualization, we show examples
% of images that are misclassified by our current system. The first column
% shows images that our system labeled as "plane" but whose true label is
% something other than "plane".

examples_per_class = 8;
classes = imdb.class_names;
for i = 1:length(classes)
    idxs = find((imdb.y_test ~= i).*(y_test_pred' == i));
    idxs = datasample(idxs, examples_per_class, 'Replace',false);
    for j= 1:length(idxs)
        subplot(examples_per_class, length(classes), (j-1) * length(classes) + i);
        imshow(uint8(squeeze(imdb.X_test(idxs(j),:,:,:))));
        axis('off');
        if j == 1
            title(classes{i})
        end
    end
end

%% Neural Network on image features

addpath('./classifier/net');

% remove the bias
X_train_feats = X_train_feats(:, 1:end-1);
X_val_feats   = X_val_feats(:, 1:end-1);
X_test_feats  = X_test_feats(:, 1:end-1);

input_size = size(X_train_feats, 2);
hidden_size = 500;
num_classes = 10;

best_net = {}; % store the best model into this 
best_val = 0;

% ################################################################################
% # TODO: Train a two-layer neural network on image features. You may want to    #
% # cross-validate various parameters as in previous sections. Store your best   #
% # model in the best_net variable.                                              #
% ################################################################################

%%
%%
%%     ----> reprendre le code de l'optimisation des hyper-paramètres pour le réseau 2 couches.
%%
%%

fprintf('best validation accuracy achieved during cross-validation: %f\n', best_val);

% ################################################################################
% #                              END OF YOUR CODE                                #
% ################################################################################


%% Run on the test set
test_acc = mean(twolayernet_predict(best_net, X_test_feats) == imdb.y_test');
fprintf('Test accuracy: %f\n', test_acc);
end

