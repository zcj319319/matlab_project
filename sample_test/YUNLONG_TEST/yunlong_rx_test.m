%%
% type: sweep fs, fsig, amplitude, dsa ,single tone , two tone
%% initial
clear all
close all
addpath(genpath([pwd, '\..\']));
load_spi_driver;
regMap;
%%
%% test type
% single_test
% sweep_test
test_type='sweep_test';
test_type='single_test';
%% set test channel, set clock frequency/signal range, set dsa/mode
DDC_IND='rx1' % for sweep folder name

fsig_set=1e9:500e6:8e9;
fdelta=0e6; % for 2tone test
amp_set=-3:-6:-21;
dsa_set=0;
fref=494.5e6;
divratio=24/4;

testid='FPGA5';
testid='SMA2';

inputcon.fsig_set=fsig_set;
inputcon.fdelta=fdelta;
inputcon.amp_set=amp_set;
inputcon.fref=fref;
inputcon.divratio=divratio;
inputcon.testid=testid;
inputcon.fs=fref*divratio;
%% starting instrument setting
% 所需控制频率为Hz
Instr.SigFre = 3.123456789e9;
% 所需控制功率为dBm
Instr.SigPow = -10;
% 连接线线损为dB
Instr.Loss = 0;
%% set signal source
 %设置信号源地址
% instrumentVISAAddress = 'TCPIP0::192.168.18.133::inst0::INSTR';
% 
% Control_SG_sig
% pause(1)
%% set clock source
% Control_SG_clk
%% reg write, enable pll/sysref/rx
reg_smpl=0;
reg_set

%% enable calibration
ALG_IND_SET={'rx0','rx1'};
for ALG_IND=ALG_IND_SET
    ALG_IND=ALG_IND{1};
    addr_set
    % DEM 
    spi_write(BASE_ADDR_CALIB_ALG_TOP, "0xEF"   , "0x0f" ); %mdac DEM
    spi_write(BASE_ADDR_CALIB_ALG_TOP, "0xF0"   , "0x0f" ); %bk DEM
    % over/underflow
    cfg_vth_det
    % cali_set
    cfg_fsm_latest
    dither_en=0;
    if dither_en==1
        spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x0fd", "0x1" ); %ctrl data path dither en
        spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x0f3", "0xf" ); % dither en
        spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x0f4", "0xf" ); % dither en vld
    else
        spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x0fd", "0x0" ); %ctrl data path dither en
        spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x0f3", "0x0" ); % dither en
        spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x0f4", "0x0" ); % dither en vld
    end
    spi_write(BASE_ADDR_CALIB_ALG_TOP, "0x05", "0x1" ); % cfg_dp_dither_os_weight_sel
end
%%
if strcmp(test_type,'sweep_test')
    pause(30)
end
smp_origin=0;
smp_dual=0;
data_smpl_trans
%% data analyze
% fref=494.5e6;
fs = fref*divratio;
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
% Read_SG_sig;
% para.nyquitst_zone=floor(Instr.SigFreRead/(fs/2))+1;
para.nyquitst_zone=1;
para.dacOSR=1;
para.plot_range=0;
para.simple_plot=0;
para.dc_1f_noise_cancel=20e6;      %% add cancel dc  and 1/f noise
para.dbc_th_HD=-70;                %% not add color for -70dbc
para.dbc_th_IMD=-70;
para.dbc_th_IL=-70;    
para.dbc_th_SFDR=70;
para.figure_overwrite=1;
para.imd_mode=0;
para.refclk_ratio=divratio;
para.sig_angle=1;
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
smp_origin=1;
data_smpl_trans;
%%
% fileID = fopen('calib_data_trace.txt','w');
% spi_write("0x0", "0x66"   , dec2hex(2^8*0) )
% spi_write("0x0", "0x66"   , dec2hex(2^8*63) )
% spi_write("0x0", "0x66"   , dec2hex(2^8*22) )

if strcmp(test_type,'single_test')
    for ALG_IND=ALG_IND_SET
        ALG_IND=ALG_IND{1};
        addr_set
        spi_write(BASE_ADDR_CALIB_ALG, "0x624"   , "0x00" ); %gec vth en
        spi_write(BASE_ADDR_CALIB_ALG, "0x62d"   , "0x00" ); %subgec vth en
        spi_write(BASE_ADDR_CALIB_ALG, "0x61b"   , "0x00" ); %bkgec vth en
        spi_write(BASE_ADDR_CALIB_ALG, "0x600"   , "0x00" ); %tios vth en
        spi_write(BASE_ADDR_CALIB_ALG, "0x636"   , "0x00" ); %tigain vth en
        spi_write(BASE_ADDR_CALIB_ALG, "0x63f"   , "0x00" ); %tiskew vth en
    end
    check_cali_change=0;
    while(1)
        smp_origin=0;
        smp_dual=0;
        data_smpl_trans;
%         Read_SG_sig;
%         para.nyquitst_zone=floor(Instr.SigFreRead/(fs/2))+1;
        para.nyquitst_zone=1;
        perf=fft_calc_tot(data(1:1:end),fs,15,para);
        perf.sig_angle
        rpt_calib;
        check_cali_update
        calib
        calib_pre=calib;
        rx_corr.man_stdAB=std(data(1:4:end))/std(data(2:4:end));
        rx_corr.man_stdAC=std(data(1:4:end))/std(data(3:4:end));
        rx_corr.man_stdAD=std(data(1:4:end))/std(data(4:4:end));
        rx_corr.man_corrAC=sum(data(1:4:end-4).*data(3:4:end-4)-data(3:4:end-4).*data(5:4:end));
        rx_corr.man_corrABC=sum(data(1:4:end).*data(2:4:end)*rx_corr.man_stdAB-data(2:4:end).*data(3:4:end)*rx_corr.man_stdAC);
        rx_corr.man_corrCDA=sum(data(3:4:end-4).*data(4:4:end-4)*rx_corr.man_stdAC*rx_corr.man_stdAD-data(4:4:end-4).*data(5:4:end)*rx_corr.man_stdAD);
        rx_corr
    %     calib.dnc_weight1
    %     calib.dnc_weight2
    %     calib.dnc_bkweight1
    %     calib.dnc_bkweight2
    %     calib.dnc_bkweight3
    %     calib.dnc_os_weight
    %     calib_log;
    end
end

if strcmp(test_type,'sweep_test')
    mkdir('test_data')
    % ./testid_date_ch_fref_fs_fsig_fdelta_amp_dsa
    % ifsig    fsig_set=1e9:50e6:8e9;
    % ifdelta  fdelta=10e6;
    % iamp     amp_set=-3:-3:-21;
    % idsa     dsa_set=0:63;
    tic
    counter=0;
    num_case=length(fsig_set)*length(fdelta)*length(amp_set)*length(dsa_set);
    for ifsig=1:length(fsig_set)
        for ifdelta=1:length(fdelta)
                    % set instr
                    Instr.SigFre = fsig_set(ifsig);
                    Instr.SigPow = 0;
                    Instr.Loss = 0;
                    Control_SG_sig
            for iamp=1:length(amp_set) % adjust amp only at amp phase, not in dsa phase
                    % readback amp
                    smp_origin=0;
                    data_smpl_trans;
                    para.plot_option=0;
                    perf=fft_calc_tot(data(1:1:end),fs,15,para);
                    ampcurrent=perf.SIG1_dbfs;
                    ampadjust=amp_set(iamp)-ampcurrent;
                    % adjust amp
                    Read_SG_sig;
                    Instr.SigPow=Instr.SigPowRead+ampadjust;
                    Control_SG_sig
                    pause(1)
                for idsa=1:length(dsa_set)
                    % sample data
                    while(1)
                        smp_origin=0;
                        data_smpl_trans;
                        Read_SG_sig;
                        para.nyquitst_zone=floor(Instr.SigFreRead/(fs/2))+1;
                        para.plot_option=1;
                        perf=fft_calc_tot(data(1:1:end),fs,15,para);
                        h=figure(1);
                        h.WindowState = 'maximized';
                        rpt_calib;
                        calib
                        if calib.tiskew_code(2)==0||calib.tiskew_code(2)==1023
                            spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x00" ); %tiskew_en
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a5"   , "0x01" ); %low power
                            spi_write(BASE_ADDR_CALIB_ALG, "0x597"   , "0x00" ); %B ch
                            spi_write(BASE_ADDR_CALIB_ALG, "0x598"   , "0x02" ); 
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59e"   , "0x01" ); %vld
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59e"   , "0x00" ); 
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a5"   , "0x00" ); %low power
                            spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x01" ); %tiskew_en
                            strcat('Bch_overflow:',testid,'_',DDC_IND,'_',date,'_',num2str(fref,'%2.3E'),'_',num2str(fs,'%2.3E'),'_',num2str(fsig_set(ifsig),'%2.3E'),'_',num2str(fdelta(ifdelta),'%2.3E'),'_',num2str(amp_set(iamp)),'_',num2str(dsa_set(idsa)))
                            pause(10)
                        elseif calib.tiskew_code(3)==0||calib.tiskew_code(3)==1023
                            spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x00" ); %tiskew_en
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a5"   , "0x01" ); %low power
                            spi_write(BASE_ADDR_CALIB_ALG, "0x599"   , "0x00" ); %C ch
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59a"   , "0x02" ); 
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59f"   , "0x01" ); %vld
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59f"   , "0x00" ); 
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a5"   , "0x00" ); %low power
                            spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x01" ); %tiskew_en
                            strcat('Cch_overflow:',testid,'_',DDC_IND,'_',date,'_',num2str(fref,'%2.3E'),'_',num2str(fs,'%2.3E'),'_',num2str(fsig_set(ifsig),'%2.3E'),'_',num2str(fdelta(ifdelta),'%2.3E'),'_',num2str(amp_set(iamp)),'_',num2str(dsa_set(idsa)))
                            pause(10)
                        elseif calib.tiskew_code(4)==0||calib.tiskew_code(4)==1023
                            spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x00" ); %tiskew_en
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a5"   , "0x01" ); %low power
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59b"   , "0x00" ); %D ch
                            spi_write(BASE_ADDR_CALIB_ALG, "0x59c"   , "0x02" ); 
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a0"   , "0x01" ); %vld
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a0"   , "0x00" );
                            spi_write(BASE_ADDR_CALIB_ALG, "0x5a5"   , "0x00" ); %low power
                            spi_write(BASE_ADDR_CALIB_ALG, "0x580"   , "0x01" ); %tiskew_en
                            strcat('Dch_overflow:',testid,'_',DDC_IND,'_',date,'_',num2str(fref,'%2.3E'),'_',num2str(fs,'%2.3E'),'_',num2str(fsig_set(ifsig),'%2.3E'),'_',num2str(fdelta(ifdelta),'%2.3E'),'_',num2str(amp_set(iamp)),'_',num2str(dsa_set(idsa)))
                            pause(10)
                        else
                            break
                        end
                    end
                    % save data
                    % ./testid_date_ch_fref_fs_fsig_fdelta_amp_dsa
                    strfold=strcat('./test_data/',testid,'_',DDC_IND,'_',date,'_',num2str(fref,'%2.3E'),'_',num2str(fs,'%2.3E'),'_',num2str(fsig_set(ifsig),'%2.3E'),'_',num2str(fdelta(ifdelta),'%2.3E'),'_',num2str(amp_set(iamp)),'_',num2str(dsa_set(idsa)));
                    mkdir(strfold)
    %                 cd(strfold)
                    save(strcat(strfold,'/matlab.mat'), 'data', 'para', 'calib', 'Instr', 'inputcon', 'perf');
                    saveas(h,strcat(strfold,'/1.png'));
    %                 cd ..
                    counter=counter+1;
                    strcat('complete',num2str(counter/num_case*100,'%3.3f'),'%')
                end
            end
        end
    end
    toc             
end
% %% stop fsm
% spi_write(BASE_ADDR_CALIB_ALG, "0x006", "0x01" ); % stop, stop 电平有效
% spi_write(BASE_ADDR_CALIB_ALG, "0x006", "0x00" ); % stop, stop 电平有效
% for dsa_code=0:63
%     spi_write("0x0", "0x66"   , dec2hex(2^8*dsa_code) );
%     pause(0.1);
%     smp_origin=0;
%     data_smpl_trans;
%     perf=fft_calc_tot(data(1:1:end),fs,15,para);
%     amp_array(dsa_code+1)=perf.SIG1_dbfs
%     data_array(:,dsa_code+1)=data;
% end
%     
% fclose(fileID);
%% dual channel test
ALG_IND='rx0';
addr_set


for dsa_code=0:63
    
% dsa_code=0;
xtemp=spi_read(BASE_ADDR_ANA, '0x0A'); % get dsa related reg
xtemp(3,:)=dec2hex(dsa_code,2); % 15~8 dsa code
xxtemp=strcat(xtemp(1,:), xtemp(2,:), xtemp(3,:), xtemp(4,:) );
spi_write(BASE_ADDR_ANA, '0x0A'   , xxtemp );

%
smp_origin=0;
smp_dual=1;
data_smpl_trans;
%         Read_SG_sig;
%         para.nyquitst_zone=floor(Instr.SigFreRead/(fs/2))+1;
para.nyquitst_zone=1;
perf1=fft_calc_tot(data(1:1:end/2),fs,15,para);
perf2=fft_calc_tot(data(end/2:1:end),fs,15,para);
perf1.sig_angle;
perf2.sig_angle;
delta_angle=perf1.sig_angle-perf2.sig_angle;
if delta_angle<-0
    delta_angle=delta_angle+360;
elseif delta_angle>=360
    delta_angle=delta_angle-360;
end
delta_angle;
delta_angle_array(dsa_code+1)=delta_angle;
dsa_code
end
save('dsa_phase_8G.mat', 'delta_angle_array');


