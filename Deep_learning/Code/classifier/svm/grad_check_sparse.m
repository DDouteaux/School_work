function [ output_args ] = grad_check_sparse( f, x, analytic_grad, num_checks, h)
%  sample a few random elements and only return numerical in this dimensions.
    if (nargin<5)
        h = 1e-5;
    end

    if (nargin<4)
        num_checks = 1;
    end

     for i=1:num_checks
        p = randi(size(x,1));
        q = randi(size(x,2));
        x(p,q) = x(p,q) + h;
        fxph = f(x);
        x(p,q) = x(p,q) - 2*h;
        fxmh = f(x);
        x(p,q) = x(p,q) + h;
        grad_numerical = (fxph - fxmh) / (2 * h);
        grad_analytic = analytic_grad(p,q);   
        rel_error = abs(grad_numerical - grad_analytic) / (abs(grad_numerical) + abs(grad_analytic));
        fprintf('numerical: %f analytic: %f, relative error: %e\n',grad_numerical, grad_analytic, rel_error);
     end
end

