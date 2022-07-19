%%
function perf = xihe_adc_test_display(file_path,param)
data = textread(file_path, '%s');
% %data = textread([pwd,'\','memory_dump_data.txt'], '%s');
% 
% % data = textread('memory_dump_rd.txt', '%s');
data = hex2dec(data);
index=data>=32768;
data(index)=data(index)-65536;


% fs = 6e9;
% % para.sigbw=100e6;
% % para.dpdbw=300e6;
% para.sideband=300;
% para.sideband_sig=2e6;
% para.fullscale=1000;
% para.Rl=100;
% para.num_interleave=4;
% para.num_HD=13;
% para.num_IMD=3;
% para.window='hann';
% % Read_SG_sig;
% % para.nyquitst_zone=floor(Instr.SigFreRead/(fs/2))+1;
% para.nyquitst_zone=1;
% para.dacOSR=1;
% para.plot_range=0;
% para.simple_plot=0;
% para.dc_1f_noise_cancel=20e6;      %% add cancel dc  and 1/f noise
% para.dbc_th_HD=-70;                %% not add color for -70dbc
% para.dbc_th_IMD=-70;
% para.dbc_th_IL=-70;    
% para.dbc_th_SFDR=70;
% para.figure_overwrite=1;
% para.imd_mode=1;
% % para.refclk_ratio=divratio;
% para.sig_angle=1;
% perf=fft_calc(data(1:4:end),fs,15,para);
% perf=fft_calc(data(1:2:end),fs,15,para);
% perf=fft_calc(data(1:3:end),fs,15,para);
% perf=fft_calc(data(1:4:end),fs,15,para);
% angle_arr=[]
% for i=1:8
% perf=fft_calc_tot(data_r(i:8:end),fs,15,para);
% angle_arr=[angle_arr perf.sig_angle];
% end
% perf=fft_calc_tot(data(1:8:end),fs,15,para);
fs=param.fs;

data_r=reshape(data,8,length(data)/8);
data_r=data_r([1 3 5 7 2 4 6 8],:);
data_r=data_r(:);
% perf=fft_calc_tot(data_r(1:4:end),fs,15,para);
% perf=fft_calc_tot(data_r(2:4:end),fs,15,para);
% perf=fft_calc_tot(data_r(3:4:end),fs,15,para);
% perf=fft_calc_tot(data_r(4:4:end),fs,15,para);
perf=fft_calc_tot(data_r(1:1:end),fs,15,param);
% 

% plot(data_r(1:4:end));
% figure;
% plot(data_r(2:4:end));
% figure;
% plot(data_r(3:4:end));
% figure;
% plot(data_r(4:4:end));
