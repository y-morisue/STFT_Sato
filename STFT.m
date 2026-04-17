clear; close all; clc;

% wavファイル読み込み
[audioSig, fs] = audioread("sig1.wav"); %このコマンドでsigに入れると基本縦行列
signalLength = length(audioSig); % 信号長確保

% 各種パラメータを定義
windowLength = 2 ^ 12; % 窓の幅(2の乗数だと動作が早い)
shiftLength = windowLength / 2; % シフトする幅

% ゼロパディング
prepaddedSig = padarray(audioSig, shiftLength, 0, "pre"); % 前側に0を必要なだけ追加
paddedSig = padarray(prepaddedSig, windowLength - 1, 0, "post"); % 後ろ側に0を必要なだけ追加

% 信号分割処理
numFlames = ceil((windowLength / 2 + signalLength) / shiftLength); % シフトする回数(ceilで切り上げ)
win = hann(windowLength); % ハン窓作成
S = zeros(windowLength, numFlames); 
for i = 1 : numFlames % 1~numFlamsまで繰り返し
    startIndex = 1 + (i-1) * shiftLength; % 切り取る範囲のはじめ
    endIndex = startIndex + windowLength - 1; % 切り取る範囲の終わり
    S(:, i) = paddedSig(startIndex : endIndex); % i列目のすべての行に代入 
end

% STFT
winS = win .* S; % 窓かけ
spect = fft(winS); % DFT
absSpect = abs(spect); % 各要素の絶対値
pwS = absSpect .^ 2; % パワースペクトログラムの計算
logPwS = 10 * log10(pwS); % 対数

% パワースペクトログラムのグラフ表示
% fugure;
% imagesc(logPwS, )