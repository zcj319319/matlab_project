cali_rst;
digital_set;
cfg_dnc;
cfg_gec;
cfg_tios;
cfg_tigain;
cfg_tiskew;
cfg_fsm;

spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x0" ); %fsm_en
spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x1" ); %fsm_en
spi_write(BASE_ADDR_CALIB_ALG, "0x10", cfg_alg_en.dnc_en); %dnc_on
spi_write(BASE_ADDR_CALIB_ALG, "0x360", cfg_alg_en.gec_en); %gec_on    
spi_write(BASE_ADDR_CALIB_ALG, "0x3A0", cfg_alg_en.tios_en); %tios_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3C0", cfg_alg_en.tigain_en); %tigain_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0", cfg_alg_en.tiskew_en); %tiskew_on
spi_write(BASE_ADDR_CALIB_ALG, "0x01", "0x1"); %fsm_start
pause(3);
spi_write(BASE_ADDR_CALIB_ALG, "0x10", '0x0'); %dnc_on
spi_write(BASE_ADDR_CALIB_ALG, "0x360", '0x0'); %gec_on    
spi_write(BASE_ADDR_CALIB_ALG, "0x3A0", '0x0'); %tios_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3C0", '0x0'); %tigain_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0", '0x0'); %tiskew_on
spi_write(BASE_ADDR_CALIB_ALG, "0x01", "0x0"); %fsm_start
spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x0"); %fsm_en

dump_mem_ddc_out;
memory_data_analyze;

%manual tigain en
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

%manual tiskew en
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

    
spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x0" ); %fsm_en
spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x1" ); %fsm_en
%spi_write(BASE_ADDR_CALIB_ALG, "0x10", cfg_alg_en.dnc_en); %dnc_on
%spi_write(BASE_ADDR_CALIB_ALG, "0x360", cfg_alg_en.gec_en); %gec_on    
spi_write(BASE_ADDR_CALIB_ALG, "0x3A0", cfg_alg_en.tios_en); %tios_on
%spi_write(BASE_ADDR_CALIB_ALG, "0x3C0", cfg_alg_en.tigain_en); %tigain_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0", cfg_alg_en.tiskew_en); %tiskew_on
spi_write(BASE_ADDR_CALIB_ALG, "0x01", "0x1"); %fsm_start
pause(3);
spi_write(BASE_ADDR_CALIB_ALG, "0x10", '0x0'); %dnc_on
spi_write(BASE_ADDR_CALIB_ALG, "0x360", '0x0'); %gec_on    
spi_write(BASE_ADDR_CALIB_ALG, "0x3A0", '0x0'); %tios_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3C0", '0x0'); %tigain_on
spi_write(BASE_ADDR_CALIB_ALG, "0x3F0", '0x0'); %tiskew_on
spi_write(BASE_ADDR_CALIB_ALG, "0x01", "0x0"); %fsm_start
spi_write(BASE_ADDR_CALIB_ALG, "0x00", "0x0"); %fsm_en
dump_mem_ddc_out;
memory_data_analyze;
