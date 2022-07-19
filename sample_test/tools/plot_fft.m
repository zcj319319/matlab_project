% ����Ƶ�ʷֱ�Ϊ15HZ �� 20HZ �������ź�
Fs=50;%����Ƶ��50Hz
f1=15;
f2=20;
t = 0:1/Fs:10-1/Fs % 0-9.98s һ��500����
x = (cos(2*pi*f1*t)) + sin(2*pi*f1*t)*1i;% + sin(2*pi*f2*t);%ԭʼ�ź�
N=length(x)% N=500
figure(1);
plot(t,x);
title('Original Signal');
xlabel('Time'); 
ylabel('Amplitude'); 
%ֱ��ʹ��fft
figure(2);
y0 = abs(fftshift(fft(x))); %���ٸ���Ҷ�任�ķ�ֵ
%��������ת������ʾΪƵ��f= n*(fs/N)
f = (0:N-1)*Fs/N - Fs/2;
plot(f,y0);
xlabel('Frequency'); 
ylabel('Amplitude');

%fftshift()����0Ƶλ��
figure(3);
f1=(0:N-1)*Fs/N-Fs/2 ;%Ƶ�ʷ�Χ-25Hz-25Hz, 500��������
y1=abs(fftshift(fft(x)));
plot(f1,y1);
xlabel('Frequency'); 
ylabel('Amplitude'); 

figure(4)
f3=(N/2:N-1)*Fs/N-Fs/2 ;%Ƶ�ʷ�Χ0Hz-25Hz
y2=abs(fftshift(fft(x)));
y3=2*y2(N/2:N-1)/N;%��ֵ�����õ���ʵ��ֵ
plot(f3,y3);
xlabel('Frequency'); 
ylabel('Amplitude');

