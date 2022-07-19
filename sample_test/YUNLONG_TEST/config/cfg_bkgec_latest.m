% BASE_ADDR_CALIB_ALG = '0x10100';
% BASE_ADDR_CALIB_ALG = '0x11100';
% BASE_ADDR_CALIB_ALG = '0x14100';

spi_write(BASE_ADDR_CALIB_ALG, "0x473"   , "0x60" ); %bkgec coeff ideal part1
spi_write(BASE_ADDR_CALIB_ALG, "0x472"   , "0x00" ); %bkgec coeff ideal part0
spi_write(BASE_ADDR_CALIB_ALG, "0x443"   , "0x14" ); %accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x474"  , "0x1" ); %clr bkgec error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x474"  , "0x0" ); %clr bkgec error done off
%%
spi_write(BASE_ADDR_CALIB_ALG, "0x440"   , "0x01" ); %bkgec_en
if fsm_run==0
    
while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x441" );%rpt_bkgec_done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write(BASE_ADDR_CALIB_ALG, "0x440"   , "0x00" ); %bkgec_en off


end