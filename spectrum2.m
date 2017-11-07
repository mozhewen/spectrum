% spectrum (音频频谱分析)
% spectrum2.m
%   将生成的频谱保存为视频

clear; close all;
% 打开音频文件
[filename, pathname] = uigetfile(...
    {'*.wav;*.flac;*.mp3;*.mp4', '音频文件(*.wav;*.flac;*.mp3;*.mp4)'},...
    '选择音频文件');
if filename ~= 0
fprintf('解析音频文件...');
[y, fs] = audioread([pathname filename]);
fprintf('[完成]\n');
fprintf('正在生成视频...');
% 打开视频文件
[~, name, ~] = fileparts(filename);
v = VideoWriter([pathname name '.mp4'], 'MPEG-4');
v.FrameRate = 20;                   % 帧频20
open(v);
% 获得句柄
fig = figure('Position', [0 0 800 600]);
ax = gca;
ax.NextPlot = 'replacechildren';
% 主循环
L = size(y, 1);
N = round(fs*0.3);                  % fft点数2N+1
N1 = round(fs*0.12);                % 窗宽2*0.12s
pos = 1; j = 1;
rp = {'\b\b\b\b', '\b\b\b\b\b', '\b\b\b\b\b\b'};    % 更新进度
fprintf('[0%%]');
progress_pre = 0;
while pos <= L
    if ~isvalid(ax)
        break;
    else
        %begin{block-kernel1}
        pos_i = max(pos-N, 1); pos_f = min(pos+N, L);
        y1 = [zeros(pos_i-pos+N,1);...
              mean(y(pos_i:pos_f,:),2);...
              zeros(pos+N-pos_f,1)]...
             .*[zeros(N-N1,1); hann(2*N1+1); zeros(N-N1,1)]*2;  % 乘上Hanning窗函数
        y_hat = fft(y1)/(2*N+1);
        sA2 = cumsum(abs(y_hat).^2);
        A = zeros(97,1);
        for i = -48:48
            upper = floor(440*2.^((i+0.5)/12)*(2*N+1)/fs)+1;
            lower = floor(440*2.^((i-0.5)/12)*(2*N+1)/fs)+1;
            A(i+49) = sA2(upper)-sA2(lower);
        end
        A = sqrt(A)+0.0005;         % 加上偏移，使得条形图有一定初始高度
        bar(ax, A, 0.5,...
            'EdgeColor', 'none',...
            'FaceColor', [0 0.450980392156863 0.741176470588235]);
        hold(ax, 'on');
        b = bar(ax, -A, 0.5,...
            'EdgeColor', 'none',...
            'FaceColor', [0 0.450980392156863 0.741176470588235]);
        b.BaseLine.LineStyle = 'none';
        axis(ax, [1 97 -0.15 0.15]);
        title(ax, name, 'Interpreter', 'none');
        xlabel(ax, '$$ f/\mathrm{Hz} $$', 'Interpreter', 'latex');
        set(ax, 'XTick', (-4:4).*12+49);
        set(ax, 'Xticklabel', 440*2.^(-4:4));
        set(ax, 'XGrid', 'on'); set(ax, 'GridLineStyle', ':');
        set(ax, 'YTick', []);
        set(ax, 'YGrid', 'off');
        hold(ax, 'off');
        drawnow;
        %end{block-kernel1}
        writeVideo(v, getframe(fig));
    end
    pos = pos + 0.05*fs; j = j + 1; % 刷新周期0.05s
    % 显示进度
    progress = round(pos/L*100);
    if progress > progress_pre
        fprintf([rp{length(num2str(progress_pre))} '[%s%%]'], num2str(progress));
        progress_pre = progress;
    end
end
% 关闭视频文件
close(v);
fprintf([rp{length(num2str(progress_pre))} '[完成]\n']);
end
