%% dnc
function calib = xihe_adc_test_dnc()
spi_write('0x10100', "0x13"   , "0x0" ); %cfg_dnc_opgain_search_en
spi_write('0x10100', "0x14"   , "0x0" ); %cfg_dnc_osdac_search_en



spi_write('0x10100', "0x10"   , "0x1" ); %dnc_en
pause(1); 
spi_write('0x10100', "0x10"   , "0x0" ); %dnc_en
for i_ch=1:4
    for j_w=1:8
        addr_l=hex2dec('3c')+(j_w-1)*3+(i_ch-1)*24;
        addr_m=addr_l+1;
        addr_h=addr_l+2;
xtemp=spi_read('0x10100', strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight1 part2 ch0
    calib.dnc_weight1(i_ch,j_w)=hex2dec(xtemp(4,:))*2^16;
xtemp=spi_read('0x10100', strcat('0x',dec2hex(addr_m))); %dnc_mdac_weight1 part1 ch0
    calib.dnc_weight1(i_ch,j_w)=calib.dnc_weight1(i_ch,j_w)+hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read('0x10100', strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight1 part0 ch0
    calib.dnc_weight1(i_ch,j_w)=(calib.dnc_weight1(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
% mdac weight2
for i_ch=1:4
    for j_w=1:8
        addr_l=hex2dec('9c')+(j_w-1)*2+(i_ch-1)*16;
        addr_h=addr_l+1;
xtemp=spi_read('0x10100', strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
    calib.dnc_weight2(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read('0x10100', strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
    calib.dnc_weight2(i_ch,j_w)=(calib.dnc_weight2(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
