function [error] = rel_error(x, y)
% returns relative error """
    p = abs(x) + abs(y);
    p(p<1e-8) = 1e-8;
    error = max(max(abs(x-y)./p));
end