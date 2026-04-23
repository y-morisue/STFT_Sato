clear; close all; clc;

% 引数の入力
[audioSig, fs] = audioread('sig1.wav'); % wavファイル入力＆読み込み
windowLength = 2 ^ 12; % 窓長
shiftLength = windowLength / 2; % シフト長

%関数の実行
S = calcSTFT(audioSig, fs, windowLength, shiftLength);