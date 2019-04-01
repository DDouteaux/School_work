function [ grad ] = eval_numerical_gradient( f, model, fields,verbose, h)
% a naive implementation of numerical gradient of f at x 
%   - f should be a function that takes a single argument
%   - model the net model to evaluate the gradient at
    if (nargin<5)
        h = 0.00001;
    end
    if (nargin<4)
        verbose = 1;
    end
    if (nargin<3)
        error('No enough input parameters\n');
    end
    
    [m,n] = size(model.(fields));
    grad = size(m,n);
    for i= 1:m
        for j = 1:n
            oldval = model.(fields)(i,j);
            model.(fields)(i,j) = oldval + h; % increment by h
            fxph = f(model); % evalute f(x + h)
            model.(fields)(i,j) = oldval - h;
            fxmh = f(model); % evaluate f(x - h)
            model.(fields)(i,j) = oldval; % restore
            
            %compute the partial derivative with centered formula
            grad(i,j) = (fxph - fxmh) / (2 * h); % the slope
            
            if verbose
                fprintf('(%d,%d) = %f\n', i, j, grad(i,j));
            end
        end
    end
end

