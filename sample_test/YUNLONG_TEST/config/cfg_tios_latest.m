
% BASE_ADDR_CALIB_ALG = '0x10100';

spi_write(BASE_ADDR_CALIB_ALG, "0x523", "0x00" ); %cfg_tios_refch_sel 0 no ref;1~4: refch0~3
spi_write(BASE_ADDR_CALIB_ALG, "0x524", "0x16" ); %cfg_tios_accnum_power2

spi_write(BASE_ADDR_CALIB_ALG, "0x53E"  , "0x1" ); %clr tios error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x53E"  , "0x0" ); %clr tios error done off

spi_write(BASE_ADDR_CALIB_ALG, "0x520"   , "0x01" ); %tios_en

if fsm_run==0
    
while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x522");%wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end

spi_write(BASE_ADDR_CALIB_ALG, "0x520" , "0x0" ); %tios_off

end