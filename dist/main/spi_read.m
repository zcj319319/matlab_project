function [read_val] = spi_read(base_addr, offset_addr, read_length)
%SPI_WRITE 此处显示有关此函数的摘要
%   此处显示详细说明
    if (nargin<3)
        read_length=1;
    end

    new_base_addr = erase(base_addr,"0x");
	new_base_addr = erase(new_base_addr," ");
    new_base_addr = erase(new_base_addr,"_");
	new_offset_addr = erase(offset_addr,"0x");
    new_offset_addr = erase(new_offset_addr," ");
    new_offset_addr = erase(new_offset_addr,"_");
    base_addr_dec = hex2dec(new_base_addr);
    offset_addr_dec = hex2dec(new_offset_addr);
    addr_dec = base_addr_dec + offset_addr_dec;
    addr = dec2hex(addr_dec);
    [read_val] = read_spi_reg(addr, 20, 32, 3, read_length);
end

