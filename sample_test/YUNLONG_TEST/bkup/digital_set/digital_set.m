spi_write(BASE_ADDR_ANALOG,    "0x17E"  , "0x0" );
spi_write(BASE_ADDR_ANALOG,    "0xF0E"  , "0x0" );
spi_write(BASE_ADDR_TOP,       "0xF0E"  , "0x40");
spi_write(BASE_ADDR_TOP,       "0xF0E"  , "0xF0");
spi_write(BASE_ADDR_ANALOG,    "0x17E"  , "0xFF");
spi_write(BASE_ADDR_ANALOG,    "0xF0E"  , "0x07");
spi_write(BASE_ADDR_CALIB_ALG, "0x1b"   , "0x3" );
spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x1" );
pause(0.5); 
spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x0" );