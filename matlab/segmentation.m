alphabet = 'a';
set = '1';
user = sprintf('watch/%c/%c%c.m4a', alphabet, alphabet, set);

fs = 48000;
nyquistFs = fs/2;   % Nyquist frequency

[x, ~] = audioread(user);
[b, a] = butter(2, [9000/nyquistFs, 10000/nyquistFs], 'bandpass');  % filtering: 9000 ~ 10000 Hz
filteredX = filter(b, a, x);

s = stft(filteredX);
filteredS = sum(abs(s(42:64,:)));   % 8000 ~ 12000 Hz 구간의 magnitude를 살펴 본다
                                    % stft에서는 FFTLength;(max:128) => 42.66 ~ 64
avg = mean(filteredS, 2);

f = figure;
f.Position = [0 0 1800 600];

tiledlayout(2,5)

cnt = 0;
idx = 0;
for i = 1:length(filteredS)
    if cnt == 10    % Collect 10 samples
        break
    end
    if filteredS(i) >= 4.0 * avg % trial and error: 4.0, maxS = max(filteredS);를 고려한 비율을 사용할 수도 있을 것
        idx = i - 200;  % 조금 앞에서 crop
        
        t = ceil((idx/length(filteredS)) * length(filteredX));   % filteredX 상에서 time point 찾기
        peakedX = filteredX((t:t+40000),1);   % trial and error: peak의 시작 지점부터 일정 시간까지 crop하기
        i = i + (50000 * length(filteredS)) / length(filteredX);
        
        nexttile
        spectrogram(peakedX, 1024, 512, 1024, fs, 'yaxis');
        titleName = sprintf('Spectrogram of Index %d', cnt+1);
        title(titleName);
        
        cnt = cnt + 1;
    end
end

%% spectrogram feature - 'MinThreshold'
% spectrogram(filteredX, 1024, 512, 1024, fs, 'yaxis', 'MinThreshold', -110);