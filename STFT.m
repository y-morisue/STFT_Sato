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

% パワースペクトログラムの導出
S = win .* S; % 窓かけ
S = fft(S); % DFT
S = 10 * log10(abs(S) .^ 2); % パワースペクトログラム

% 時間軸と周波数軸の作成（各軸の値を成分数で分割）
timeAxis = linspace(0, signalLength / fs, numFlames); % 合計秒数をフレーム数個に分割
freqAxis = linspace(0, fs, windowLength); % 周波数の範囲を窓長個に分割

% パワースペクトログラムのグラフ表示
figure;
imagesc(timeAxis, freqAxis, S); % 横軸に時間、縦軸に周波数、色は強さ
axis xy; % y軸の向きを反転(原点の位置を左上から左下に変更)
xlabel('Time [s]');
ylabel('Frequency [Hz]');
title('Power Spectrogram');
set(gca, "FontSize", 16);
ylim([0, fs / 2]); % そのまま表示すると上下対象なので下半分だけ表示
cb = colorbar; %　色と値の対応を表示
cb.Label.String = 'Gain [dB]'; % カラーバーが何の値かのラベルを表示