clear all;
close all;
data = textread('C:\Users\Tauren_LAB_0\Desktop\yunlong_test\yunlong_ui_v0.1\read_data_from_testmem_after_trans.txt', '%s');
%data = textread('C:\Users\Tauren_LAB_0\Desktop\yunlong_test\yunlong_ui_v0.1\memory_dump_data.txt', '%s');
%data = textread([pwd,'\','memory_dump_data.txt'], '%s');

% data = textread('memory_dump_rd.txt', '%s');
data = hex2dec(data);
index=data>=32768;
data(index)=data(index)-65535;

if ( 0 )
    smpBitsMode = 256;
    sectNum = 16;
    sectBits = 32;
    wordBits = 8;
    sectWords = sectBits/wordBits;
    memoryVol = 2^17;
    smpVol = memoryVol*wordBits/smpBitsMode;
    smpWords = smpBitsMode/wordBits;

    nodeSectVol = sectNum*sectBits/smpBitsMode;

    sectMemoryVol = memoryVol/sectNum/sectWords;

    dataStructMap = zeros(sectNum, sectMemoryVol, sectWords);

    %id=fopen('dataIdx.txt','w');

    for sectIdx=1:sectNum
        for sectVolIdx=1:sectMemoryVol
            for sectWordIdx=1:sectWords
                dataIdx=(sectIdx - 1)*sectMemoryVol*sectWords + (sectVolIdx - 1)*sectWords + sectWordIdx;
                %fprintf(id,'sectIdx=%10d, sectVolIdx=%10d, sectWordIdx=%10d, dataIdx=%10d\n',sectIdx, sectVolIdx, sectWordIdx, dataIdx);
                dataStructMap(sectIdx, sectVolIdx, sectWordIdx) = data((sectIdx - 1)*sectMemoryVol*sectWords + (sectVolIdx - 1)*sectWords + sectWordIdx);
            end
        end
    end

    %fclose(id);

    smpData=zeros(smpVol, smpWords);

    %id2=fopen('sectIdx.txt','w');

    for smpVolIdx=1:smpVol
        if smpVolIdx>2048
            addNum=8;
        else
            addNum=0;
        end
        for smpWordIdx=1:smpWords
            sectIdx=floor((smpWordIdx-1)/sectWords) + 1+addNum;
            sectVolIdx=mod(smpVolIdx - 1,sectMemoryVol)+1;
            sectWordIdx=mod(smpWordIdx - 1, sectWords)+1;
            %fprintf(id2, 'smpVolIdx=%10d, smpWordIdx=%10d',smpVolIdx, smpWordIdx);
            %fprintf(id2, 'sectIdx=%10d, sectVolIdx=%10d, sectWordIdx=%10d\n',sectIdx, sectVolIdx, sectWordIdx);
            smpData(smpVolIdx, smpWordIdx)=dataStructMap(sectIdx,sectVolIdx,sectWordIdx);
        end
    end

    %fclose(id2);
    channel = 0;  %1 for B channel , 0 for A channel
    if channel ==1 
        data_out_i=smpData(:,1:16); %%B channel 
    else
        data_out_i=smpData(:,17:32);
    end
    data_out_q=smpData(:,1:16);
    % data_out_i_v1 = smpData(:,1:16);
    % data_out_i_v2 = 1i * smpData(:,1:16);
    % data_out_i = smpData(:,17:32) + data_out_i_v2;

    data_out_i_full = zeros(1,4096*8);
    for comb = 1:4096
        for i = 1:8
            temp_l = data_out_i(comb,2*i-1);
            temp_h = data_out_i(comb,2*i);
            hex_full = temp_h*2^8 + temp_l;
            if ( hex_full>=2^15 )
                  data_out_i_full(comb*8+i-8) = hex_full -2^16;
            else
                  data_out_i_full(comb*8+i-8) = hex_full;
            end
        end
    end
    data_out_i_full_Ext = data_out_i_full;
    %data_out_i_full = data_out_i_full_Ext(5:16384+4);
    data_temp=[data_out_i_full(5:8:end); ...
        data_out_i_full(6:8:end); ...
        data_out_i_full(7:8:end); ...
        data_out_i_full(8:8:end); ...
        data_out_i_full(1:8:end); ...
        data_out_i_full(2:8:end); ...
        data_out_i_full(3:8:end); ...
        data_out_i_full(4:8:end)];
    % data_temp=[data_out_i_full(4:8:end); ...
    %     data_out_i_full(3:8:end); ...
    %      data_out_i_full(2:8:end); ...
    %      data_out_i_full(1:8:end)];

end
data_out_i_full = data(1:2^16);
data_out_q_full = data(65537:131072);
data_temp=data_out_q_full(1:1:end);
%data_temp=data_out_q_full(1:1:end)
% plot(data_out_i_full(1:4:end),'y'); 
% figure;
% plot(data_out_i_full(1:8:end),'y'); 
% xtemp=data_out_i_full(1:8:end);
% plot(xtemp(1:3:end));hold on;
% plot(xtemp(2:3:end));
% plot(xtemp(3:3:end));
% xtemp2=data_out_i_full(2:8:end); 
% plot(xtemp2(1:3:end));hold on;
% plot(xtemp2(2:3:end));
% plot(xtemp2(3:3:end));
% xtemp3=data_out_i_full(3:8:end); 
% plot(xtemp3(1:3:end));hold on;
% plot(xtemp3(2:3:end));
% plot(xtemp3(3:3:end));
% figure;
% plot(data_out_i_full(1:24:end),'g');  
% hold on;
% plot(data_out_i_full(2:8:end),'m');  
% hold on;
% plot(data_out_i_full(3:8:end),'c');  
% hold on;
% plot(data_out_i_full(4:8:end),'k');  
% hold on;
% plot(data_out_i_full(5:8:end),'r');  
% hold on;
% plot(data_out_i_full(6:8:end),'g');  
% hold on;
% plot(data_out_i_full(7:8:end),'b');  
% hold on;
% plot(data_out_i_full(8:8:end),'r');  

% data_fft = 20*log10(abs(fft(data_i_fft)));
% figure;
% plot(data_fft);
DCM=1
imd_en=0;

figure()
fs = 2.9664e9/DCM;
% para.sigbw=100e6;
% para.dpdbw=300e6;
para.sideband=300;
para.sideband_sig=3e6;
para.fullscale=1200;
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

 if ( imd_en==1 )
perf=fft_calc_imd(data_temp,fs,15,para);
 else
     perf=fft_calc(data_temp,fs,15,para);
 end
 
if (1)
    figure();
    plot(data_temp(1:1:end),'b');
end
 
 
 
% perf=fft_calc(data_temp(1:4:end),fs/4,15,para);
gain2=std(data_temp(1:4:end))/std(data_temp(2:4:end));
gain3=std(data_temp(1:4:end))/std(data_temp(3:4:end));
gain4=std(data_temp(1:4:end))/std(data_temp(4:4:end));

data_temp2=data_temp;
data_temp2(2:4:end)=data_temp2(2:4:end)*gain2;
data_temp2(3:4:end)=data_temp2(3:4:end)*gain3;
data_temp2(4:4:end)=data_temp2(4:4:end)*gain4;
%perf=fft_calc(data_temp2,fs,15,para);

fin=840e6;
corrAC=mean(data_temp(1:4:end-4).*data_temp(3:4:end-4)-data_temp(3:4:end-4).*data_temp(5:4:end));
corrB=mean(data_temp(1:4:end-4).*data_temp(2:4:end-4)-data_temp(2:4:end-4).*data_temp(3:4:end-4));
corrD=mean(data_temp(3:4:end-4).*data_temp(4:4:end-4)-data_temp(4:4:end-4).*data_temp(5:4:end));
skewAC=corrAC/std(data_temp(1:4:end-4))^2/2/pi/fin/sin(2*pi*2*fin/fs);
skewB=corrB/std(data_temp(1:4:end-4))^2/2/pi/fin/sin(2*pi*fin/fs);
skewD=corrD/std(data_temp(1:4:end-4))^2/2/pi/fin/sin(2*pi*fin/fs);
gain234=[gain2 gain3 gain4]
corr=[corrAC corrB corrD]
skew=[skewAC skewB skewD]*1e15
%b=smpData(:,17:32);
