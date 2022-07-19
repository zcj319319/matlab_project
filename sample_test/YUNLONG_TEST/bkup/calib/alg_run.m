function state = alg_run(cfg_alg_en, fsm_mode)

regMap;

if (fsm_mode == "manual_mode")
    spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x0" ); %dnc_off
    spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , cfg_alg_en.dnc_en); %dnc_on
    pause(0.5); 
    spi_write(BASE_ADDR_CALIB_ALG, "0x10"   , "0x0" ); %dnc_off
    
    spi_write(BASE_ADDR_CALIB_ALG, "0x360" , "0x0" ); %gec_off
    spi_write(BASE_ADDR_CALIB_ALG, "0x360" , cfg_alg_en.gec_en); %gec_on
    pause(0.5); 
    spi_write(BASE_ADDR_CALIB_ALG, "0x360" , "0x0" ); %gec_off

    spi_write(BASE_ADDR_CALIB_ALG, "0x3A0" , "0x0" ); %tios_off
    spi_write(BASE_ADDR_CALIB_ALG, "0x3A0" , cfg_alg_en.tios_en); %tios_on
    while (1)
        state = 0;
        state = hex2dec(spi_read(BASE_ADDR_CALIB_ALG, "0x3A2"));
        if (state == 1)
            break;
        else
            pause(0.1);
        end
    end
    spi_write(BASE_ADDR_CALIB_ALG, "0x3A0" , "0x0" ); %tios_off

    spi_write(BASE_ADDR_CALIB_ALG, "0x3C0" , "0x0" ); %tigain_off
    spi_write(BASE_ADDR_CALIB_ALG, "0x3C0" , cfg_alg_en.tigain_en); %tigain_on
    while (1)
        state = 0;
        state = hex2dec(spi_read(BASE_ADDR_CALIB_ALG, "0x3C1"));
        if (state == 1)
            break;
        else
            pause(0.1);
        end
    end
    spi_write(BASE_ADDR_CALIB_ALG, "0x3C0" , "0x0" ); %tigain_off
    
    spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x0" ); %tiskew_off
    spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , cfg_alg_en.tiskew_en); %tiskew_on
    while (1)
        state = 0;
        state = hex2dec(spi_read(BASE_ADDR_CALIB_ALG, "0x3F1"));
        if (state == 1)
            break;
        else
            pause(0.1);
        end
    end
    spi_write(BASE_ADDR_CALIB_ALG, "0x3F0" , "0x0" ); %tiskew_off
elseif (fsm_mode == "fsm_mode")
    spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x1" ); %fsm_en
    spi_write(BASE_ADDR_CALIB_ALG, "0x10", cfg_alg_en.dnc_en); %dnc_on
    spi_write(BASE_ADDR_CALIB_ALG, "0x360", cfg_alg_en.gec_en); %gec_on    
    spi_write(BASE_ADDR_CALIB_ALG, "0x3A0", cfg_alg_en.tios_en); %tios_on
    spi_write(BASE_ADDR_CALIB_ALG, "0x3C0", cfg_alg_en.tigain_en); %tigain_on
    spi_write(BASE_ADDR_CALIB_ALG, "0x3F0", cfg_alg_en.tiskew_en); %tiskew_on
    spi_write(BASE_ADDR_CALIB_ALG, "0x01", "0x1" ); %fsm_start
    pause(1);
    spi_write(BASE_ADDR_CALIB_ALG, "0x00A", "0x04" ); % tios always on
end

