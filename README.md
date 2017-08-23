# spectrum
MATLAB scripts used to plot audio spectrum

## Description

+ **spectrum.m**

    Play audio from file and draw the spectrum in real time. The pattern of the spectrum depends on which refreshFig function is used. To change the refreshFig function, simply replace refreshFig.m with refreshFig-2.m or refreshFig-3.m. 

+ **refreshFig.m**

    This function is called from spectrum.m at regular intervals. It is used to compute the short-time Fourier transform (STFT) of the audio sampled data with a Hann window, and plot the spectrum in a bar graph. Each bar in the graph is corresponding to a pitch in 12 equal temperament tuned relative to the standard pitch (440Hz) . 
    ![demo1](demo/2U%20-%20David%20Guetta;%20Justin%20Bieber.gif?raw=true)

+ **refreshFig-2.m**

    Similar to refreshFig.m, but with different(exponential) window function. 

+ **refreshFig-3.m**

    Similar to refreshFig.m, but it draws a circular spectrum and does not use logarithmic scale for frequency. 
    ![demo2](demo/Despacito%20(Remix).gif?raw=true)

+ **spectrum2.m**

    Save the spectrum generated by refreshFig.m as a video file. 

+ **spectrum3.m**

    Save the spectrum generated by refreshFig-3.m as a video file. 

## Usage

1. Start MATLAB. Change the Current Folder to the directory where you put the .m files. 
2. Enter `spectrum`, `spectrum2`, or `spectrum3` (with no parameter) in the Command Window to run the scripts. 
3. To mix the soundless video file generated by MATLAB with the original audio file, [FFmpeg](https://ffmpeg.org) is recommended. 

## Notes

1. Code is tested in MATLAB R2016a. 
2. All .m files use GB2312 encoding and that's why Chinese characters are garbled in UTF-8 here. 
