
x=sample0;
%plot(x);
N=length(x)% N=500

f3=(N/2:N-1)*Fs/N-Fs/2 ;%Ƶ�ʷ�Χ0Hz-25Hz
y2=abs(fftshift(fft(x)));
y3=2*y2(N/2:N-1)/N;%��ֵ�����õ���ʵ��ֵ
plot(f3,y3);
xlabel('Frequency'); 
ylabel('Amplitude');