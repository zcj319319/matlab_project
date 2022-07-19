function [performance]=fft_calc(vin,fs,resolution,para)
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zhouliren 2020
% - support both adc/dac single tone test 
% - display signals in multiple nyquist zones
% - display signal band/dpd band/full band with different colors
% - calc HDs ILs SFDR separately

% 202006
% change noise integral now with index_collect, else noise is uncorrectly too high
% change HD text plot, now if num_HD too large, HDs will disp in multiple lines
% change Y plot range -150 to 60, change grid with 10db step
% signal sideband and HD/SFDR sideband now can be set seperately
% add HD/IL/spur threshold

% 202108
% add option for ENOB include/not include HD

% 202108
% modify OS/SIG mvpp/NoiseVrms for DAC
% modify NoiseFloordBFs, should be -..fullscalce.., not +

% 20210914
% modify SNDR_dbc for num interleaving==1
% add option for not plot figures;

% 20210928
% add THD

% 20211106
% fix error (when IL OS over threshold, the after text all get red)

% 20211130
% fix bug with din and w not in same dimension(row vector and colum vector)
% else there will be error mention not enough memory

% 20211207
% add figure overwrite to make figure overwrite or new figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vin            input
% fs             total sample rate , for dac, fs=actual dac fs*dacOSR
% resolution     adc resolution,resolution=0 for dac
% sigbw          noise calc bw
% dpdbw          noise calc bw
% sideband       +/-sideband for every tone, default 100KHz
% resolution     adc resolution,resolution=0 for dac
% fullscale      voltage fullscale, mvpp
% Rl             equivalent R load,default 100ohm
% num_interleave 
% num_HD
% window         'non' 'hann' 'black'
% nyquitst_zone  for rfadc, use this to set correct freq range;for dac set to 1 to avoid errors
% dacOSR         for dac simulation only, only HD/IL fold to first nyquist zone will be calc/marked
% plot_range     for dac, 0 'full' zone , 1 first , 2 first+sencond...
%% for adc
% % para.sigbw=100e6;
% % para.dpdbw=300e6;
% para.sideband=300;
% para.sideband_sig=3e6;
% para.fullscale=1000;
% para.Rl=100;
% para.num_interleave=4;
% para.num_HD=5;
% para.window='non';
% para.nyquitst_zone=1;
% para.dacOSR=1;
% para.plot_range=0;
% para.ENOB_include_HD=1;
% para.plot_option=1;
% perf=fft_calc(adc0_dout_single,fs,13,para)
%%
if isfield(para,'sigbw')
    sigbw=para.sigbw;
else
    sigbw=[0 fs/2];
end
if isfield(para,'dpdbw')
    dpdbw=para.dpdbw;
else
    dpdbw=[0 fs/2];
end
if isfield(para,'sideband')
    sideband=para.sideband;
else
    sideband=100e3;
end
if isfield(para,'sideband_sig')
    sideband_sig=para.sideband_sig;
else
    sideband_sig=100e3;
end
if isfield(para,'fullscale')
    fullscale=para.fullscale;
else
    fullscale=1000;
end
if isfield(para,'Rl')
    Rl=para.Rl;
else
    Rl=100;
end
if isfield(para,'num_interleave')
    num_interleave=para.num_interleave;
else
    num_interleave=1;
end
if isfield(para,'num_HD')
    num_HD=para.num_HD;
else
    num_HD=7;
end
if isfield(para,'window')
    window=para.window;
else
    window='non';
end
if isfield(para,'nyquitst_zone')
    nyquist_zone=para.nyquitst_zone;
else
    nyquist_zone=1;
end
if isfield(para,'dacOSR')
    dacOSR=para.dacOSR;
else
    dacOSR=1;
end
if isfield(para,'plot_range')
    plot_range=para.plot_range;
else
    plot_range=0;
end
if isfield(para,'dbc_th_HD')
    dbc_th_HD=para.dbc_th_HD;
else
    dbc_th_HD=-70;
end
if isfield(para,'dbc_th_IMD')
    dbc_th_IMD=para.dbc_th_IMD;
else
    dbc_th_IMD=-70;
end
if isfield(para,'dbc_th_IL')
    dbc_th_IL=para.dbc_th_IL;
else
    dbc_th_IL=-70;
end
if isfield(para,'dbc_th_SFDR')
    dbc_th_SFDR=para.dbc_th_SFDR;
else
    dbc_th_SFDR=-70;
end
if isfield(para,'ENOB_include_HD')
    ENOB_include_HD=para.ENOB_include_HD;
else
    ENOB_include_HD=0;
end
if isfield(para,'plot_option')
    plot_option=para.plot_option;
else
    plot_option=1;
end
if isfield(para,'figure_overwrite')
    figure_overwrite=para.figure_overwrite;
else
    figure_overwrite=0;
end
%%
N_fft=2^floor(log2(length(vin)));
N_nq=N_fft/dacOSR;
% Generate a window variable
if strcmp(window,'non')
    w=1;
end
% w=hodiewindow(N_fft);
if strcmp(window,'hann')
    w=hanning(N_fft)*2/sqrt(3)*sqrt(2);  
end
if strcmp(window,'black')
    w=blackman(N_fft)*2*10^(1.5/20);
end

% normalize input with fullscale
if resolution~=0
    din=vin/2^(resolution-1); % normalize to 2vpp
else
    din=vin;           % dac input
%     fullscale=2000;    %% for dac input, fullscale set to 2000mvpp(default FFT 0dBFs)
end

din=din(:);
w=w(:);

% num of bins calc into signal/HDx/...
freq_bin=fs/N_fft;
eff_bin=max(3,floor(sideband/freq_bin)); %  at least +/-3bins
eff_bin_sig=max(3,floor(sideband_sig/freq_bin)); %  at least +/-3bins

% fft
afft = abs(fft(din(1:N_fft).*w))/N_fft*2;  % fft/2/N for all bins (except DC)
% 2vpp-> 1 after FFT

mag_full=afft(1:(N_fft/2+1)); % for full plot
mag_all=afft(1:(N_nq/2+1)); % 1 nq zone

index_collect=[]; 
index_center_collect=[]; 

%%
% DC
index_center_DC=1;
index_DC=[max(1,1-eff_bin):min(1+eff_bin,N_nq/2)];
pow_DC=sum(mag_all(index_DC).^2);
index_collect=[index_collect index_DC];
index_center_collect=[index_center_collect index_center_DC];

% if next spur center collide to previous one(DC,sig,hd...)
% then the spur is disabled
% if next spur center not collide to previous one(DC,sig,hd...)
% but indexs intersect with previous sets
% then exclude intersetions, but spur is still effective

% Signal
res_index=setdiff([1:(N_nq/2+1)],index_center_collect);  % N_nq+1, include fs/2 tone
[dummy,bx]=max(mag_all(res_index));  % bx is max index in res_index it self
bx=res_index(bx);                    % so get orignal index in res_index
% index_center_spur=bx;

% [dummy,bx] = max(mag_all); % x is magnitude, bx is the positon
index_center_SIG=bx;
index_SIG=[max(1,bx-eff_bin_sig):min(bx+eff_bin_sig,N_nq/2)];
index_SIG=setdiff(index_SIG,intersect(index_SIG,index_collect));
pow_SIG=sum(mag_all(index_SIG).^2);

index_collect=[index_collect index_SIG];
index_center_collect=[index_center_collect index_center_SIG];

% HDs
for n=2:num_HD
    % mirror is folded into baseband
    by=mod(n*(bx-1),N_nq)+1;   % bx-1, because bx is 1...N, after calc HD index, then +1 change to 1...N
    if(by>N_nq/2)
        by=N_nq-(by-1)+1;   % same issue, by-1 change to 0first, after fold, then +1 change to 1first
    end
    
    index_center_HD(n-1)=by;
    if ~isempty(intersect(by,index_center_collect))  % if center collide, then disable
        disable_HD(n-1)=1;
    else
        disable_HD(n-1)=0;
    end
    index_HD{n-1}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
    index_HD{n-1}=setdiff(index_HD{n-1},intersect(index_HD{n-1},index_collect));
    
    pow_HD(n-1)=sum(mag_all(index_HD{n-1}).^2);
    index_collect=[index_collect index_HD{n-1}];
    index_center_collect=[index_center_collect index_center_HD(n-1)];
end

% IL spurs
if num_interleave~=1
    % offset
    index_center_IL_OS=round([N_nq/num_interleave:N_nq/num_interleave:N_nq]+1);  % for N~=2^n, use round to closest tone
    index_center_IL_OS=index_center_IL_OS(index_center_IL_OS<=(N_nq/2+1));     % only select IL tones <= fs/2
    % index_IL_OS=index_center_IL_OS;  % ignore spread of spectrum
    for n=1:length(index_center_IL_OS)
        by=index_center_IL_OS(n);
        if ~isempty(intersect(index_center_IL_OS(n),index_center_collect))
            disable_IL_OS(n)=1;
        else
            disable_IL_OS(n)=0;
        end
        index_IL_OS{n}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2+1)]; % include fs/2 spur
        index_IL_OS{n}=setdiff(index_IL_OS{n},intersect(index_IL_OS{n},index_collect));

        pow_IL_OS(n)=sum(mag_all(index_IL_OS{n}).^2);

        index_collect=[index_collect index_IL_OS{n}];
        index_center_collect=[index_center_collect index_center_IL_OS(n)];
    end


    % gain and skew
    for n=1:2*length(index_center_IL_OS)  % only select IL tones around <= fs/2
        if mod(n,2)
            by=floor((n+1)/2*(N_nq/num_interleave))-(bx-1)+1; % fs/N*k-fin
        else
            by=floor(n/2*(N_nq/num_interleave))+(bx-1)+1;     % fs/N*k+fin
        end
        if by>N_nq/2
            by=N_nq-(by-1)+1;
        end
        if by<1
            by=-(by-1)+1;
        end
        index_center_IL_GTS(n)=by;
        if ~isempty(intersect(by,index_center_collect))
            disable_IL_GTS(n)=1;
        else
            disable_IL_GTS(n)=0;
        end
        index_IL_GTS{n}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
        index_IL_GTS{n}=setdiff(index_IL_GTS{n},intersect(index_IL_GTS{n},index_collect));

        pow_IL_GTS(n)=sum(mag_all(index_IL_GTS{n}).^2);

        index_collect=[index_collect index_IL_GTS{n}];
        index_center_collect=[index_center_collect index_center_IL_GTS(n)];
    end
end

% spur
% res_index=setdiff([1:(N_nq/2+1)],index_center_collect);
res_index=setdiff([1:(N_nq/2+1)],index_collect);
[dummy,bx]=max(mag_all(res_index));  % bx is max index in res_index it self
bx=res_index(bx);                    % so get orignal index in res_index
index_center_spur=bx;
index_spur=[max(1,bx-eff_bin):min(bx+eff_bin,N_nq/2)];
index_spur=setdiff(index_spur,intersect(index_spur,index_collect));
pow_spur=sum(mag_all(index_spur).^2);

index_collect=[index_collect index_spur];
index_center_collect=[index_center_collect index_center_spur];

% if spur index trans to freq not in dpd
% trans dpd bw to index range
% intersect dpd range with res index
% find max spur again


% noise
pow_noise=sum(mag_all(setdiff([1:(N_nq/2+1)],index_collect)).^2); % integrate only first nyquist(fs/dacOSR/2)
% change from index_center_collect to index_collect, else noise is calced uncorrectly too high

%% calc numbers
if resolution~=0
    OS_mvpp=sqrt(pow_DC)/2 /2*fullscale; % /2 because dc should /N not 2/N, not *2 because no need to change amplitude to vpp
                                    % check plot(abs(fft(ones(1,2048)))/2048)

    SIG_mvpp=sqrt(pow_SIG)*2/2*fullscale; % *2 from amplitude to vpp, normalize with 2vpp, then * fullscale
else
    OS_mvpp=sqrt(pow_DC)/2*1000; % for DAC, input is not normalized 
    SIG_mvpp=sqrt(pow_SIG)*2*1000; % so power equals A^2, so 2*A is mvpp 
end
SIG_dbm=10*log10((SIG_mvpp/1000/2)^2/2/Rl*1000);  % (Vrms)^2=Amplitude^2/2 then/Rl get power
SIG_dbfs=20*log10(SIG_mvpp/fullscale);
for n=1:(num_HD-1)
    HD_dbc(n)=-10*log10(pow_SIG/pow_HD(n));
end
if num_interleave~=1
    for n=1:length(index_center_IL_OS)
        IL_OS_dbc(n)=-10*log10(pow_SIG/pow_IL_OS(n));
        IL_OS_dbfs(n)=IL_OS_dbc(n)+SIG_dbfs;
    end
    for n=1:length(index_center_IL_GTS)
        IL_GTS_dbc(n)=-10*log10(pow_SIG/pow_IL_GTS(n));
    end
else
    IL_OS_dbc=-200;
    IL_OS_dbfs=-200;
    IL_GTS_dbc=-200;
end
SFDR_dbc=10*log10(pow_SIG/pow_spur);
SFDR_dbfs=SFDR_dbc-SIG_dbfs;
FullscalePower=10*log10((fullscale/1000/2)^2/2/Rl*1000);
if resolution~=0
    % if ADC, already normalize
    NoiseFloor_dbfs=10*log10(pow_noise)-10*log10(fs/dacOSR/2); % divide first nyquist BW
else
    NoiseFloor_dbfs=10*log10(pow_noise)-10*log10(fs/dacOSR/2)-20*log10(fullscale/2/1000); % noise Amplitude/fullscale Amplitude
end
if resolution~=0
    NoiseVrms=sqrt(pow_noise/2)/2000*fullscale*1e6;    % (A^2)/2 like sin wave
else
    NoiseVrms=sqrt(pow_noise/2)*1e6; % for DAC， normalize not needed
end
SNR_dbc=10*log10(pow_SIG/pow_noise);
SNR_dbfs=10*log10(pow_SIG/pow_noise)-SIG_dbfs;
if num_interleave~=1
    SNDR_dbc=10*log10(pow_SIG/(pow_noise+sum(pow_HD)+sum(pow_IL_OS)+sum(pow_IL_GTS)+pow_spur));
else
    SNDR_dbc=10*log10(pow_SIG/(pow_noise+sum(pow_HD)+pow_spur));
end
THD_dbc=10*log10(pow_SIG/(sum(pow_HD)));
THD_dbfs=THD_dbc-SIG_dbfs;
SNDR_dbfs=SNDR_dbc-SIG_dbfs;
if ENOB_include_HD==0
    ENOB_dbc=(SNR_dbc-1.76)/6.02;
    ENOB_dbfs=(SNR_dbfs-1.76)/6.02;
else
    ENOB_dbc=(SNDR_dbc-1.76)/6.02;
    ENOB_dbfs=(SNDR_dbfs-1.76)/6.02;
end

nq=nyquist_zone;
freq_SIG=f_trans(index_center_SIG-1,N_fft,fs,nq);
freq_HD=f_trans(index_center_HD-1,N_fft,fs,nq);
if num_interleave~=1
    freq_IL_OS=f_trans(index_center_IL_OS-1,N_fft,fs,nq);
    freq_IL_GTS=f_trans(index_center_IL_GTS-1,N_fft,fs,nq);
else
    freq_IL_OS=-1;
    freq_IL_GTS=-1;
end
freq_spur=f_trans(index_center_spur-1,N_fft,fs,nq);
%
performance.OS_mvpp=OS_mvpp;
performance.SIG_mvpp=SIG_mvpp;
performance.SIG_dbm=SIG_dbm;
performance.SIG_dbfs=SIG_dbfs;
performance.HD_dbc=HD_dbc;
performance.IL_OS_dbc=IL_OS_dbc;
performance.IL_OS_dbfs=IL_OS_dbfs;
performance.IL_GTS_dbc=IL_GTS_dbc;
performance.SFDR_dbc=SFDR_dbc;
performance.SFDR_dbfs=SFDR_dbfs;
performance.FullscalePower=FullscalePower;
performance.NoiseFloor_dbfs=NoiseFloor_dbfs;
performance.NoiseVrms=NoiseVrms;
performance.SNR_dbc=SNR_dbc;
performance.SNDR_dbc=SNDR_dbc;
performance.ENOB_dbc=ENOB_dbc;
performance.SNR_dbfs=SNR_dbfs;
performance.SNDR_dbfs=SNDR_dbfs;
performance.ENOB_dbfs=ENOB_dbfs;
performance.THD_dbc=THD_dbc;
performance.THD_dbfs=THD_dbfs;
performance.freq_SIG=freq_SIG;
performance.freq_HD=freq_HD;
performance.freq_IL_OS=freq_IL_OS;
performance.freq_IL_GTS=freq_IL_GTS;
performance.freq_spur=freq_spur;
%% plot
if plot_option==1
    if figure_overwrite==1
        figure(1);
    else
        figure;
    end
    if plot_range~=0
        plot_range=min(plot_range,dacOSR);  % for dac, plot more than 1 nq zone, but limit to full zone
        xrange=(0:(N_nq*plot_range)/2)/N_fft*fs+(nq-1)/2*fs/dacOSR;
        plot(xrange,20*log10(mag_full(f_flip((1:(N_nq*plot_range)/2+1),nq))),'color',[.5 .5 .5]);
        axis([xrange([1 end]) -150 60]);
    elseif plot_range==0
        xrange=(0:N_fft/2)/N_fft*fs+(nq-1)/2*fs; % for dac plot full zone
        plot(xrange,20*log10(mag_full(f_flip((1:N_fft/2+1),nq))),'color',[.5 .5 .5]);
        axis([xrange([1 end]) -150 60]);
    end
    title('Freqency domain');
    xlabel('Freq.(Hz)');
    ylabel('Unit: dB');
    grid on;
    set(gca,'Ytick',-150:10:60);
    hold on;

    % sig 
    ind=f_trans((index_SIG-1),N_fft,fs,nq);
    plot(ind,20*log10(mag_all(f_flip(index_SIG,nq))),'b');

    if isfield(para,'sigbw')
        plot([sigbw(1) sigbw(1)],[-150 60],'color','r','linestyle','--')
        plot([sigbw(2) sigbw(2)],[-150 60],'color','r','linestyle','--')
    end
    if isfield(para,'dpdbw')
        plot([dpdbw(1) dpdbw(1)],[-150 60],'color','k','linestyle','--')
        plot([dpdbw(2) dpdbw(2)],[-150 60],'color','k','linestyle','--')
    end
    % HD
    for n=2:num_HD
        if disable_HD(n-1)~=1
            ind=f_trans((index_HD{n-1}-1),N_fft,fs,nq);
            plot(ind,20*log10(mag_all(f_flip(index_HD{n-1},nq))),'r');
        end
    end
    % IL
    if num_interleave~=1
        % os
        for n=1:length(index_center_IL_OS)
            if disable_IL_OS(n)~=1
                ind=f_trans((index_IL_OS{n}-1),N_fft,fs,nq);
                plot(ind,20*log10(mag_all(f_flip(index_IL_OS{n},nq))),'g');
            end
        end
        % gain
        for n=1:length(index_center_IL_GTS)
            if disable_IL_GTS(n)~=1
                ind=f_trans((index_IL_GTS{n}-1),N_fft,fs,nq);
                plot(ind,20*log10(mag_all(f_flip(index_IL_GTS{n},nq))),'m');
            end
        end
    end
    % spur
    ind=f_trans((index_spur-1),N_fft,fs,nq);
    plot(ind,20*log10(mag_all(f_flip(index_spur,nq))),'c');
    %% mark
    % sig
    text(f_trans((index_center_SIG-1),N_fft,fs,nq),...
                max(20*log10(mag_all(index_center_SIG)))+10,...
            {'SIG';strcat(num2str(freq_SIG/1e6,'%6.2f'),'MHz')},...
            'FontSize',8)
    % HD
    for n=2:num_HD
        if disable_HD(n-1)~=1
            text(f_trans((index_center_HD(n-1)-1),N_fft,fs,nq),...
                max(20*log10(mag_all(index_center_HD(n-1))))+10,...
            {strcat('HD',num2str(n));strcat(num2str(freq_HD(n-1)/1e6,'%6.2f'),'MHz')},...
            'FontSize',8);
        end
    end
    % IL
    if num_interleave~=1
        % os
        for n=1:length(index_center_IL_OS)
            if disable_IL_OS(n)~=1
                text(f_trans((index_center_IL_OS(n)-1),N_fft,fs,nq),...
                    max(20*log10(mag_all(index_center_IL_OS(n))))+10,...
                    {strcat('ILos',num2str(n));strcat(num2str(freq_IL_OS(n)/1e6,'%6.2f'),'MHz')},...
                    'FontSize',8);
            end
        end
        % gain and skew
        for n=1:length(index_center_IL_GTS)
            if disable_IL_GTS(n)~=1
                text(f_trans((index_center_IL_GTS(n)-1),N_fft,fs,nq),...
                    max(20*log10(mag_all(index_center_IL_GTS(n))))+10,...
                    {strcat('ILgts',num2str(n));strcat(num2str(freq_IL_GTS(n)/1e6,'%6.2f'),'MHz')},...
                    'FontSize',8);
            end
        end
    end
    % spur
    text(f_trans((index_center_spur-1),N_fft,fs,nq),...
                max(20*log10(mag_all(index_center_spur)))+10,...
                {'Spur';strcat(num2str(freq_spur/1e6,'%6.2f'),'MHz')},...
                'FontSize',8);
    %


    performance_str1=strcat('\bfFs:',num2str(fs/1e6,'%6.2f'),'MHz \bfFrequcy:',num2str(freq_SIG/1e6,'%6.2f'),'MHz Amplitude:',num2str(SIG_mvpp,'%6.2f'),'mVpp Offset:',num2str(OS_mvpp,'%6.2f'),'mV');
    performance_str2=strcat('SigPower:',num2str(SIG_dbm,'%6.2f'),'dBm Rl:',num2str(Rl),'Ohm SigScale:',num2str(SIG_dbfs,'%6.2f'),'dBFs Fullscale:',num2str(FullscalePower,'%6.2f'),'dBm');
    performance_str3=[];
    for n=2:num_HD
        if disable_HD(n-1)~=1
            if HD_dbc(n-1)>dbc_th_HD
                performance_str3=[performance_str3,'HD',num2str(n),':\color[rgb]{1 0 0}',num2str(HD_dbc(n-1),'%6.2f'),'dBc \bf\color[rgb]{0 0 0}'];
            else
                performance_str3=[performance_str3,'HD',num2str(n),':',num2str(HD_dbc(n-1),'%6.2f'),'dBc \bf'];
            end
            if mod(n,6)==0
                performance_str3=[performance_str3 newline];
            end
        end
    end
    if num_interleave~=1
        performance_str4=[];
        for n=1:length(index_center_IL_OS)
            if disable_IL_OS(n)~=1
                if IL_OS_dbc(n)>dbc_th_IL
                    performance_str4=strcat(performance_str4,'IL_{os}',num2str(n),':\color[rgb]{1 0 0}',num2str(IL_OS_dbc(n),'%6.2f'),'dBc/',num2str(IL_OS_dbfs(n),'%6.2f'),'dBFs \bf\color[rgb]{0 0 0}');
                else  
                    performance_str4=strcat(performance_str4,'IL_{os}',num2str(n),':',num2str(IL_OS_dbc(n),'%6.2f'),'dBc/',num2str(IL_OS_dbfs(n),'%6.2f'),'dBFs \bf');
                end
            end
        end
        performance_str5=[];
        for n=1:length(index_center_IL_GTS)
            if disable_IL_GTS(n)~=1
                if IL_GTS_dbc(n)>dbc_th_IL
                    performance_str5=strcat(performance_str5,'IL_{gts}',num2str(n),':\color[rgb]{1 0 0}',num2str(IL_GTS_dbc(n),'%6.2f'),'dBc \bf\color[rgb]{0 0 0}');
                else
                    performance_str5=strcat(performance_str5,'IL_{gts}',num2str(n),':',num2str(IL_GTS_dbc(n),'%6.2f'),'dBc \bf');
                end
            end
        end
    end
    if SFDR_dbc>dbc_th_SFDR
        performance_str6=strcat('SFDR:\color[rgb]{1 0 0}',num2str(SFDR_dbc,'%6.2f'),'dBc \color[rgb]{0 0 0}SNR:',num2str(SNR_dbc,'%6.2f'),'dBc/',num2str(SNR_dbfs,'%6.2f'),'dBFs ENOB:',num2str(ENOB_dbc,'%6.2f'),'bit(dBc)/',num2str(ENOB_dbfs,'%6.2f'),'bit(dBFs)');
    else
        performance_str6=strcat('SFDR:',num2str(SFDR_dbc,'%6.2f'),'dBc SNR:',num2str(SNR_dbc,'%6.2f'),'dBc/',num2str(SNR_dbfs,'%6.2f'),'dBFs ENOB:',num2str(ENOB_dbc,'%6.2f'),'bit(dBc)/',num2str(ENOB_dbfs,'%6.2f'),'bit(dBFs)');
    end
    performance_str7=strcat('NoiseFloor:',num2str(NoiseFloor_dbfs,'%6.2f'),'dBFs NoiseFloor:',num2str(NoiseFloor_dbfs+FullscalePower,'%6.2f'),'dBm NoiseVrms:', num2str(NoiseVrms,'%6.2f'),'uV');
    if num_interleave~=1
        performance_str={performance_str1;performance_str2;performance_str3;performance_str4;performance_str5;performance_str6;performance_str7};
    else
        performance_str={performance_str1;performance_str2;performance_str3;performance_str6;performance_str7};
    end
    text(xrange(floor(end/20)),55,performance_str,'VerticalAlignment','top');

    hold off;

end  % plot option end

% nyquist zone trans
% change fft index to real frequency
% if nq~=1, change to according nyquist zone
% for dac, sinc effect exist, so only use f_trans and mag at 1st nq zone
% do not get correct frequency plot at 2nd/3rd... nq zones
function out=f_trans(in,N_fft,fs,nq) % for dac nq=1 so no modification for now...
if mod(nq,2)
    out=in/N_fft*fs+(nq-1)/2*fs;
else
    out=nq/2*fs-in/N_fft*fs;
end
function out=f_flip(in,nq)
if mod(nq,2)
    out=in;
else
    out=fliplr(in);
end
% 随着采样点的则加，离散的和就会增大实际上正确的办法是求和时要乘上采样的间隔，
% 就是积分区间/N对于很多离散的积分算法，例如卷积，最后结果都要除以采样点数N才能得到正确结果
% 而傅立叶变化也是一种积分变换，所以得到的结果就要除以N，才是正确的而变换后的频谱
% 通常将0频移到中间，分为对称的为正负频率（模对称，幅角反对称）有时表示频谱的时候只需要用其一半正频率部分就够了
% 所以除以N之后还要乘以2，表示把正负频率的加在一起
% 而0频的直流分量，本身在对称点，已经是正负相加过的，所以只用除以N.