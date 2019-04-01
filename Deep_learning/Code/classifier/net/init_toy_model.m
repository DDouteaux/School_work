function [model] = init_toy_model(input_size, hidden_size, num_classes)
    rng(0);
    model = twolayernet_init(input_size, hidden_size, num_classes, 1e-1);
end
