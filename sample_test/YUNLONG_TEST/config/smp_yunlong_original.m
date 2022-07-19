% close all;
% clear all;

%% data trans
data = textread('C:\\Users\\Tauren_LAB_0\\Desktop\\yunlong_test\\yunlong_ui_v0.1\\read_data_from_testmem_after_trans.txt', '%s');
%data = textread([pwd,'\','memory_dump_data.txt'], '%s');

% data = textread('memory_dump_rd.txt', '%s');
data_dec = hex2dec(data);
% index=data>=32768;
% data(index)=data(index)-65536;



data_length = 2^16/8;
data_out_i = zeros(data_length,16);
mdac_d1 = zeros(8,data_length);
mdac_d2 = zeros(8,data_length);
bkadc_d1 = zeros(8,data_length);
bkadc_d2 = zeros(8,data_length);
bkadc_d3 = zeros(8,data_length);
gec_pn = zeros(1,data_length);
chopper_pn = zeros(1,data_length);
dither_pn = zeros(1,data_length);
dither_sync = zeros(1,data_length);
gec_pn = zeros(1,data_length);
mdac_dem = zeros(1,data_length);
bk_dem = zeros(1,data_length);
for idx = 1:data_length
    for i = 1:16
        data_out_i(idx,i) = data_dec(idx*16-16 + i);
    end
end


for comb = 1:data_length
    char='';
    for j = 1:15
        new_str = dec2bin(data_out_i(comb,j),16);
        char = strcat(new_str,char);
    end
 
    for i = 1:8
        offset = 30*i;
        mdac_d1(i,comb) = ther_tran(char(240-offset+1),char(240-offset+2),char(240-offset+3),char(240-offset+4));
        mdac_d2(i,comb) = ther_tran(char(240-offset+5),char(240-offset+6),char(240-offset+7),char(240-offset+8));
        bkadc_d1(i,comb) = ther_tran(char(240-offset+9),char(240-offset+10),char(240-offset+11),char(240-offset+12));
        bkadc_d2(i,comb) = ther_tran(char(240-offset+13),char(240-offset+14),char(240-offset+15),char(240-offset+16));
        bkadc_d3(i,comb) = ther_tran(char(240-offset+17),char(240-offset+18),char(240-offset+19),char(240-offset+20));
        chopper_pn(comb) = str2num(char(240-offset+21));
        dither_pn(comb) = str2num(char(240-offset+22));
        dither_sync(comb) = str2num(char(240-offset+23));
        gec_pn(comb) = str2num(char(240-offset+24));
        mdac_dem(comb) = str2num(char(240-offset+25))+str2num(char(240-offset+26))+str2num(char(240-offset+27));
        bk_dem(comb) = str2num(char(240-offset+28))+str2num(char(240-offset+29))+str2num(char(240-offset+30));
    end
end

weight_mdac_d1 = 4096/56*6;
weight_mdac_d2 = 4096/56*1;
weight_bkadc_d1 = 36/344*256;
weight_bkadc_d2 = 6/344*256;
weight_bkadc_d3 = 1/344*256;
original_data = zeros(1,data_length*8);
data_fft = zeros(1,data_length*8);
for idx = 1:data_length
    for i = 1:8
        original_data(idx*8-8+i) = mdac_d1(i,idx).*weight_mdac_d1 + mdac_d2(i,idx).*weight_mdac_d2 ...
            + bkadc_d1(i,idx).*weight_bkadc_d1 + bkadc_d2(i,idx).*weight_bkadc_d2 + bkadc_d3(i,idx).*weight_bkadc_d3;
    end
end
for i = 1:data_length
    data_fft(8*i-7) = original_data(8*i-7);
    data_fft(8*i-6) = original_data(8*i-5);
    data_fft(8*i-5) = original_data(8*i-3);
    data_fft(8*i-4) = original_data(8*i-1);
    data_fft(8*i-3) = original_data(8*i-6);
    data_fft(8*i-2) = original_data(8*i-4);
    data_fft(8*i-1) = original_data(8*i-2);
    data_fft(8*i-0) = original_data(8*i-0);
end

figure;plot(mdac_d1(1,:));title('mdac d1')
figure;plot(mdac_d2(1,:));title('mdac d2')
figure;plot(bkadc_d1(1,:));title('bk d1')
figure;plot(bkadc_d2(1,:));title('bk d2')
figure;plot(bkadc_d3(1,:));title('bk d3')
%% data analyze
fs = 3.2e9;
% para.sigbw=100e6;
% para.dpdbw=300e6;
para.sideband=300;
para.sideband_sig=3e6;
para.fullscale=1000;
para.Rl=100;
para.num_interleave=4;
para.num_HD=11;
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

% perf=fft_calc(data_fft(1:4:end),fs,15,para);
% perf=fft_calc(data_fft(1:2:end),fs,15,para);
% perf=fft_calc(data_fft(1:3:end),fs,15,para);
% perf=fft_calc(data_fft(1:4:end),fs,15,para);
perf=fft_calc(data_fft(1:2:end),fs,15,para);
figure(2)
plot(data_fft(101:8:8+101));
hold on;
plot(data_fft(102:8:8+102));
hold on;
plot(data_fft(103:8:8+103));
hold on;
plot(data_fft(104:8:8+104));
hold on;
plot(data_fft(105:8:8+105));
hold on;
plot(data_fft(106:8:8+106));
hold on;
plot(data_fft(107:8:8+107));
hold on;
plot(data_fft(108:8:8+108));
hold on;
figure(3)
plot(data_fft(1:1:end));

function out=ther_tran(char1,char2,char3,char4) % for dac nq=1 so no modification for now...
     out = str2num(char1)*8 + str2num(char2)*4 + str2num(char3)*2 + str2num(char4);
end
