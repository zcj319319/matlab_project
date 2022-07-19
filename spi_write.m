function write_state = spi_write(base_addr, offset_addr, val, need_readback)
%SPI_WRITE 此处显示有关此函数的摘要
%   此处显示详细说明
    if (nargin<4)
        need_readback=0;
    end
    
    new_base_addr = erase(base_addr,"0x");
	new_base_addr = erase(new_base_addr," ");
    new_base_addr = erase(new_base_addr,"_");
	new_offset_addr = erase(offset_addr,"0x");
    new_offset_addr = erase(new_offset_addr," ");
    new_offset_addr = erase(new_offset_addr,"_");
	new_val = erase(val, "0x");
    new_val = erase(new_val, " ");
     new_val = erase(new_val, "_");
    base_addr_dec = hex2dec(new_base_addr);
    offset_addr_dec = hex2dec(new_offset_addr);
    addr_dec = base_addr_dec + offset_addr_dec;
    addr = dec2hex(addr_dec);
    write_state = write_spi_reg(addr, new_val, 20, 32, 3);
    
    if (need_readback == 1)
        if (val == read_spi_reg(addr, 20, 32, 3))
            write_state = 1;
            return;
        end
    end
end

