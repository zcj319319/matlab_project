
% 创建链接
instrObj = visa('keysight',instrumentVISAAddress);     
% 设置缓存                       
instrObj.InputBufferSize = 10e6;                                                       
instrObj.ByteOrder = 'littleEndian';

% 开启链接
fopen(instrObj);
% Display information about instrument
Instr.SigFreRead = str2double(query(instrObj,':FREQ?'));%信息查询
Instr.SigPowRead = str2double(query(instrObj,':POW?'));
% 关闭链接
fclose(instrObj);
% 删除链接
delete(instrObj);
