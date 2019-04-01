function [X, y] = init_toy_data(num_inputs, input_size)
    rng(1);    
    X = 10 * randn(num_inputs, input_size);
    y = [0; 1; 2; 2; 1] + 1;
end