clear all
close all
addpath(genpath([pwd, '\..\']));
load_spi_driver;
regMap;
%%
ALG_IND='rx6';
addr_set
%% reg write
reg_smpl=0;
reg_set
%% calibration
% cali_set
cfg_fsm_latest
%%
data_smpl_trans
% %% data trans
% data = textread('C:\\Users\\Tauren_LAB_0\\Desktop\\yunlong_test\\yunlong_ui_v0.1\\read_data_from_testmem_after_trans.txt', '%s');
% %data = textread([pwd,'\','memory_dump_data.txt'], '%s');
% 
% % data = textread('memory_dump_rd.txt', '%s');
% data = hex2dec(data);
% index=data>=32768;
% data(index)=data(index)-65536;
%% data analyze
fs = 6e9/2;
% para.sigbw=100e6;
% para.dpdbw=300e6;
para.sideband=300;
para.sideband_sig=3e6;
para.fullscale=1000;
para.Rl=100;
para.num_interleave=4;
para.num_HD=5;
para.num_IMD=3;
para.window='hann';
para.nyquitst_zone=1;
para.dacOSR=1;
para.plot_range=0;
para.simple_plot=0;
para.dc_1f_noise_cancel=20e6;      %% add cancel dc  and 1/f noise
para.dbc_th_HD=-20;                %% not add color for -70dbc
para.dbc_th_IMD=-20;
para.dbc_th_IL=-20;    
para.dbc_th_SFDR=-20;
para.figure_overwrite=0;
para.imd_mode=0;
% perf=fft_calc(data(1:4:end),fs,15,para);
% perf=fft_calc(data(1:2:end),fs,15,para);
% perf=fft_calc(data(1:3:end),fs,15,para);
% perf=fft_calc(data(1:4:end),fs,15,para);
perf=fft_calc_tot(data(1:1:end),fs,15,para);
% figure(2)
% plot(data);

% std(data(1:4:end))/std(data(2:4:end))
% std(data(1:4:end))/std(data(3:4:end))
% std(data(1:4:end))/std(data(4:4:end))

%%
% fileID = fopen('calib_data_trace.txt','w');
% spi_write("0x0", "0x66"   , dec2hex(2^8*0) )
% spi_write("0x0", "0x66"   , dec2hex(2^8*63) )
% spi_write("0x0", "0x66"   , dec2hex(2^8*22) )

cfg_vth_det
spi_write(BASE_ADDR_CALIB_ALG, "0x624"   , "0x00" ); %gec vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x62d"   , "0x00" ); %subgec vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x61b"   , "0x00" ); %bkgec vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x600"   , "0x00" ); %tios vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x636"   , "0x00" ); %tigain vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x63f"   , "0x00" ); %tiskew vth en
check_cali_change=0;
while(1)
    data_smpl_trans;
    perf=fft_calc_tot(data(1:1:end),fs,15,para);
    rpt_calib;
    check_cali_update
    calib
    calib_pre=calib;
    rx_corr.man_stdAB=std(data(1:4:end))/std(data(2:4:end));
    rx_corr.man_stdAC=std(data(1:4:end))/std(data(3:4:end));
    rx_corr.man_stdAD=std(data(1:4:end))/std(data(4:4:end));
    rx_corr.man_corrAC=sum(data(1:4:end-4).*data(3:4:end-4)-data(3:4:end-4).*data(5:4:end));
    rx_corr.man_corrABC=sum(data(1:4:end).*data(2:4:end)-data(2:4:end).*data(3:4:end));
    rx_corr.man_corrCDA=sum(data(3:4:end-4).*data(4:4:end-4)-data(4:4:end-4).*data(5:4:end));
    rx_corr
%     calib.dnc_weight1
%     calib.dnc_weight2
%     calib.dnc_bkweight1
%     calib.dnc_bkweight2
%     calib.dnc_bkweight3
%     calib_log;

end
for i=1:11
    s=strcat("change freq to ",string(2+(i-1)/2))
    if 2+(i-1)/2<3.7
        para.nyquitst_zone=2;
    elseif 2+(i-1)/2<5.55
        para.nyquitst_zone=3;
    else
        para.nyquitst_zone=4;
    end
    input(s)
    data_smpl_trans;
    perf=fft_calc_tot(data(1:1:end),fs,15,para);
    rpt_calib;
    data_array(:,i)=data;
end
%% stop fsm
spi_write(BASE_ADDR_CALIB_ALG, "0x006", "0x01" ); % stop, stop 电平有效
spi_write(BASE_ADDR_CALIB_ALG, "0x006", "0x00" ); % stop, stop 电平有效
for dsa_code=0:63
    spi_write("0x0", "0x66"   , dec2hex(2^8*dsa_code) );
    pause(0.1);
    data_smpl_trans;
    perf=fft_calc_tot(data(1:1:end),fs,15,para);
    amp_array(dsa_code+1)=perf.SIG1_dbfs
    data_array(:,dsa_code+1)=data;
end
    
fclose(fileID);