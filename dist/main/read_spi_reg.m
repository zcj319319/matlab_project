function [val,ret] = read_spi_reg(addr, addr_bits, val_bits, idle_bits, read_length)
%SPI_FUCTIONS 此处显示有关此函数的摘要
%   此处显示详细说明
    if (nargin<5)
        read_length=1;
    end

    addr_bytes = uint8(ceil(addr_bits/8));
    idle_bytes = uint8(ceil(idle_bits/8));
    idle_addr_combine = uint8((mod((idle_bits), 8) ~= 0));
    read_addr_combine = uint8((mod((idle_bits + addr_bits), 8) ~= 0));
    write_bytes = uint8(ceil((addr_bits + idle_bits + 1)/8));
    addr_spi = zeros(1,addr_bytes);
    if (idle_bytes == 0) 
        idle_spi = zeros(1,1);
        idle_bytes = 1;
    else
        idle_spi = zeros(1,idle_bytes);
    end
    write_bytes_spi = zeros(1,write_bytes);
    addr_dec = hex2dec(addr);

    for i=1:addr_bytes
        idx = addr_bytes - i + 1;
        addr_spi(idx) = mod(addr_dec, 256);
        addr_dec = floor(addr_dec/256);
    end
    carry = 0;
    for i=1:write_bytes
        idx = write_bytes - i + 1; %max to 1
        if (i <= idle_bytes)
            write_bytes_spi(idx) = idle_spi(idle_bytes - i + 1);
            if (i == idle_bytes && idle_addr_combine == 1)
                shift_val = mod((idle_bits), 8);
                write_bytes_spi(idx) = write_bytes_spi(idx) + bitshift(addr_spi(addr_bytes), shift_val, 'uint8');
                carry = bitshift(addr_spi(addr_bytes),  -(8 - shift_val), 'uint8');
            end
        elseif (i <= write_bytes)
            shift_val = mod((idle_bits), 8);
            write_bytes_spi(idx) = bitshift(addr_spi(addr_bytes - (i - idle_bytes - 1) - idle_addr_combine), shift_val, 'uint8') + carry;
            carry = bitshift(addr_spi(addr_bytes - (i - idle_bytes - 1) - idle_addr_combine), -(8 - shift_val), 'uint8');
            if (i == write_bytes && read_addr_combine == 1)
                shift_val = mod((idle_bits + addr_bits), 8);
                write_bytes_spi(idx) =  write_bytes_spi(idx) + bitshift(1, shift_val, 'uint8');
            end
        end
    end
        
    write_bytes_spi = uint8(write_bytes_spi);    
    
    read_bytes = ceil(val_bits*read_length/8);
    read_bytes_spi = uint8(zeros(1,read_bytes));
    [a,b,ret] = calllib('lib','VSI_WriteReadBytes',2,0,0, write_bytes_spi,write_bytes, read_bytes_spi,read_bytes);
    val = dec2hex([ret],2);
end
