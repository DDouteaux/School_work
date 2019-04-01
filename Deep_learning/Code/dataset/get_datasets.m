function [ output_args ] = get_datasets( input_args )
%Download Cifar-10 dataset
    disp('Downloading Cifar-10 dataset.................');
    url = 'http://www.cs.toronto.edu/~kriz/cifar-10-matlab.tar.gz';
    untar(url);
end

