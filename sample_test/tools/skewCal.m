
data = textread([pwd,'\','memory_dump_data.txt'], '%s');

% data = textread('memory_dump_rd.txt', '%s');
data = hex2dec(data);

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

data_temp=data_out_i_full(1:1:end);
 
data_i_fft =data_out_i_full(1:24:end);

imd_en=0;

gain2=std(data_temp(1:4:end))/std(data_temp(2:4:end));
gain3=std(data_temp(1:4:end))/std(data_temp(3:4:end));
gain4=std(data_temp(1:4:end))/std(data_temp(4:4:end));

corrAC=mean(data_temp(1:4:end-4).*data_temp(3:4:end-4)-data_temp(3:4:end-4).*data_temp(5:4:end));
corrB=mean(data_temp(1:4:end-4).*data_temp(2:4:end-4)-data_temp(2:4:end-4).*data_temp(3:4:end-4));
corrD=mean(data_temp(3:4:end-4).*data_temp(4:4:end-4)-data_temp(4:4:end-4).*data_temp(5:4:end));
skewAC=corrAC/std(data_temp(1:4:end-4))^2/2/pi/fin/sin(2*pi*2*fin/fs);
skewB=corrB/std(data_temp(1:4:end-4))^2/2/pi/fin/sin(2*pi*fin/fs);
skewD=corrD/std(data_temp(1:4:end-4))^2/2/pi/fin/sin(2*pi*fin/fs);
gain234=[gain2 gain3 gain4]
corr=[corrAC corrB corrD]
skew=[skewAC skewB skewD]*1e15

b=smpData(:,17:32);
