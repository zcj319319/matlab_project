function [skew_code0,skew_code1,skew_code2,skew_code3] = rd_tiskew_code()
    regMap;
    skew0_part0 = spi_read(BASE_ADDR_CALIB_ALG, "0x3FA");
    skew0_part1 = spi_read(BASE_ADDR_CALIB_ALG, "0x3FB");
    skew_code0 = [skew0_part1, skew0_part0];
    skew1_part0 = spi_read(BASE_ADDR_CALIB_ALG, "0x3FC");
    skew1_part1 = spi_read(BASE_ADDR_CALIB_ALG, "0x3FD");
    skew_code1 = [skew1_part1, skew1_part0];
    skew2_part0 = spi_read(BASE_ADDR_CALIB_ALG, "0x3FE");
    skew2_part1 = spi_read(BASE_ADDR_CALIB_ALG, "0x3FF");
    skew_code2 = [skew2_part1, skew2_part0];
    skew3_part0 = spi_read(BASE_ADDR_CALIB_ALG, "0x400");
    skew3_part1 = spi_read(BASE_ADDR_CALIB_ALG, "0x401");
    skew_code3 = [skew3_part1, skew3_part0];

end