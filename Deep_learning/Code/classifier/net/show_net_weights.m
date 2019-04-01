function []= show_net_weights(model)
    W1 = reshape(model.W1', [], 32, 32, 3);
    grid = visualize_grid(W1);
    figure;
    imshow(uint8(grid));
end
