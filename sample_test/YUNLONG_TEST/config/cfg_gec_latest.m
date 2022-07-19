% BASE_ADDR_CALIB_ALG = '0x10100';
% BASE_ADDR_CALIB_ALG = '0x11100';
% BASE_ADDR_CALIB_ALG = '0x14100';

spi_write(BASE_ADDR_CALIB_ALG, "0x403", "0x16" ); %cfg_gec_accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x41D"  , "0x1" ); %clr gec error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x41D"  , "0x0" ); %clr gec error done off
%%
spi_write(BASE_ADDR_CALIB_ALG, "0x400", "0x1" ); %ctrl_gec_en

if fsm_run==0
while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x401"); %done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);        
    end
end

spi_write(BASE_ADDR_CALIB_ALG, "0x400", "0x0" ); %ctrl_gec_en off

end