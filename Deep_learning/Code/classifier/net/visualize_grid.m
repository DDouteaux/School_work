function [ grid ] = visualize_grid( Xs, ubound, padding )
%VISUALIZE_GRID Summary of this function goes here
%   Detailed exp  lanation goes here
    if (nargin<3)
        padding = 1;
    end
    if (nargin<2)
        ubound = 255.0;
    end
    
    [N, H, W, C] = size(Xs);
    grid_size = int16(ceil(sqrt(N)));
    grid_height = H * grid_size + padding * (grid_size - 1);
    grid_width = W * grid_size + padding * (grid_size - 1);
    grid = zeros(grid_height, grid_width, C);
    next_idx = 1;
    y0 = 1;
    y1 = H;
    for y = 1:grid_size
        x0 = 1;
        x1 = W;
        for x = 1:grid_size
            if next_idx <= N
                img = squeeze(Xs(next_idx,:,:,:));
                low = min(img(:));
                high = max(img(:));
                grid(y0:y1, x0:x1, :) = ubound * (img - low) / (high - low);
                next_idx = next_idx + 1;
            end
        x0 = x0 + W + padding;
        x1 = x1 + W + padding;
        end
    y0 = y0 + H + padding;
    y1 = y1 + H + padding;
    end
end

