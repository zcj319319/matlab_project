function ret = init_spi()
%SPI_FUCTIONS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    ClockSpeed = 1125000;
    ControlMode = 3;
    CPHA = 0;
    CPOL = 0;
    LSBFirst = 0;
    MasterMode = 1;
    SelPolarity = 0;
    TranBits = 8;
    INIT_CFG = struct('ControlMode',ControlMode, ...
                      'TranBits',TranBits, ...
                      'MasterMode',MasterMode, ...
                      'CPOL',CPOL, ...
                      'CPHA',CPHA, ...
                      'LSBFirst',LSBFirst, ...
                      'SelPolarity', SelPolarity ,...
                      'ClockSpeed',ClockSpeed);
    ret = calllib('lib','VSI_InitSPI',2,0,INIT_CFG);

end