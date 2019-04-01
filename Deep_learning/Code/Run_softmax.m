function [ output_args ] = Run_softmax( input_args )
%SoftMax exercise

addpath('./classifier/softmax');
addpath('./dataset');
%% Load and preprocess the raw CIFAR-10 data.
imdb = prepare_datasets();

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


%% Softmax Classifier
%First implement the naive softmax loss function with nested loops.
%Open the file ./classifiers/softmax/softmax_loss_naive.m and implement the
%softmax_loss_naive function.

% Generate a random softmax weight matrix and use it to compute the loss.
W = randn(10, 3073) * 0.0001;
[loss, grad] = softmax_loss_naive(W, imdb.X_train, imdb.y_train, 0.0);

% As a rough sanity check, our loss should be something close to -log(0.1).
fprintf('loss: %f\n', loss);
fprintf('sanity check: %f\n', (-log(0.1)));
 
%Complete the implementation of softmax_loss_naive and implement a (naive)
%version of the gradient that uses nested loops.
[loss, grad] = softmax_loss_naive(W, imdb.X_train, imdb.y_train, 0.0);

%As we did for the SVM, use numeric gradient checking as a debugging tool.
%The numeric gradient should be close to the analytic gradient.
f = @(x)softmax_loss_vectorized(x, imdb.X_train, imdb.y_train, 0.0);
grad_check_sparse(f, W, grad, 10);
disp('==========================================');

%similar to SVM case, do another gradient check with regularization
f = @(x)softmax_loss_vectorized(x, imdb.X_train, imdb.y_train, 1e2);
grad_check_sparse(f, W, grad, 10);

%% Now that we have a naive implementation of the softmax loss function and its gradient,
%implement a vectorized version in softmax_loss_vectorized.
%The two versions should compute the same results, but the vectorized version should be
%much faster.
tic;
[loss_naive, grad_naive] = softmax_loss_naive(W, imdb.X_train, imdb.y_train, 0.00001);
time = toc;
fprintf('Naive loss: %e computed in %fs\n', loss_naive, time);

tic;
[loss_vectorized, grad_vectorized] = softmax_loss_vectorized(W, imdb.X_train, imdb.y_train, 0.00001);
time = toc;
fprintf('Vectorized loss: %e computed in %fs\n', loss_vectorized, time);

%As we did for the SVM, we use the Frobenius norm to compare the two versions
%of the gradient.
grad_difference = norm(grad_naive - grad_vectorized, 'fro');

fprintf('Loss difference: %f\n', abs(loss_naive - loss_vectorized));
fprintf('Gradient difference: %f\n', grad_difference);

%% Stochastic Gradient Descent
% Use the validation set to tune hyperparameters (regularization strength and
% learning rate). You should experiment with different ranges for the learning
% rates and regularization strengths; if you are careful you should be able to
% get a classification accuracy of over 0.35 on the validation set.

learning_rates = [1e-7, 5e-7];
regularization_strengths = [5e4, 1e8];

results = zeros(length(learning_rates), length(regularization_strengths), 2); %a matrix resotres results
best_val = -1;   %The highest validation accuracy that we have seen so far.
best_softmax = struct(); %The Linears model that achieved the highest validation rate.

% ################################################################################
% # TODO:                                                                        #
% # Use the validation set to set the learning rate and regularization strength. #
% # This should be identical to the validation that you did for the SVM; save    #
% # the best trained softmax classifer in best_softmax.                          #
% ################################################################################
iter_num = 1000;
%iter_num = 100;

for i = 1:size(learning_rates,2)
    disp(i)
    for j = 1:size(regularization_strengths,2)
        learning_rate = learning_rates(i);
        regularization_strength = regularization_strengths(j);
        [model, loss_hist] = linear_softmax_train(imdb.X_train, imdb.y_train, learning_rate , regularization_strength, iter_num, 200, 0);
        validation_accuracy = mean(imdb.y_val == linear_softmax_predict(model, imdb.X_val)');
        results(i,j,:) = validation_accuracy;
        if best_val < validation_accuracy
            best_softmax = model;
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

%Evaluate the best softmax on test set
y_test_pred = linear_softmax_predict(best_softmax, imdb.X_test);
test_accuracy = mean(imdb.y_test == y_test_pred');
fprintf('linear Softmax on raw pixels final test set accuracy: %f\n', test_accuracy);

%% Visualize the learned weights for each class.
%Depending on your choice of learning rate and regularization strength, these may
%or may not be nice to look at.
w = best_softmax.W(:,1:end-1); % strip out the bias
w = reshape(w,10, 32, 32, 3);
w_min = min(w(:));
w_max = max(w(:));
classes = imdb.class_names;

figure;
hold on;
for i = 1:10
  subplot(2, 5, i)    
  % Rescale the weights to be between 0 and 255
  wimg = 255.0 * (squeeze(w(i,:,:,:)) - w_min) / (w_max - w_min);
  imshow(uint8(wimg));
  axis('off');
  title(classes{i});
end

end

