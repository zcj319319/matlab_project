%setenv('MW_MINGW64_LOC', 'C:\TDM-GCC-64')
addpath(genpath([pwd, '\..\']));
load_spi_driver;
cfg_top;
%spi_write_raw('0x1000','0x1');
%a=spi_read_raw('0x1000');
%spi_write(BASE_ADDR_ANALOG,'0x0000','0x1');
%a=spi_read(BASE_ADDR_ANALOG,'0x0000');
analog_set;
digital_set;

cfg_dnc;
cfg_gec;
cfg_tios;
cfg_tigain;
cfg_tiskew;
cfg_fsm;

alg_run(cfg_alg_en, fsm_mode);
spi_read(BASE_ADDR_CALIB_ALG, "0x00C")
dump_mem_ddc_out;
memory_data_analyze;

[skew_code0,skew_code1,skew_code2,skew_code3] = rd_tiskew_code;
skew_code0_dec = hex2dec(skew_code0);
skew_code1_dec = hex2dec(skew_code1);
skew_code2_dec = hex2dec(skew_code2);
skew_code3_dec = hex2dec(skew_code3);
skew_code0_dec_old = skew_code0_dec;
skew_code1_dec_old = skew_code1_dec;
skew_code2_dec_old = skew_code2_dec;
skew_code3_dec_old = skew_code3_dec;
cfg_tiskew_code(dec2hex(skew_code0_dec_old),dec2hex(skew_code1_dec_old),dec2hex(skew_code2_dec_old),dec2hex(skew_code3_dec_old));



% for skew_code1_dec_new = 0:1023
%     skew_code1 = dec2hex(skew_code1_dec_new);
%     cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3);
%     dump_mem_ddc_out;
%     skewCal;
%     fprintf(fskew, "skewcode:skew_code0: %03s, skew_code1: %03s, skew_code2: %03s, skew_code3: %03s\n", skew_code0, skew_code1, skew_code2, skew_code3);
%     fprintf(fskew, "skewAC: %e\n", skewAC);
%     fprintf(fskew, "skewB: %e\n",  skewB);
%     fprintf(fskew, "skewD: %e\n",  skewD);
%     fprintf(fskew, "corrAC: %e\n", corrAC);
%     fprintf(fskew, "corrB: %e\n",  corrB);
%     fprintf(fskew, "corrD: %e\n",  corrD);
% end
% 
%skew_code1 = dec2hex(skew_code1_dec_old);
%cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3);

while(1)
    t = datetime('now','TimeZone','local','Format','HH_mm_ss');
    fskew = fopen(['skew_and_corr','_',char(t),'.log'], 'w');
    fprintf(fskew, "skewcode converge:skew_code0: %03s, skew_code1: %03s, skew_code2: %03s, skew_code3: %03s\n", skew_code0, skew_code1, skew_code2, skew_code3);

    for skew_code2_dec_new = skew_code2_dec_old - 50:1:skew_code2_dec_old + 50
        skew_code2 = dec2hex(skew_code2_dec_new);
        cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3);
        skewAC_sum = 0;
        corrAC_sum = 0;
        for dump_vol=1:16
            fprintf("skew code:%03s, dump_vol: %d\n", skew_code2, dump_vol);
            dump_mem_ddc_out;
            skewCal;
            skewAC_sum = skewAC_sum + skewAC;
            corrAC_sum = corrAC_sum + corrAC;
        end
        skewAC_ave = skewAC_sum/dump_vol;
        corrAC_ave = corrAC_sum/dump_vol;
        fprintf(fskew, "skew_code2: %03s\t", skew_code2);
        fprintf(fskew, "skewAC_ave: %e\t", skewAC_ave);
        fprintf(fskew, "corrAC_ave: %e\t\n", corrAC_ave);
    end
    fclose(fskew);
end

skew_code2 = dec2hex(skew_code2_dec_old);
cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3);

for skew_code3_dec_new = 0:1023
    skew_code3 = dec2hex(skew_code3_dec_new);
    cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3);
    dump_mem_ddc_out;
    skewCal;
end

skew_code3 = dec2hex(skew_code3_dec_old);
cfg_tiskew_code(skew_code0,skew_code1,skew_code2,skew_code3);

fclose(fskew);

dump_mem_ddc_out;
memory_data_analyze;