spi_write(BASE_ADDR_CALIB_ALG, "0x3F3", "0x18" ); %tiskew_accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x3F7", "0x09" ); %tiskew_cal_rounds_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x3F8", "0x02" ); %cfg_tiskew_code_step
fs = 3000.0;
fin = 840.0;
direct2 = (sign(sin(2*pi*fin/fs))*-1+1)/2;
direct1 = (sign(sin(2*pi*2*fin/fs))*-1+1)/2;
direct0 = (sign(sin(2*pi*fin/fs))*-1+1)/2;
direct = floor(direct2*4+direct1*2+direct0);
direct_hex = dec2hex(direct);
spi_write(BASE_ADDR_CALIB_ALG, "0x3f9",direct_hex);