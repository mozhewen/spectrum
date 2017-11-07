% spectrum (音频频谱分析)
% spectrum3.m
%   将生成的圆形频谱保存为视频

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
fig.Color = 'white';
ax = gca;
ax.NextPlot = 'replacechildren';
% 主循环
L = size(y, 1);
N=round(fs*0.08);                   % 窗宽2*0.08s，fft点数2N+1
num=128;                            % 线条数num
pos = 1; j = 1;
rp = {'\b\b\b\b', '\b\b\b\b\b', '\b\b\b\b\b\b'};    % 更新进度
fprintf('[0%%]');
progress_pre = 0;
while pos <= L
    if ~isvalid(ax)
        break;
    else
        %begin{block-kernel3}
        pos_i = max(pos-N, 1); pos_f = min(pos+N, L);
        y1 = [zeros(pos_i-pos+N,1);...
              mean(y(pos_i:pos_f,:),2);...
              zeros(pos+N-pos_f,1)]...
             .*hann(2*N+1)*2;       % 乘上Hanning窗函数
        y_hat = fft(y1)/(2*N+1);
        vol = 0.3*std(y1);
        lower = round(20*(2*N+1)/fs)+1;
        upper = round(2000*(2*N+1)/fs)+1;
        delta = ceil((upper-lower)/num);
        upper = lower+num*delta-1;
        A = sum(reshape(abs(y_hat(lower:upper)).^2, [delta num]), 1);
        A = 2.5*sqrt(A)+0.005;      %  加上偏移，使得条形图有一定初始高度
        phase = pi/2-pos/fs/60*2*pi;
        A_x = [(1+vol+A).*cos((0:num-1)/num*2*pi+phase);...
               (1+vol-A).*cos((0:num-1)/num*2*pi+phase)];
        A_y = [(1+vol+A).*sin((0:num-1)/num*2*pi+phase);...
               (1+vol-A).*sin((0:num-1)/num*2*pi+phase)];
        plot(ax, A_x, A_y,...
            'Color', [0 0.450980392156863 0.741176470588235],...
            'LineWidth', 2);
        axis(ax, [-1.5 1.5 -1.5 1.5]);
        axis(ax, 'square');
        axis(ax, 'off');
        set(ax, 'Clipping', 'off');
        text(ax, 0, 0, name,...
            'Interpreter','none',...
            'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'middle',...
            'FontSize', 12,...
            'FontWeight', 'bold');
        set(ax, 'XTick', []); set(ax, 'YTick', []);
        drawnow;
        %end{block-kernel3}
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
