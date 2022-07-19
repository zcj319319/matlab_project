% BASE_ADDR_CALIB_ALG = '0x10000';

% spi_read(BASE_ADDR_CALIB_ALG, "0x41") %dnc_mdac_weight1 part2 ch1
% spi_read(BASE_ADDR_CALIB_ALG, "0x40") %dnc_mdac_weight1 part1 ch1
% spi_read(BASE_ADDR_CALIB_ALG, "0x3F") %dnc_mdac_weight1 part0 ch1
% spi_read(BASE_ADDR_CALIB_ALG, "0x44") %dnc_mdac_weight1 part2 ch2
% spi_read(BASE_ADDR_CALIB_ALG, "0x43") %dnc_mdac_weight1 part1 ch2
% spi_read(BASE_ADDR_CALIB_ALG, "0x42") %dnc_mdac_weight1 part0 ch2
% spi_read(BASE_ADDR_CALIB_ALG, "0x47") %dnc_mdac_weight1 part2 ch3
% spi_read(BASE_ADDR_CALIB_ALG, "0x46") %dnc_mdac_weight1 part1 ch3
% spi_read(BASE_ADDR_CALIB_ALG, "0x45") %dnc_mdac_weight1 part0 ch3
%%
spi_write(BASE_ADDR_CALIB_ALG, "0x1b"   , "0x72" ); %dnc_opgain_vth 72
spi_write(BASE_ADDR_CALIB_ALG, "0x16"   , "0x14" ); %cfg_dnc_call_accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x19"   , "0x02" ); %dnc_cal_rounds_power2

spi_write(BASE_ADDR_CALIB_ALG, "0x17"   , "0xA" ); %cfg_dnc_opgain_accnum
spi_write(BASE_ADDR_CALIB_ALG, "0x18"   , "0xA" ); %cfg_dnc_osdac_search_accnum

spi_write(BASE_ADDR_CALIB_ALG, "0x13"   , "0x0" ); %cfg_dnc_opgain_search_en
spi_write(BASE_ADDR_CALIB_ALG, "0x14"   , "0x0" ); %cfg_dnc_osdac_search_en

spi_write(BASE_ADDR_CALIB_ALG, "0x38E"  , "0x1" ); %clr dnc error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x38E"  , "0x0" ); %clr dnc error done off

%%
spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x1" ); %dnc_en
if fsm_run==0
%%
while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x11");% wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x0" ); %dnc_en off


end
