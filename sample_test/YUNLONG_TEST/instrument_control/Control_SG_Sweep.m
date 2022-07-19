 %设置信号源地址
instrumentVISAAddress = 'TCPIP0::192.168.18.154::inst0::INSTR';
% 创建链接
instrObj = visa('keysight',instrumentVISAAddress);     
% 设置缓存                       
instrObj.InputBufferSize = 10e6;                                                       
instrObj.ByteOrder = 'littleEndian';

% 设置起始频率为Hz
Fre1 = 3e8;
% 设置终止频率为Hz
Fre2 = 5e8;
% 设置频率间隔为Hz
Step = 1e6;
% 设置间隔时间为s
Dwell = 1;
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
% 信号关
fprintf(instrObj,'OUTP:STAT OFF\n');
% 设置起始频率 
fprintf(instrObj,sprintf('FREQ:STAR %f HZ\n', Fre1));
% 设置终止频率 
fprintf(instrObj,sprintf('FREQ:STOP %f HZ\n', Fre2));
% 设置扫频方式为Linear
fprintf(instrObj,'SWE:FREQ:SPAC LIN\n');
% 设置扫频MODE为AUTO
fprintf(instrObj,'TRIGger1:FSW:SOUR AUTO\n');
fprintf(instrObj,'SOURce1:SWE:FREQ:MODE AUTO\n');
% 设置步进
fprintf(instrObj,sprintf('SWE:FREQ:STEP:LIN %f HZ\n', Step));
% 设置步进时间
fprintf(instrObj,sprintf('SWE:FREQ:DWEL %f S\n', Dwell));
% 设置幅度
fprintf(instrObj,sprintf('POW:POW %f DBM\n', Pow));
% 设置线损
fprintf(instrObj,sprintf('POW:LEV:IMM:OFFS %f DB\n', Loss));
% 信号开
fprintf(instrObj,'OUTP:STAT ON\n');
% Sweep关
% fprintf(instrObj,'FREQ:MODE CW\n');
% Sweep开
fprintf(instrObj,'FREQ:MODE SWE\n');
% 关闭链接
fclose(instrObj);
% 删除链接
delete(instrObj);
