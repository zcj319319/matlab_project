function [read_val] = spi_read_raw(offset_addr)
%SPI_WRITE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
	new_offset_addr = erase(offset_addr,"0x");
    new_offset_addr = erase(new_offset_addr," ");
    new_offset_addr = erase(new_offset_addr,"_");
    offset_addr_dec = hex2dec(new_offset_addr);
    addr_dec = offset_addr_dec;
    addr = dec2hex(addr_dec);
    [read_val] = read_spi_reg(addr, 20, 32, 3);
end