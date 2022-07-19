[skew_code0,skew_code1,skew_code2,skew_code3] = rd_tiskew_code;

skew_code0_dec = hex2dec(skew_code0);
skew_code1_dec = hex2dec(skew_code1);
skew_code2_dec = hex2dec(skew_code2);
skew_code3_dec = hex2dec(skew_code3);
skew_code0_dec_old = skew_code0_dec;
skew_code1_dec_old = skew_code1_dec;
skew_code2_dec_old = skew_code2_dec;
skew_code3_dec_old = skew_code3_dec;


cfg_tiskew_code(dec2hex(skew_code0_dec_old),dec2hex(skew_code1_dec_old - 200),dec2hex(skew_code2_dec_old + 200),dec2hex(skew_code3_dec_old + 200));
%394, 530, 432
%193, 730, 632
 spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x1"); %tiskew_on
 pause(0.1);
 spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x0"); %tiskew_off
 spi_read(BASE_ADDR_CALIB_ALG, "0x3F0")
 
 [skew_code0,skew_code1,skew_code2,skew_code3] = rd_tiskew_code;
 
skew_code0_dec = hex2dec(skew_code0);
skew_code1_dec = hex2dec(skew_code1);
skew_code2_dec = hex2dec(skew_code2);
skew_code3_dec = hex2dec(skew_code3);
%632, 720, 194
