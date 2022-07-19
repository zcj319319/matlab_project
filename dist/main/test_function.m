bit_range = '[5:0]';

range_start_end = sscanf(bit_range, '[%d:%d]');
start_bit = range_start_end(1);
end_bit = range_start_end(2);

if (start_bit > end_bit)
    end_bit_tmp = end_bit;
    end_bit = start_bit;
    start_bit = end_bit_tmp;
end

read_val = spi_read('0', '0');



new_val_write = bitor(bitand(read_val_dec, msk_val), val_to_overwrite);


        
        
        
        
    