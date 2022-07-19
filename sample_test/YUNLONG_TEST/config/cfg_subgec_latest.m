
% BASE_ADDR_CALIB_ALG = '0x10100';
% BASE_ADDR_CALIB_ALG = '0x11100';
% BASE_ADDR_CALIB_ALG = '0x14100';
spi_write(BASE_ADDR_CALIB_ALG, "0x649"   , "0x01" ); %alg clk on
spi_write(BASE_ADDR_CALIB_ALG, "0x4DC"   , "0x01" ); %subgec clk on
spi_write(BASE_ADDR_CALIB_ALG, "0x4DC"   , "0x00" ); %subgec clk off
spi_write(BASE_ADDR_CALIB_ALG, "0x649"   , "0x00" ); %alg clk off


spi_write(BASE_ADDR_CALIB_ALG, "0x4DE"   , "0x60" ); %subgec ideal
spi_write(BASE_ADDR_CALIB_ALG, "0x4DD"   , "0x01" ); %sugec code update step
spi_write(BASE_ADDR_CALIB_ALG, "0x4C3"   , "0x14" ); %accnum_power2

spi_write(BASE_ADDR_CALIB_ALG, "0x4DF"  , "0x1" ); %clr subgec error done on
spi_write(BASE_ADDR_CALIB_ALG, "0x4DF"  , "0x0" ); %clr subgec error done off
%%
spi_write(BASE_ADDR_CALIB_ALG, "0x4C0"   , "0x01" ); %subgec_en

if fsm_run==0
spi_read(BASE_ADDR_CALIB_ALG, "0x4DE" ) %ideal coeff,4Î»Ð¡Êý

while(1)
    xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4C1");%rpt_subgec_done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write(BASE_ADDR_CALIB_ALG, "0x4C0"   , "0x00" ); %subgec_en off
end

