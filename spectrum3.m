% spectrum (��ƵƵ�׷���)
% spectrum3.m
%   �����ɵ�Բ��Ƶ�ױ���Ϊ��Ƶ

clear; close all;
% ����Ƶ�ļ�
[filename, pathname] = uigetfile(...
    {'*.wav;*.flac;*.mp3;*.mp4', '��Ƶ�ļ�(*.wav;*.flac;*.mp3;*.mp4)'},...
    'ѡ����Ƶ�ļ�');
if filename ~= 0
fprintf('������Ƶ�ļ�...');
[y, fs] = audioread([pathname filename]);
fprintf('[���]\n');
fprintf('����������Ƶ...');
% ����Ƶ�ļ�
[~, name, ~] = fileparts(filename);
v = VideoWriter([pathname name '.mp4'], 'MPEG-4');
v.FrameRate = 20;                   % ֡Ƶ20
open(v);
% ��þ��
fig = figure('Position', [0 0 800 600]);
fig.Color = 'white';
ax = gca;
ax.NextPlot = 'replacechildren';
% ��ѭ��
L = size(y, 1);
N=round(fs*0.08);                   % ����2*0.08s��fft����2N+1
num=128;                            % ������num
pos = 1; j = 1;
rp = {'\b\b\b\b', '\b\b\b\b\b', '\b\b\b\b\b\b'};    % ���½���
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
             .*hann(2*N+1)*2;       % ����Hanning������
        y_hat = fft(y1)/(2*N+1);
        vol = 0.3*std(y1);
        lower = round(20*(2*N+1)/fs)+1;
        upper = round(2000*(2*N+1)/fs)+1;
        delta = ceil((upper-lower)/num);
        upper = lower+num*delta-1;
        A = sum(reshape(abs(y_hat(lower:upper)).^2, [delta num]), 1);
        A = 2.5*sqrt(A)+0.005;      %  ����ƫ�ƣ�ʹ������ͼ��һ����ʼ�߶�
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
    pos = pos + 0.05*fs; j = j + 1; % ˢ������0.05s
    % ��ʾ����
    progress = round(pos/L*100);
    if progress > progress_pre
        fprintf([rp{length(num2str(progress_pre))} '[%s%%]'], num2str(progress));
        progress_pre = progress;
    end
end
% �ر���Ƶ�ļ�
close(v);
fprintf([rp{length(num2str(progress_pre))} '[���]\n']);
end
