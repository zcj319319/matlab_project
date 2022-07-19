spi_write(BASE_ADDR_CALIB_ALG, "0x1b"   , "0x3" ); %dnc_opgain_vth 3
spi_write(BASE_ADDR_CALIB_ALG, "0x16"   , "0xA" ); %cfg_dnc_call_accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x17"   , "0xA" ); %cfg_dnc_opgain_accnum
spi_write(BASE_ADDR_CALIB_ALG, "0x18"   , "0xA" ); %cfg_dnc_osdac_search_accnum
spi_write(BASE_ADDR_CALIB_ALG, "0x19"   , "0xA" ); %dnc_cal_rounds