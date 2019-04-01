function [ output_args ] = Run_svm( input_args )
%SVM exercise

addpath('./classifier/svm');
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
disp('==========================================');
%% Visualize some examples from the dataset.
%We show a few examples of training images from each class.

%show_datasets(imdb);

%% Split the data into train, val, and test sets. In addition we will
% create a small development set as a subset of the training data;
% we can use this for development so our code runs faster.

imdb = split_data(imdb);

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

%% Preprocessing: reshape the image data into rows
imdb.X_train = reshape(imdb.X_train, size(imdb.X_train,1), []);
imdb.X_val   = reshape(imdb.X_val,   size(imdb.X_val  ,1), []);
imdb.X_test  = reshape(imdb.X_test,  size(imdb.X_test ,1), []);
imdb.X_dev   = reshape(imdb.X_dev,   size(imdb.X_dev  ,1), []);

% As a sanity check, print out the shapes of the data
disp('Training data shape: ');
disp(size(imdb.X_train));
disp('Validation data shape: ');
disp(size(imdb.X_val));
disp('Test data shape: ');
disp(size(imdb.X_test));
disp('Dev data shape: ');
disp(size(imdb.X_dev));
disp('==========================================');

%% Preprocessing: subtract the mean image
% first: compute the image mean based on the training data
mean_image = mean(imdb.X_train, 1);
disp(mean_image(1:10)); % print a few of the elements
figure;
imshow(uint8(reshape(mean_image, 32, 32, 3)));

%second: subtract the mean image from train and test data
imdb.X_train = bsxfun(@minus, imdb.X_train, mean_image);
imdb.X_val   = bsxfun(@minus, imdb.X_val  , mean_image);
imdb.X_test  = bsxfun(@minus, imdb.X_test , mean_image);
imdb.X_dev   = bsxfun(@minus, imdb.X_dev  , mean_image);

%third: append the bias dimension of ones (i.e. bias trick) so that our SVM
%only has to worry about optimizing a single weight matrix W.
imdb.X_train = cat(2, imdb.X_train, ones(size(imdb.X_train, 1), 1));
imdb.X_val   = cat(2, imdb.X_val  , ones(size(imdb.X_val  , 1), 1));
imdb.X_test  = cat(2, imdb.X_test , ones(size(imdb.X_test , 1), 1));
imdb.X_dev   = cat(2, imdb.X_dev  , ones(size(imdb.X_dev  , 1), 1));

%% SVM Classifier
% Your code for this section will all be written inside 
% the folder "./classifier/svm/" 
% As you can see, we have prefilled the function `svm_loss_naive`
% which uses for loops to evaluate the multiclass SVM loss function. 

%Evaluate the naive implementation of the loss we provided for you:
W = randn(10, 3073) * 0.0001;
[loss, dW] = svm_loss_naive(W, imdb.X_train, imdb.y_train, 0.00001);

fprintf('loss: %f\n',loss);

%% The grad returned from the function above is right now all zero. Derive 
% and implement the gradient for the SVM cost function and implement it inline
% inside the function svm_loss_naive. You will find it helpful to interleave 
% your new code inside the existing function.

% To check that you have correctly implemented the gradient correctly, 
% you can numerically estimate the gradient of the loss function and compare
% the numeric estimate to the gradient that you computed. We have provided code 
% that does this for you:

%% Once you've implemented the gradient, recompute it with the code below
% and gradient check it with the function we provided for you
% Compute the loss and its gradient at W.
[loss, grad] = svm_loss_naive(W, imdb.X_train, imdb.y_train, 0.0);

% Numerically compute the gradient along several randomly chosen dimensions, and
% compare them with your analytically computed gradient. The numbers should match
% almost exactly along all dimensions.
f = @(x)svm_loss_vectorized(x, imdb.X_train, imdb.y_train, 0.0);
grad_check_sparse(f, W, grad, 10);
disp('==========================================');
%do the gradient check once again with regularization turned on
%you didn't forget the regularization gradient did you?
f = @(x)svm_loss_vectorized(x, imdb.X_train, imdb.y_train, 1e2);
grad_check_sparse(f, W, grad, 10);

%% Next implement the function svm_loss_vectorized; for now only compute the loss;
% we will implement the gradient in a moment.
tic;
[loss_naive, ~] = svm_loss_naive(W, imdb.X_train, imdb.y_train, 0.00001);
time = toc;
fprintf('Naive loss: %e computed in %fs\n', loss_naive, time);

tic;
[loss_vectorized, ~] = svm_loss_vectorized(W, imdb.X_train, imdb.y_train, 0.00001);
time = toc;
fprintf('Vectorized loss: %e computed in %fs\n', loss_vectorized, time);

%The losses should match but your vectorized implementation should be much faster.
fprintf('difference: %f\n', loss_naive - loss_vectorized);

%% Complete the implementation of svm_loss_vectorized, and compute the gradient
% of the loss function in a vectorized way.
% 
% The naive implementation and the vectorized implementation should match, but
% the vectorized version should still be much faster.
tic;
[~, grad_naive] = svm_loss_naive(W, imdb.X_train, imdb.y_train, 0.00001);
time = toc;
fprintf('Naive loss and gradient: computed in %fs\n',time);

tic;
[~, grad_vectorized] = svm_loss_vectorized(W, imdb.X_train, imdb.y_train, 0.00001);
time = toc;
fprintf('Vectorized loss and gradient: computed in %fs\n', time);

% The loss is a single number, so it is easy to compare the values computed
% by the two implementations. The gradient on the other hand is a matrix, so
% we use the Frobenius norm to compare them. 
difference = norm(grad_naive - grad_vectorized, 'fro');
fprintf('difference: %f\n', difference);

%% Stochastic Gradient Descent
% We now have vectorized and efficient expressions for the loss, the gradient 
% and our gradient matches the numerical gradient. We are therefore ready to 
% do SGD to minimize the loss.

% Now implement SGD in linear_svm_train() function and run it with the code below
tic;
[model, loss_hist] = linear_svm_train(imdb.X_train, imdb.y_train, 1e-7, 5e4, 1500, 200, 1);
time = toc;
fprintf('That took %fs\n', time);

%A useful debugging strategy is to plot the loss as a function of iteration number:
figure;
plot(loss_hist);
xlabel('Iteration number');
ylabel('Loss Value');

%Write the linear_svm_predict function and evaluate the performance on both the 
%training and validation set
y_train_pred = linear_svm_predict(model, imdb.X_train);
fprintf('training accuracy: %f\n', mean(imdb.y_train == y_train_pred'));
y_val_pred = linear_svm_predict(model, imdb.X_val);
fprintf('validation accuracy: %f\n', mean(imdb.y_val == y_val_pred'));

%% Use the validation set to tune hyperparameters (regularization strength and
% learning rate). You should experiment with different ranges for the learning
% rates and regularization strengths; if you are careful you should be able to
% get a classification accuracy of about 0.4 on the validation set.
learning_rates = [1e-7, 2e-7, 3e-7, 5e-5, 8e-7];
regularization_strengths = [1e4, 2e4, 3e4, 4e4, 5e4, 6e4, 7e4, 8e4, 1e5];

% results is dictionary mapping tuples of the form
% (learning_rate, regularization_strength) to tuples of the form
% (training_accuracy, validation_accuracy). The accuracy is simply the fraction
% of data points that are correctly classified.
results = zeros(length(learning_rates), length(regularization_strengths), 2); %a matrix resotres results
best_val = -1;   %The highest validation accuracy that we have seen so far.
best_svm = struct(); %The LinearSVM model that achieved the highest validation rate.

% ################################################################################
% # Write code that chooses the best hyperparameters by tuning on the validation #
% # set. For each combination of hyperparameters, train a linear SVM on the      #
% # training set, compute its accuracy on the training and validation sets, and  #
% # store these numbers in the results dictionary. In addition, store the best   #
% # validation accuracy in best_val and the LinearSVM model that achieves this  #
% # accuracy in best_svm.                                                        #
% #                                                                              #
% # Hint: You should use a small value for num_iters as you develop your         #
% # validation code so that the SVMs don't take much time to train; once you are #
% # confident that your validation code works, you should rerun the validation   #
% # code with a larger value for num_iters.                                      #
% ################################################################################
iter_num = 1000;
%iter_num = 100;

for i = 1:size(learning_rates,2)
    disp(i)
    for j = 1:size(regularization_strengths,2)
        learning_rate = learning_rates(i);
        regularization_strength = regularization_strengths(j);
        [model, loss_hist] = linear_svm_train(imdb.X_train, imdb.y_train, learning_rate , regularization_strength, iter_num, 200, 0);
        validation_accuracy = mean(imdb.y_val == linear_svm_predict(model, imdb.X_val)');
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


% Visualize the cross-validation results
% plot training accuracy
[x_scatter, y_scatter] = meshgrid(log(learning_rates), log(regularization_strengths));
x_scatter = reshape(x_scatter, 1, []);
y_scatter = reshape(y_scatter, 1, []);

figure;
hold on;
marker_size = 100;
colors = reshape(results(:,:,1), 1, []);
subplot(2, 1, 1)
scatter(x_scatter, y_scatter, marker_size, colors, 'filled');
colorbar();
xlabel('log learning rate');
ylabel('log regularization strength');
title('CIFAR-10 training accuracy');

%plot validation accuracy
colors = reshape(results(:,:,2), 1, []);
subplot(2, 1, 2)
scatter(x_scatter, y_scatter, marker_size, colors, 'filled');
colorbar();
xlabel('log learning rate');
ylabel('log regularization strength');
title('CIFAR-10 validation accuracy')
hold off;

%Evaluate the best svm on test set
y_test_pred = linear_svm_predict(best_svm, imdb.X_test);
test_accuracy = mean(imdb.y_test == y_test_pred');
fprintf('linear SVM on raw pixels final test set accuracy: %f\n', test_accuracy);


%% Visualize the learned weights for each class.
%Depending on your choice of learning rate and regularization strength, these may
%or may not be nice to look at.
w = best_svm.W(:,1:end-1); % strip out the bias
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

