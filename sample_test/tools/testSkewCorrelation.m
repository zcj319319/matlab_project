Fs=2.9*10^9;%采样频率50Hz
f1=500*10^6;
N=65536% N=500
t = 0:1/Fs:(N-1)/Fs % 0-9.98s 一共500个点
%x = (cos(2*pi*f1*t)) + sin(2*pi*f1*t)*1i;% + sin(2*pi*f2*t);%原始信号
x = (cos(2*pi*f1*t));

sample0=x(1:4:end);
sample1=x(2:4:end);
sample2=x(3:4:end);
sample3=x(4:4:end);

skewCorrelation(sample0,sample1,sample2)

sample0_1d = sample0(2:end);
sample0 = sample0(1:end - 1);
sample2 = sample2(1:end - 1);


skewCorrelation(sample0,sample2,sample0_1d)
