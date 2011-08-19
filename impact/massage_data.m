function [data] = massage_data(FILENAME)
% This function massages the input data so the impact time is always zero. The
% input file is formatted as a csv file with the columns representing: time, 
% accelerometer x,y,z, gyroscope x,y,z.

data = csvread(FILENAME);
impactTime = min(data(:,1));
data(:,1) = data(:,1) - impactTime;
end
