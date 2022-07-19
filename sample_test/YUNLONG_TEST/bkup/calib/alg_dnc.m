spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x0" ); %dnc_off
spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x1" ); %dnc_on
pause(0.5); 
spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x0" ); %dnc_off