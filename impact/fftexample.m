function mxi = fft_fit(t,x)
# preform a fourier fit and take 
#
#

# we take ten frequencies from the fourier transform: 
fi = [0.00, 1.35, 2.85, 4.56, 6.53, 8.86, 11.71, 15.38, 20.57, 29.43, 50];
#fi = [0,0.66,1.25,2.08,2.85,3.68,4.56,5.50,6.53,7.64,8.86,10.21,11.71,13.42,15.39,17.72,20.57,24.25,29.43,38.29,50];

% Sampling Frequency
Fs = 1/(t(2)-t(1))

% Use next highest power of 2 greater than or equal to length(x) to calculate fft
nfft = 2^(nextpow2(length(x)));

% Take fft, padding with zeros so that length(fftx) is equal to nfft 
fftx = fft(x,nfft);

# If nfft is even (which it will be, if you use the above two commands above), 
# then the magnitude of the fft will be symmetric, such that the first 
# (1+nfft/2) points are unique, and the rest are symmetrically redundant. The 
# DC component of x is fftx(1) , and fftx(1+nfft/2)> is the Nyquist frequency 
# component of x. If nfft is odd, however, the Nyquist frequency component is 
# not evaluated, and the number of unique points is (nfft+1)/2 . This can be 
# generalized for both cases to ceil((nfft+1)/2) .

% Calculate the number of unique points
NumUniquePts = ceil((nfft+1)/2);

% FFT is symmetric, throw away second half
fftx = fftx(1:NumUniquePts);

% Take the magnitude of fft of x
mx = abs(fftx);

% Scale the fft so that it is not a function of the length of x
mx = mx/length(x);

% Now, take the square of the magnitude of fft of x which has been scaled properly.
% mx = mx.^2; 

% Since we dropped half the FFT, we multiply mx by 2 to keep the same energy.
% The DC component and Nyquist component, if it exists, are unique and should not be multiplied by 2. 
if rem(nfft, 2) % odd nfft excludes Nyquist point 
  mx(2:end) = mx(2:end)*2;
else
  mx(2:end -1) = mx(2:end -1)*2;
end
% This is an evenly spaced frequency vector with NumUniquePts points.
f = (0:NumUniquePts-1)*Fs/nfft;

% Generate the plot, title and labels.
plot(f,mx);
xlabel('Frequency (Hz)'); 
ylabel('Amplitude');

mxi = interp1(f,mx,fi,'spline')

endfunction
