% The folder contains the club face impact location pattern recognition
% tools.

% Tasks:
% - Add test data
% - Load saved data.
% - Create a neural network
% - Customize a neural network
% - Adjust FFT fitting

% To Do:
% - fft_fit to return phase, vary number of frequences, vary max frequency
% - Customize a neural network
% - principal component analysis

% Add Test Data:
% To add test data, export the swing data from Ra into this folder. The
% folder name should be prefixed with 'expt_'. Next, run the function 
% analyzeRa. AnalyzeRa will read all data directories in this folder,
% extracting the impact location and the DFT fit parameters for each swing.
% The results are stored in the variables inputs and targets in the file
% data.mat. An example call to analyzeRa.
[inputs, targets] = analyzeRa();

% Load Saved Data
% After test data has been updated and saved to data.mat, analyzeRa does
% not need to be run again. Instead, the inputs and targets can be
% retreived from the data.mat file. An example of loading inputs and
% targets from data.mat:
load data.mat;

% Create A Neural Network
% Before you can create a neural network, you need to have two variables
% representing the inputs and target states. These variables need to be
% formatted as a matrix of columns where each column represents a single
% input vector or target state. The number of colums in the input and
% target vectors must match. To create the network, use the create_pr_net
% function. This function creates a neural network object, trains it, saves
% it to the file network.mat and returns it. An example call to
% create_pr_net:
net = create_pr_net(inputs, targets);

