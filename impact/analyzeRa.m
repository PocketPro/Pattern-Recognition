function [inputs, targets] = analyzeRa()
% this function helps aggregate the data for preforming a neural network 
% analysis to estimate the clubhead impact location. The general workflow 
% for this problem is:
%   1)  Read the "RaGe.csv" file and extract the target data and the 
%   corresponding fileID.
%   2)  Read the data in [fileID].csv and preform a n-parameter linear 
%   regression on the each channel to extract the set of features.
%   3)  Store the target data in targets and the input data in inputs.
%   Before the function returns, inputs and targets is formatted as
%   columns - each columb being a single input case or output case.
%   4)  Save the workspace for use by matlab.

fileId_row = 7;
clubFaceX_row = 3;
clubFaceY_row = 4;

inputs = [];
targets = [];

dataDirectories = dir('expt_*');
nDirectories = length(dataDirectories);

for k = 1:nDirectories

  directoryName = dataDirectories(k).name;

  raPath = sprintf('%s/RaGe.csv', directoryName);
  raData = csvread(raPath);
  fileIDs = raData(:,fileId_row);
  nFiles = size(fileIDs,1);

  for i=1:nFiles
    fileID = fileIDs(i);
    target = [raData(i, clubFaceX_row), raData(i,clubFaceY_row)];

    dataPath = sprintf('%s/data/%d.csv',directoryName,fileID);
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

inputs = inputs';
targets = targets';

save data.mat inputs targets

end
