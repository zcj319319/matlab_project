%% trigger data smpl
reg_smpl=1;
reg_set;
%% readout data smpl
spi_write_raw( "0x471"   , "0x2" );
spi_write_raw( "0x478"   , "0x0" );
spi_write_raw( "0x470"   , "0x40000" );
spi_write_raw( "0x470"   , "0x0" );
% fileID = fopen('memory_dump_data.txt','w');
xxtemp_tot=[];
for index_f=0:63
    spi_write_raw( "0x470"   , dec2hex(2^18+index_f*4*1024));
    spi_write_raw( "0x470"   , dec2hex(index_f*4*1024) );
    xtemp=spi_read("0x400","0x7c",1024);
%     xxtemp=strcat(xtemp(1:4:end,:), xtemp(2:4:end,:), xtemp(3:4:end,:), xtemp(4:4:end,:) ,repmat("\n",1024,1)); % reshape 8bit to 32bit
% if not write in file, no need for \n
    xxtemp=strcat(xtemp(1:4:end,:), xtemp(2:4:end,:), xtemp(3:4:end,:), xtemp(4:4:end,:) ); % reshape 8bit to 32bit
    xxtemp=char(xxtemp); % change to char
    xxtemp_tot=[xxtemp_tot;xxtemp]; % merge 64 times
end
% fprintf(fileID,xxtemp_tot');
% fclose(fileID);

%% data trans
MEM_SEC_NUM = 64;
MEM_SEC_SIZE = 1024;

% need config
start_sec_idx = 0;
end_sec_idx = 63;
if smp_origin==0
    bit_num = 2;
elseif smp_origin==1
    bit_num = 3;
end

% read_write_path = 'C:\\Users\\Tauren_LAB_0\\Desktop\\yunlong_test\\yunlong_ui_v0.1\\';
% read_file_name = strcat(read_write_path,'memory_dump_data.txt');
% write_file_name = strcat(read_write_path,'read_data_from_testmem_after_trans.txt');
% xtemp=textread('memory_dump_data.txt', '%s');

smp_width = (2^bit_num)*32;
smp_sec_num = 2^bit_num;
sec_use_num = end_sec_idx - start_sec_idx + 1;
sec_grp_num = floor(sec_use_num/smp_sec_num);

% reshape data by MEM_SEC_SIZE,smp_sec_num,sec_grp_num(1024,4,16)
% change data order(1 1025 2049 3073 2 ...) in every (4096)
% by permute 1st and 2nd dim
xxtemp_tot=hex2dec(xxtemp_tot);
xxtemp_tot=reshape(xxtemp_tot,MEM_SEC_SIZE,smp_sec_num,sec_grp_num);
xxtemp_tot=permute(xxtemp_tot,[2 1 3]);
xxtemp_tot=xxtemp_tot(:);

data=[mod(xxtemp_tot,65536) floor(xxtemp_tot/65536)];
data=data';
data=data(:);
%% data format
if smp_origin==0
    index=data>=32768;
    data(index)=data(index)-65536;
elseif smp_origin==1
%     data_dec = hex2dec(data);
    data_dec = data;
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
            new_str = dec2bin(data_out_i(comb,j),16);%最高16bit在最后一列，丢弃
            char = strcat(new_str,char);% 以16bit为单位，从后往前拼，这样拼完的顺序应该和数字一样了
        end

        for i = 1:8
            offset = 30*i;
            mdac_d1(i,comb) = ther_tran(char(240-offset+1),char(240-offset+2),char(240-offset+3),char(240-offset+4));
            mdac_d2(i,comb) = ther_tran(char(240-offset+5),char(240-offset+6),char(240-offset+7),char(240-offset+8));
            bkadc_d1(i,comb) = ther_tran(char(240-offset+9),char(240-offset+10),char(240-offset+11),char(240-offset+12));
            bkadc_d2(i,comb) = ther_tran(char(240-offset+13),char(240-offset+14),char(240-offset+15),char(240-offset+16));
            bkadc_d3(i,comb) = ther_tran(char(240-offset+17),char(240-offset+18),char(240-offset+19),char(240-offset+20));
            gec_pn(comb) = str2num(char(240-offset+21));
            chopper_pn(comb) = str2num(char(240-offset+22));
            dither_pn(comb) = str2num(char(240-offset+23));
            dither_sync(comb) = str2num(char(240-offset+24));
            mdac_dem(comb) = str2num(char(240-offset+25))+str2num(char(240-offset+26))+str2num(char(240-offset+27));
            bk_dem(comb) = str2num(char(240-offset+28))+str2num(char(240-offset+29))+str2num(char(240-offset+30));
        end
    end

%     weight_mdac_d1 = 4096/56*6;
%     weight_mdac_d2 = 4096/56*1;
%     weight_bkadc_d1 = 36/344*256;
%     weight_bkadc_d2 = 6/344*256;
%     weight_bkadc_d3 = 1/344*256;
%     original_data = zeros(1,data_length*8);
%     data_fft = zeros(1,data_length*8);
%     for idx = 1:data_length
%         for i = 1:8
%             original_data(idx*8-8+i) = mdac_d1(i,idx).*weight_mdac_d1 + mdac_d2(i,idx).*weight_mdac_d2 ...
%                 + bkadc_d1(i,idx).*weight_bkadc_d1 + bkadc_d2(i,idx).*weight_bkadc_d2 + bkadc_d3(i,idx).*weight_bkadc_d3;
%         end
%     end
%     for i = 1:data_length
%         data_fft(8*i-7) = original_data(8*i-7);
%         data_fft(8*i-6) = original_data(8*i-5);
%         data_fft(8*i-5) = original_data(8*i-3);
%         data_fft(8*i-4) = original_data(8*i-1);
%         data_fft(8*i-3) = original_data(8*i-6);
%         data_fft(8*i-2) = original_data(8*i-4);
%         data_fft(8*i-1) = original_data(8*i-2);
%         data_fft(8*i-0) = original_data(8*i-0);
%     end

    figure;plot(mdac_d1(1,:));title('mdac d1')
    figure;plot(mdac_d2(1,:));title('mdac d2')
    figure;plot(bkadc_d1(1,:));title('bk d1')
    figure;plot(bkadc_d2(1,:));title('bk d2')
    figure;plot(bkadc_d3(1,:));title('bk d3')
    figure;plot(gec_pn);title('gec pn')
    figure;plot(chopper_pn);title('chopper pn')
    figure;plot(dither_pn);title('dither pn')
    figure;plot(dither_sync);title('dither sync')
    figure;plot(mdac_dem);title('mdac dem')
    figure;plot(bk_dem);title('bk dem')
end

function out=ther_tran(char1,char2,char3,char4) % for dac nq=1 so no modification for now...
     out = str2num(char1)*8 + str2num(char2)*4 + str2num(char3)*2 + str2num(char4);
end