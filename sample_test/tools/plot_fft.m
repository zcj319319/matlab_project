% 两个频率分别为15HZ 和 20HZ 的正弦信号
Fs=50;%采样频率50Hz
f1=15;
f2=20;
t = 0:1/Fs:10-1/Fs % 0-9.98s 一共500个点
x = (cos(2*pi*f1*t)) + sin(2*pi*f1*t)*1i;% + sin(2*pi*f2*t);%原始信号
N=length(x)% N=500
figure(1);
plot(t,x);
title('Original Signal');
xlabel('Time'); 
ylabel('Amplitude'); 
%直接使用fft
figure(2);
y0 = abs(fftshift(fft(x))); %快速傅里叶变换的幅值
%将横坐标转化，显示为频率f= n*(fs/N)
f = (0:N-1)*Fs/N - Fs/2;
plot(f,y0);
xlabel('Frequency'); 
ylabel('Amplitude');

%fftshift()调整0频位置
figure(3);
f1=(0:N-1)*Fs/N-Fs/2 ;%频率范围-25Hz-25Hz, 500个采样点
y1=abs(fftshift(fft(x)));
plot(f1,y1);
xlabel('Frequency'); 
ylabel('Amplitude'); 

figure(4)
f3=(N/2:N-1)*Fs/N-Fs/2 ;%频率范围0Hz-25Hz
y2=abs(fftshift(fft(x)));
y3=2*y2(N/2:N-1)/N;%幅值修正得到真实幅值
plot(f3,y3);
xlabel('Frequency'); 
ylabel('Amplitude');

