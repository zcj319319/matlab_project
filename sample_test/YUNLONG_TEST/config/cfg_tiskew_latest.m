spi_write(BASE_ADDR_CALIB_ALG, "0x583", "0x18" ); %tiskew_accnum_power2
spi_write(BASE_ADDR_CALIB_ALG, "0x587", "0x09" ); %tiskew_cal_rounds_power2

spi_write(BASE_ADDR_CALIB_ALG, "0x588", "0x01" ); %cfg_tiskew_code_step

spi_write(BASE_ADDR_CALIB_ALG, "0x58A", "0x01" ); %tiskew_auto_direction_en
spi_write(BASE_ADDR_CALIB_ALG, "0x58B", "0x08" ); %tiskew reverse count
spi_write(BASE_ADDR_CALIB_ALG, "0x584", "0x01" ); %tiskew_cal mode
spi_write(BASE_ADDR_CALIB_ALG, "0x585", "0x1e" ); %cfg_tiskew_filter_phase_dly

spi_write(BASE_ADDR_CALIB_ALG, "0x5A6", "0x1" ); %clr tiskew error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x5A6", "0x0" ); %clr tiskew error done off

spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x01" ); %tiskew_en

if fsm_run==0
    
while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x581");%wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write(BASE_ADDR_CALIB_ALG, "0x580" , "0x0" ); %tiskew_off

%fs = 3000.0;
%fin = 840.0;
%direct2 = (sign(sin(2*pi*fin/fs))*-1+1)/2;
%direct1 = (sign(sin(2*pi*2*fin/fs))*-1+1)/2;
%direct0 = (sign(sin(2*pi*fin/fs))*-1+1)/2;
%direct = floor(direct2*4+direct1*2+direct0);
%direct_hex = dec2hex(direct);
%spi_write(BASE_ADDR_CALIB_ALG, "0x3f9",direct_hex);
end