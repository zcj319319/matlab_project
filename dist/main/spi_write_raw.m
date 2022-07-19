function write_state = spi_write_raw(offset_addr, val)
%SPI_WRITE 此处显示有关此函数的摘要
%   此处显示详细说明
	new_offset_addr = erase(offset_addr,"0x");
    new_offset_addr = erase(new_offset_addr," ");
    new_offset_addr = erase(new_offset_addr,"_");
	new_val = erase(val, "0x");
    new_val = erase(new_val, " ");
    new_val = erase(new_val, "_");
    offset_addr_dec = hex2dec(new_offset_addr);
    addr_dec = offset_addr_dec;
    addr = dec2hex(addr_dec);
    write_state = write_spi_reg(addr, new_val, 20, 32, 3);

end