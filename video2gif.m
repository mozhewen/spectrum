v=VideoReader('2U - David Guetta; Justin Bieber-1.mp4');
n = 1;
n_pre = 1;
while v.CurrentTime < 26
    pic = readFrame(v);
    pic = imresize(pic, 0.8);
    [A, map]=rgb2ind(pic, 256); 
    %if v.CurrentTime > 7
    if n == 1
        imwrite(A, map, 'out.gif', 'gif', 'LoopCount', Inf, 'DelayTime', 0.05);
    else
        imwrite(A, map, 'out.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
    n = n + 1;
    %end
    if n - n_pre > 10 * v.FrameRate
        fprintf('%f%%,\n', v.CurrentTime/v.Duration*100);
        n_pre = n;
    end
end
