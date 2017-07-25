% spectrum (音频频谱分析)
% refreshFig 函数
%   生成圆形频谱

function refreshFig(hObject, ~)
    y = hObject.UserData{1};
    L = size(y,1);
    ax = hObject.UserData{2};
    name = hObject.UserData{3};
    fs = hObject.SampleRate;
    pos = hObject.CurrentSample;
    N=round(fs*0.08);               % 窗宽2*0.08s，fft点数2N+1
    num=128;                        % 线条数num

    if ~isvalid(ax)
        stop(hObject);
    else
        ax.Parent.Color='white';
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
        plot(ax, A_x, A_y, 'Color', 'blue', 'LineWidth', 1.5);
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
    end
end
