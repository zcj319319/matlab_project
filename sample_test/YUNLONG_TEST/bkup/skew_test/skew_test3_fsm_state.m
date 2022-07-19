cfg_tiskew_code(dec2hex(512),dec2hex(512),dec2hex(512),dec2hex(512));

spi_write(BASE_ADDR_CALIB_ALG, "0x3F3", "0xE" ); %tiskew_accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x3F6", "0xE" ); %tiskew_wait
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x1"); %tiskew_on

spi_read(BASE_ADDR_CALIB_ALG, "0x3F2")
spi_read(BASE_ADDR_CALIB_ALG, "0x3F2")
spi_read(BASE_ADDR_CALIB_ALG, "0x3F1")
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x0"); %tiskew_off


