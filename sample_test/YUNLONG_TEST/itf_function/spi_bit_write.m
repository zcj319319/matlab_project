function write_state = spi_bit_write(base_addr, offset_addr, bit_range, val, need_readback)
%SPI_WRITE 此处显示有关此函数的摘要
%   此处显示详细说明
    if (nargin<5)
        need_readback=0;
    end
    
    range_start_end = sscanf(bit_range, '[%d:%d]');
    start_bit = range_start_end(1);
    end_bit = range_start_end(2);
    
    read_val = spi_read(base_addr, offset_addr);

    if (start_bit > end_bit)
        end_bit_tmp = end_bit;
        end_bit = start_bit;
        start_bit = end_bit_tmp;
    end
    
    read_val_dec = hex2dec(read_val(:)');
    msk_val1 = mod(bitshift(hex2dec('FFFFFFFF'), -start_bit), 2^32);
    msk_val2 = mod(bitshift(hex2dec('FFFFFFFF'), -(32 - end_bit)), 2^32);
    msk_val = bitxor(hex2dec('FFFFFFFF'), bitand(msk_val1, msk_val2));

    new_val = erase(val, "0x");
    new_val = erase(new_val, " ");
    new_val = erase(new_val, "_");
    val_to_overwrite = mod(hex2dec(new_val), 2^(end_bit - start_bit + 1));
    val_to_overwrite = bitshift(val_to_overwrite, start_bit);    
    new_val_write = dec2hex(bitor(bitand(read_val_dec, msk_val), val_to_overwrite));
    
    write_state = spi_write(base_addr, offset_addr, new_val_write, need_readback);
    
end

