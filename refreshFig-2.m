% spectrum (��ƵƵ�׷���)
% refreshFig ����
%   �������ܹ���Ϊ׼ȷ��׽������ʼʱ�䣨ʱ��ֱ�ã�����Ƶ��ֱ�ϲ����������

function refreshFig(hObject, ~)
    y = hObject.UserData{1};
    L = size(y,1);
    ax = hObject.UserData{2};
    name = hObject.UserData{3};
    fs = hObject.SampleRate;
    pos = hObject.CurrentSample;
    N=round(fs*0.75);               % ����0.75s��fft����N

    if ~isvalid(ax)
        stop(hObject);
    else
        %begin{block-kernel2}
        pos_i = max(pos-N+1, 1); pos_f = min(pos, L);
        y1 = [zeros(pos_i-pos+N-1,1);...
              mean(y(pos_i:pos_f,:),2);...
              zeros(pos-pos_f,1)]...
             .*exp(((-N+1):0)'/N*3)*3;      % ����ָ��˥��������
             %.*(1+cos(((-N+1):0)'/N*pi));  % ����Hanning������
        y_hat = fft(y1)/N;
        sA2 = cumsum(abs(y_hat).^2);
        A = zeros(97,1);
        for i = -48:48
            upper = floor(440*2.^((i+0.5)/12)*N/fs)+1;
            lower = floor(440*2.^((i-0.5)/12)*N/fs)+1;
            A(i+49) = sA2(upper)-sA2(lower);
        end
        A = sqrt(A)+0.0005;         % ����ƫ�ƣ�ʹ������ͼ��һ����ʼ�߶�
        bar(ax, A, 0.5, 'EdgeColor', 'none');
        hold(ax, 'on');
        b = bar(ax, -A, 0.5, 'EdgeColor', 'none');
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
        %end{block-kernel2}
    end
end
