function ret = scan_device(init)
%SPI_FUCTIONS 此处显示有关此函数的摘要
%   此处显示详细说明
    ret = calllib('lib','VSI_ScanDevice',init);

end
