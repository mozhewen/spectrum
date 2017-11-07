% spectrum (��ƵƵ�׷���)
% spectrum.m
%   ������
%   ��Ҫ�ļ�: refreshFig.m

clear; close all;
% ����Ƶ�ļ�
[filename, pathname] = uigetfile(...
    {'*.wav;*.flac;*.mp3;*.mp4', '��Ƶ�ļ�(*.wav;*.flac;*.mp3;*.mp4)'},...
    'ѡ����Ƶ�ļ�');
if filename ~= 0
fprintf('������Ƶ�ļ�...');
[y, fs] = audioread([pathname filename]);
fprintf('[���]\n');
fprintf('׼������...');
% ��þ��
figure('Position', [0 0 800 600]);
ax = gca;
ax.NextPlot = 'replacechildren';
% ��������
[~, name, ~] = fileparts(filename);
player = audioplayer(y, fs);
player.UserData = {y, ax, name};
player.TimerFcn = @refreshFig;
player.TimerPeriod = 0.05;          % ˢ������0.05s
fprintf('[���]\n');
fprintf('����"stop(player)"��رմ��ڽ�������. \n');
play(player);
end
