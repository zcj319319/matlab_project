spi_read(BASE_ADDR_CALIB_ALG, "0x3F1")
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x1"); %tiskew_on
pause(0.1);
spi_read(BASE_ADDR_CALIB_ALG, "0x3F1")
pause(7);
spi_read(BASE_ADDR_CALIB_ALG, "0x3F1")
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x0"); %tiskew_off
spi_read(BASE_ADDR_CALIB_ALG, "0x3F1")

