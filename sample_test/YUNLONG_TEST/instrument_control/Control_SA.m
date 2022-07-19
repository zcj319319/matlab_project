 %设置信号源地址
instrumentVISAAddress = 'TCPIP0::192.168.18.146::inst0::INSTR';
% 创建链接
instrObj = visa('keysight',instrumentVISAAddress);     
% 设置缓存                       
instrObj.InputBufferSize = 10e6;                                                       
instrObj.ByteOrder = 'littleEndian';

% 所需控制频率为Hz
Fre = 3e8;
% 所需控制功率为dBm
Pow = 10;
% 连接线线损为dB
Loss = 0;
% 开启链接
fopen(instrObj);
% Display information about instrument
IDNString = query(instrObj,'*IDN?');%信息查询
fprintf('Connected to: %s\n',IDNString); 
%fprintf(instrObj,'SYSTem:PREset');
%fprintf(instrObj,'SYSTem:FPReset');
fprintf(instrObj,'*CLS;*wai');
% Reset信号源
fprintf(instrObj,'*RST');
% 调制关
fprintf(instrObj,'PULM:STAT OFF\n');
% 信号开
fprintf(instrObj,'OUTP:STAT ON\n');
% 设置频率 
fprintf(instrObj,sprintf('FREQ:CW %f HZ\n', Fre));
% 设置幅度
fprintf(instrObj,sprintf('POW:POW %f DBM\n', Pow));
% 设置线损
fprintf(instrObj,sprintf('POW:LEV:IMM:OFFS %f DB\n', Loss));
% 关闭链接
fclose(instrObj);
% 删除链接
delete(instrObj);
