function ret = write_spi_reg(addr, val, addr_bits, val_bits, idle_bits)
%SPI_FUCTIONS 此处显示有关此函数的摘要
%   此处显示详细说明
    addr_bytes = uint8(ceil(addr_bits/8));
    val_bytes = uint8(ceil(val_bits/8));
    idle_bytes = uint8(ceil(idle_bits/8));
    val_idle_bytes = uint8(ceil((val_bits + idle_bits)/8));
    val_idle_combine = uint8((mod((val_bits), 8) ~= 0));
    idle_addr_combine = uint8((mod((val_bits + idle_bits), 8) ~= 0));
    write_bytes = uint8(ceil((addr_bits + val_bits + idle_bits + 1)/8));
    addr_spi = zeros(1,addr_bytes);
    val_spi = zeros(1,val_bytes);
    if (idle_bytes == 0) 
        idle_spi = zeros(1,1);
        idle_bytes = 1;
    else
        idle_spi = zeros(1,idle_bytes);
    end
    write_bytes_spi = zeros(1,write_bytes);
    addr_dec = hex2dec(addr);
    val_dec = hex2dec(val);
    
    for i=1:val_bytes
        idx = val_bytes - i + 1;
        val_spi(idx) = mod(val_dec, 256);
        val_dec = floor(val_dec/256);
    end
    
    for i=1:addr_bytes
        idx = addr_bytes - i + 1;
        addr_spi(idx) = mod(addr_dec, 256);
        addr_dec = floor(addr_dec/256);
    end
    carry = 0;
    for i=1:write_bytes
        idx = write_bytes - i + 1; %max to 1
        if (i <= val_bytes)
            write_bytes_spi(idx) = val_spi(val_bytes - i + 1);
            if (i == val_bytes && val_idle_combine == 1)
                shift_val = mod(val_bits, 8);
                write_bytes_spi(idx) = val_spi(1) + bitshift(idle_spi(idle_bytes), shift_val);
                carry = bitshift(idle_spi(idle_bytes), -(8 - shift_val), 'uint8');
            end
        elseif (i <= val_idle_bytes)
            shift_val = mod(val_bits, 8);
            write_bytes_spi(idx) = bitshift(idle_spi(idle_bytes - (i - val_bytes - 1) - val_idle_combine), shift_val) + carry;
            carry = bitshift(idle_spi(idle_bytes - (i - val_bytes - 1) - val_idle_combine), -(8 - shift_val), 'uint8');
            if (i == val_idle_bytes && idle_addr_combine == 1)
                shift_val = mod((val_bits + idle_bits), 8);
                write_bytes_spi(idx) = write_bytes_spi(idx) + bitshift(addr_spi(addr_bytes), shift_val, 'uint8');
                carry = bitshift(addr_spi(addr_bytes), -(8 - shift_val), 'uint8');
            end
        elseif (i <= write_bytes)
            shift_val = mod((val_bits + idle_bits), 8);
            write_bytes_spi(idx) = bitshift(addr_spi(addr_bytes - (i - val_idle_bytes - 1) - idle_addr_combine), shift_val, 'uint8') + carry;
            carry = bitshift(addr_spi(addr_bytes - (i - val_idle_bytes - 1) - idle_addr_combine), -(8 - shift_val), 'uint8');
        end
    end
        
    write_bytes_spi = uint8(write_bytes_spi);
    ret = calllib('lib','VSI_WriteBytes',2,0,0, write_bytes_spi, write_bytes);

end
