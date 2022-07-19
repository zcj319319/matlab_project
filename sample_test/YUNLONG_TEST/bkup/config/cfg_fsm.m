spi_write(BASE_ADDR_CALIB_ALG, "0x002", "0xA" ); %alg wait part0
spi_write(BASE_ADDR_CALIB_ALG, "0x003", "0x0" ); %alg wait part1
spi_write(BASE_ADDR_CALIB_ALG, "0x009", "0x11" ); % dnc run once
spi_write(BASE_ADDR_CALIB_ALG, "0x00A", "0x00" ); % tios always on
spi_write(BASE_ADDR_CALIB_ALG, "0x00B", "0x00" ); % no first turn jump
