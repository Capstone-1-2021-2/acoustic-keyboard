f = figure;
f.Position = [0 0 1800 600];

tiledlayout(2,5)

alphabet = 'a';
n = 0;
while n < 10
    user = sprintf('watch/%s/%s%d.m4a', alphabet, alphabet, n+1);

    fs = 48000;
    nyquistFs = fs/2;

    [x, ~] = audioread(user);
    [b, a] = butter(2, [9000/nyquistFs, 10000/nyquistFs], 'bandpass');
    filteredX = filter(b, a, x);

    nexttile
    spectrogram(filteredX, 1024, 512, 1024, fs, 'yaxis');
    title("Spectogram of Index " + (n+1))
    
    n = n + 1;
end