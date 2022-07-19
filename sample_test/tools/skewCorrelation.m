function [correlation] = skewCorrelation(sample0,sample1,sample2)
%RELA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
length_sample0 = length(sample0);
length_sample1 = length(sample1);
length_sample2 = length(sample2);

if (length_sample0 ~= length_sample1 && length_sample1 ~= length_sample2)
    display('Sample length is not equal!');
    return;
end

correlation = sum(sample0.*sample1 - sample1.*sample2);

end

