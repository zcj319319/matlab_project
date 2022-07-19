spi_write(BASE_ADDR_CALIB_ALG, "0x56f", "0x01" ); %cfg_ti_distort_filter_bypass

spi_write(BASE_ADDR_CALIB_ALG, "0x553", "0x18" ); %tigain_accnum_power2

spi_write(BASE_ADDR_CALIB_ALG, "0x571"  , "0x1" ); %clr tigain error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x571"  , "0x0" ); %clr tigain error done off
spi_write(BASE_ADDR_CALIB_ALG, "0x554", "0x00" ); %tigain_cal_mode
spi_write(BASE_ADDR_CALIB_ALG, "0x557", "0x00" ); %round,must be 0 when mode=0
spi_write(BASE_ADDR_CALIB_ALG, "0x555", "0x1e" ); %cfg_tigain_filter_phase_dly

spi_write(BASE_ADDR_CALIB_ALG, "0x556", "0x08" ); %wait cycle power2

spi_write(BASE_ADDR_CALIB_ALG, "0x550"   , "0x01" ); %tigain_en

if fsm_run==0
    
while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x551");%wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write(BASE_ADDR_CALIB_ALG, "0x550" , "0x0" ); %tigain_off

end