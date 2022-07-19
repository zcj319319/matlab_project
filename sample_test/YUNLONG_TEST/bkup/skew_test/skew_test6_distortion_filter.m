cfg_tiskew_code(dec2hex(512),dec2hex(512),dec2hex(512),dec2hex(512));

spi_write(BASE_ADDR_CALIB_ALG, "0x3F3", "0x18" ); %tiskew_accnum_power2 18~24
spi_read(BASE_ADDR_CALIB_ALG, "0x3DF")
spi_write(BASE_ADDR_CALIB_ALG, "0x3F4", "0x0" ); %cal mode 0,1,2
spi_write(BASE_ADDR_CALIB_ALG, "0x3DF", "0x0" ); %distort filter on 0/off 1
spi_write(BASE_ADDR_CALIB_ALG, "0x3F6", "0xA" ); %tiskew_wait
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0", "0x1"); %tiskew_on

while (1)
    state = 0;
    state = hex2dec(spi_read(BASE_ADDR_CALIB_ALG, "0x3F1"));
    if (state == 1)
        break;
    else
        pause(0.1);
    end
end
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x0"); %tiskew_off

[skew_code0,skew_code1,skew_code2,skew_code3] = rd_tiskew_code;

skew_code0_dec = hex2dec(skew_code0);
skew_code1_dec = hex2dec(skew_code1);
skew_code2_dec = hex2dec(skew_code2);
skew_code3_dec = hex2dec(skew_code3);
skew_code0_dec_old = skew_code0_dec;
skew_code1_dec_old = skew_code1_dec;
skew_code2_dec_old = skew_code2_dec;
skew_code3_dec_old = skew_code3_dec;
%21A 21E 202 off
%21C 222 200 on

dump_mem_ddc_out;
memory_data_analyze;
