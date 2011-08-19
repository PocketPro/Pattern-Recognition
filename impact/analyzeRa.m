function [inputs, targets] = analyzeRa()
% this function helps aggregate the data for preforming a neural network analysis
% to estimate the clubhead impact location. The general workflow for this problem
% is:
%   1)  read the "RaGe.csv" file and extract the target data and the corresponding fileID
%   2)  read the data in [fileID].csv and preform a n-parameter linear regression on
%       the each channel to extract the set of features.
%   3)  store the target data in targets and the input data in inputs.
%   4)  save the workspace for use by matlab.

fileId_row = 7;
clubFaceX_row = 3;
clubFaceY_row = 4;

inputs = [];
targets = [];

raData = csvread('RaGe.csv');
fileIDs = raData(:,fileId_row);
nFiles = size(fileIDs,1);

for i=1:nFiles
  fileID = fileIDs(i);
  target = [raData(i, clubFaceX_row), raData(i,clubFaceY_row)];

  dataPath = sprintf('data/%d.csv',fileID);
  data = massage_data(dataPath);
  input = [];
  time = data(:,1);

  for j = 2:7
    y = data(:,j);
    parameters = fft_fit(time, y);
    input = [input,parameters];
  end

  inputs = [inputs;input];
  targets = [targets;target];
  
end
end
