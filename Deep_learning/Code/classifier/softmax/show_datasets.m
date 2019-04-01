function [ output_args ] = show_datasets( imdb )
%SHOW_DATASETS Summary of this function goes here
%   Detailed explanation goes here

num_classes = size(imdb.class_names, 1);
samples_per_class = 7;

figure;
hold on;
for i=1:num_classes
    idxs = find(imdb.train_labels == i);
    idxs = randsample(idxs,samples_per_class, false);
    for j=1:length(idxs)
        plt_idx = (j-1) * num_classes + i;
        subplot(samples_per_class, num_classes, plt_idx);
        img = uint8(squeeze(imdb.train_data(idxs(j),:,:,:)));
        imshow(img);
        if (j==1)
            title(imdb.class_names(i));
        end
    end
end

hold off;
end

