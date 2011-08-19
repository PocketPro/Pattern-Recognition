data = massage_data("data/161.csv");

t = data(:,1);    # the time data
N = size(t,1);    # the number of data points
ts = t(2)-t(1);   # the time step
Ws = 2*pi/Ts;     # the frequency step size

y = data(:,2);    # the function data

f = fft(y);       
f = f(1:N/2+1);   # we keep only the lower half of the frequencies
W=Ws*(0:N/2)/N;   # the corresponding frequencies
