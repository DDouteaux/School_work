function [ model ] = twolayernet_init( input_size, hidden_size, output_size, std)
% Initialize the model. Weights are initialized to small random values and
% biases are initialized to zero. Weights and biases are stored in the
% variable self.params, which is a dictionary with the following keys:
% 
% W1: First layer weights; has shape (D, H)
% b1: First layer biases; has shape (H,)
% W2: Second layer weights; has shape (H, C)
% b2: Second layer biases; has shape (C,)
% 
% Inputs:
% - input_size: The dimension D of the input data.
% - hidden_size: The number of neurons H in the hidden layer.
% - output_size: The number of classes C.
   if (nargin<4)
       std = 1e-4;
   end
   if (nargin<3)
       error('No enough input parameters\n');
   end
   
   model.W1 = std * randn(input_size, hidden_size);
   model.b1 = zeros(1, hidden_size);
   model.W2 = std * randn(hidden_size,output_size);
   model.b2 = zeros(1, output_size);   
   
end
