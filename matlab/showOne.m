alphabet = 'i';
n = 7;
user = sprintf('watch/%s/%s%d.m4a', alphabet, alphabet, n);

fs = 48000;
nyquistFs = fs/2;

[x, ~] = audioread(user);
[b, a] = butter(2, [9000/nyquistFs, 10000/nyquistFs], 'bandpass');
filteredX = filter(b, a, x);

spectrogram(filteredX, 1024, 512, 1024, fs, 'yaxis');
title("Spectogram of Index " + n)