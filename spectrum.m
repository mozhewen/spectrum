% spectrum (音频频谱分析)
% spectrum.m
%   主程序
%   需要文件: refreshFig.m

clear; close all;
% 打开音频文件
[filename, pathname] = uigetfile(...
    {'*.wav;*.flac;*.mp3;*.mp4', '音频文件(*.wav;*.flac;*.mp3;*.mp4)'},...
    '选择音频文件');
if filename ~= 0
fprintf('解析音频文件...');
[y, fs] = audioread([pathname filename]);
fprintf('[完成]\n');
fprintf('准备播放...');
% 获得句柄
figure('Position', [0 0 800 600]);
ax = gca;
ax.NextPlot = 'replacechildren';
% 播放音乐
[~, name, ~] = fileparts(filename);
player = audioplayer(y, fs);
player.UserData = {y, ax, name};
player.TimerFcn = @refreshFig;
player.TimerPeriod = 0.05;          % 刷新周期0.05s
fprintf('[完成]\n');
fprintf('输入"stop(player)"或关闭窗口结束播放. \n');
play(player);
end
