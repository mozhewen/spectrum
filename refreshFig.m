% spectrum (音频频谱分析)
% refreshFig 函数

function refreshFig(hObject, ~)
    y = hObject.UserData{1};
    L = size(y,1);
    ax = hObject.UserData{2};
    name = hObject.UserData{3};
    fs = hObject.SampleRate;
    pos = hObject.CurrentSample;
    N = round(fs*0.3);              % fft点数2N+1
    N1 = round(fs*0.12);            % 窗宽2*0.12s

    if ~isvalid(ax)
        stop(hObject);
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
        bar(ax, A, 0.5, 'EdgeColor', 'none');
        hold(ax, 'on');
        b = bar(ax, -A, 0.5, 'EdgeColor', 'none');
        b.BaseLine.LineStyle = 'none';
        axis(ax, [1 97 -0.125 0.125]);
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
    end
end
