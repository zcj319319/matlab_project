function [status] = cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3)
    regMap;
    skew0_part1 = dec2hex(floor(hex2dec(skew_code0)/256));
    skew0_part0 = dec2hex(mod(hex2dec(skew_code0),256));
    skew1_part1 = dec2hex(floor(hex2dec(skew_code1)/256));
    skew1_part0 = dec2hex(mod(hex2dec(skew_code1),256));
    skew2_part1 = dec2hex(floor(hex2dec(skew_code2)/256));
    skew2_part0 = dec2hex(mod(hex2dec(skew_code2),256));
    skew3_part1 = dec2hex(floor(hex2dec(skew_code3)/256));
    skew3_part0 = dec2hex(mod(hex2dec(skew_code3),256));

    spi_write(BASE_ADDR_CALIB_ALG, "0x40A", '0');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40B", '0');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40C", '0');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40D", '0');
    
    spi_write(BASE_ADDR_CALIB_ALG, "0x402", skew0_part0);
    spi_write(BASE_ADDR_CALIB_ALG, "0x403", skew0_part1);
    spi_write(BASE_ADDR_CALIB_ALG, "0x404", skew1_part0);
    spi_write(BASE_ADDR_CALIB_ALG, "0x405", skew1_part1);
    spi_write(BASE_ADDR_CALIB_ALG, "0x406", skew2_part0);
    spi_write(BASE_ADDR_CALIB_ALG, "0x407", skew2_part1);
    spi_write(BASE_ADDR_CALIB_ALG, "0x408", skew3_part0);
    spi_write(BASE_ADDR_CALIB_ALG, "0x409", skew3_part1);
    
    spi_write(BASE_ADDR_CALIB_ALG, "0x40A", '1');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40B", '1');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40C", '1');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40D", '1');

    spi_write(BASE_ADDR_CALIB_ALG, "0x40A", '0');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40B", '0');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40C", '0');
    spi_write(BASE_ADDR_CALIB_ALG, "0x40D", '0');
    
    status = 0;
end