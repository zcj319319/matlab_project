function [performance]=fft_calc_imd(vin,fs,resolution,para)
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
% add HD/IL/IMD/spur threshold

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
% para.num_IMD=5;
% para.window='non';
% para.nyquitst_zone=1;
% para.dacOSR=1;
% para.plot_range=0;
% perf=fft_calc(adc0_dout_single,fs,13,para)
%%
if isfield(para,'sigbw')
    sigbw=para.sigbw;
else
    sigbw=[0 fs/2];
end

if isfield(para,'dc_1f_noise_cancel')
    dc_1f_noise_cancel=para.dc_1f_noise_cancel;
else
    dc_1f_noise_cancel=0;
end      %% add cancel dc  and 1/f noise


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
if isfield(para,'num_IMD')
    num_IMD=para.num_IMD;
else
    num_IMD=5;
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

% num of bins calc into signal/HDx/...
freq_bin=fs/N_fft;
eff_bin=max(3,floor(sideband/freq_bin)); %  at least +/-3bins
eff_bin_sig=max(3,floor(sideband_sig/freq_bin)); %  at least +/-3bins
eff_bin_1f= floor(dc_1f_noise_cancel/freq_bin)+1;   % cancel 1/f noise bin ,not caculate this bin in sfdr and noise


% fft
afft = abs(fft(din(1:N_fft).*w'))/N_fft*2;  % fft/2/N for all bins (except DC)
% 2vpp-> 1 after FFT

mag_full=afft(1:(N_fft/2+1)); % for full plot
mag_all=afft(1:(N_nq/2+1)); % 1 nq zone

index_collect=[]; 
index_center_collect=[]; 

%%
%% DC
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

%% Signal
% sig1
res_index=setdiff([1:(N_nq/2+1)],index_center_collect);  % N_nq+1, include fs/2 tone
[dummy,bx]=max(mag_all(res_index));  % bx is max index in res_index it self
bx=res_index(bx);                    % so get orignal index in res_index
% index_center_spur=bx;

% [dummy,bx] = max(mag_all); % x is magnitude, bx is the positon
index_center_SIG1=bx;
index_SIG1=[max(1,bx-eff_bin_sig):min(bx+eff_bin_sig,N_nq/2)];
index_SIG1=setdiff(index_SIG1,intersect(index_SIG1,index_collect));
pow_SIG1=sum(mag_all(index_SIG1).^2);

index_collect=[index_collect index_SIG1];
index_center_collect=[index_center_collect index_center_SIG1];

% sig2
res_index=setdiff([1:(N_nq/2+1)],index_collect);  % N_nq+1, include fs/2 tone
[dummy,bx]=max(mag_all(res_index));  % bx is max index in res_index it self
bx=res_index(bx);                    % so get orignal index in res_index
% index_center_spur=bx;

% [dummy,bx] = max(mag_all); % x is magnitude, bx is the positon
index_center_SIG2=bx;
index_SIG2=[max(1,bx-eff_bin_sig):min(bx+eff_bin_sig,N_nq/2)];
index_SIG2=setdiff(index_SIG2,intersect(index_SIG2,index_collect));
pow_SIG2=sum(mag_all(index_SIG2).^2);

index_collect=[index_collect index_SIG2];
index_center_collect=[index_center_collect index_center_SIG2];

%% HDs
% sig 1
for n=2:num_HD
    % mirror is folded into baseband
    by=mod(n*(index_center_SIG1-1),N_nq)+1;   % bx-1, because bx is 1...N, after calc HD index, then +1 change to 1...N
    if(by>N_nq/2)
        by=N_nq-(by-1)+1;   % same issue, by-1 change to 0first, after fold, then +1 change to 1first
    end
    
    index_center_HD_SIG1(n-1)=by;
    if ~isempty(intersect(by,index_center_collect))  % if center collide, then disable
        disable_HD_SIG1(n-1)=1;
    else
        disable_HD_SIG1(n-1)=0;
    end
    index_HD_SIG1{n-1}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
    index_HD_SIG1{n-1}=setdiff(index_HD_SIG1{n-1},intersect(index_HD_SIG1{n-1},index_collect));
    
    pow_HD_SIG1(n-1)=sum(mag_all(index_HD_SIG1{n-1}).^2);
    index_collect=[index_collect index_HD_SIG1{n-1}];
    index_center_collect=[index_center_collect index_center_HD_SIG1(n-1)];
end
% sig 2
for n=2:num_HD
    % mirror is folded into baseband
    by=mod(n*(index_center_SIG2-1),N_nq)+1;   % bx-1, because bx is 1...N, after calc HD index, then +1 change to 1...N
    if(by>N_nq/2)
        by=N_nq-(by-1)+1;   % same issue, by-1 change to 0first, after fold, then +1 change to 1first
    end
    
    index_center_HD_SIG2(n-1)=by;
    if ~isempty(intersect(by,index_center_collect))  % if center collide, then disable
        disable_HD_SIG2(n-1)=1;
    else
        disable_HD_SIG2(n-1)=0;
    end
    index_HD_SIG2{n-1}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
    index_HD_SIG2{n-1}=setdiff(index_HD_SIG2{n-1},intersect(index_HD_SIG2{n-1},index_collect));
    
    pow_HD_SIG2(n-1)=sum(mag_all(index_HD_SIG2{n-1}).^2);
    index_collect=[index_collect index_HD_SIG2{n-1}];
    index_center_collect=[index_center_collect index_center_HD_SIG2(n-1)];
end
%% IMDs
for n=2:num_IMD
    for k=1:2*(n-1)
        if mod(k,2)
            m=(k+1)/2;
            by=mod(m*(index_center_SIG1-1)+(n-m)*(index_center_SIG2-1),N_nq)+1;
            % bx-1, because bx is 1...N, after calc HD index, then +1 change to 1...N
        else
            m=k/2;
            by=mod(m*(index_center_SIG1-1)-(n-m)*(index_center_SIG2-1),N_nq)+1;
        end
        if(by>N_nq/2)
            by=N_nq-(by-1)+1;   % same issue, by-1 change to 0first, after fold, then +1 change to 1first
        end
    
        index_center_IMD(n-1,k)=by;
        if ~isempty(intersect(by,index_center_collect))  % if center collide, then disable
            disable_IMD(n-1,k)=1;
        else
            disable_IMD(n-1,k)=0;
        end
        index_IMD{n-1,k}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
        index_IMD{n-1,k}=setdiff(index_IMD{n-1,k},intersect(index_IMD{n-1,k},index_collect));
    
        pow_IMD(n-1,k)=sum(mag_all(index_IMD{n-1,k}).^2);
        index_collect=[index_collect index_IMD{n-1,k}];
        index_center_collect=[index_center_collect index_center_IMD(n-1,k)];
    end
end

%% IL spurs
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

    %sig1
    % gain and skew
    for n=1:2*length(index_center_IL_OS)  % only select IL tones around <= fs/2
        if mod(n,2)
            by=floor((n+1)/2*(N_nq/num_interleave))-(index_center_SIG1-1)+1; % fs/N*k-fin
        else
            by=floor(n/2*(N_nq/num_interleave))+(index_center_SIG1-1)+1;     % fs/N*k+fin
        end
        if by>N_nq/2
            by=N_nq-(by-1)+1;
        end
        if by<1
            by=-(by-1)+1;
        end
        index_center_IL_GTS_SIG1(n)=by;
        if ~isempty(intersect(by,index_center_collect))
            disable_IL_GTS_SIG1(n)=1;
        else
            disable_IL_GTS_SIG1(n)=0;
        end
        index_IL_GTS_SIG1{n}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
        index_IL_GTS_SIG1{n}=setdiff(index_IL_GTS_SIG1{n},intersect(index_IL_GTS_SIG1{n},index_collect));

        pow_IL_GTS_SIG1(n)=sum(mag_all(index_IL_GTS_SIG1{n}).^2);

        index_collect=[index_collect index_IL_GTS_SIG1{n}];
        index_center_collect=[index_center_collect index_center_IL_GTS_SIG1(n)];
    end
    %sig2
    % gain and skew
    for n=1:2*length(index_center_IL_OS)  % only select IL tones around <= fs/2
        if mod(n,2)
            by=floor((n+1)/2*(N_nq/num_interleave))-(index_center_SIG2-1)+1; % fs/N*k-fin
        else
            by=floor(n/2*(N_nq/num_interleave))+(index_center_SIG2-1)+1;     % fs/N*k+fin
        end
        if by>N_nq/2
            by=N_nq-(by-1)+1;
        end
        if by<1
            by=-(by-1)+1;
        end
        index_center_IL_GTS_SIG2(n)=by;
        if ~isempty(intersect(by,index_center_collect))
            disable_IL_GTS_SIG2(n)=1;
        else
            disable_IL_GTS_SIG2(n)=0;
        end
        index_IL_GTS_SIG2{n}=[max(1,by-eff_bin):min(by+eff_bin,N_nq/2)];
        index_IL_GTS_SIG2{n}=setdiff(index_IL_GTS_SIG2{n},intersect(index_IL_GTS_SIG2{n},index_collect));

        pow_IL_GTS_SIG2(n)=sum(mag_all(index_IL_GTS_SIG2{n}).^2);

        index_collect=[index_collect index_IL_GTS_SIG2{n}];
        index_center_collect=[index_center_collect index_center_IL_GTS_SIG2(n)];
    end
end

%% spur
% res_index=setdiff([1:(N_nq/2+1)],index_center_collect);
%res_index=setdiff([1:(N_nq/2+1)],index_collect);
index_collect_1f= [1:eff_bin_1f];
index_collect_sfdr=[index_collect index_collect_1f];
res_index=setdiff([1:(N_nq/2+1)],index_collect_sfdr);  % add delete dc 1/f spur



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


%% noise
pow_noise=sum(mag_all(setdiff([1:(N_nq/2+1)],index_collect)).^2); % integrate only first nyquist(fs/dacOSR/2)
% change from index_center_collect to index_collect, else noise is calced uncorrectly too high

%% calc numbers
OS_mvpp=sqrt(pow_DC)/2 /2*fullscale; % /2 because dc should /N not 2/N, not *2 because no need to change amplitude to vpp
                                    % check plot(abs(fft(ones(1,2048)))/2048)

SIG1_mvpp=sqrt(pow_SIG1)*2/2*fullscale; % *2 from amplitude to vpp, normalize with 2vpp, then * fullscale
SIG1_dbm=10*log10((SIG1_mvpp/1000/2)^2/2/Rl*1000);  % (Vrms)^2=Amplitude^2/2 then/Rl get power
SIG1_dbfs=20*log10(SIG1_mvpp/fullscale);
SIG2_mvpp=sqrt(pow_SIG2)*2/2*fullscale; % *2 from amplitude to vpp, normalize with 2vpp, then * fullscale
SIG2_dbm=10*log10((SIG2_mvpp/1000/2)^2/2/Rl*1000);  % (Vrms)^2=Amplitude^2/2 then/Rl get power
SIG2_dbfs=20*log10(SIG2_mvpp/fullscale);

for n=1:(num_HD-1)
    HD_SIG1_dbc(n)=-10*log10(pow_SIG1/pow_HD_SIG1(n));
end
for n=1:(num_HD-1)
    HD_SIG2_dbc(n)=-10*log10(pow_SIG2/pow_HD_SIG2(n));
end

for n=2:(num_IMD)
    for k=1:2*(n-1)
        IMD_dbc(n-1,k)=-10*log10(pow_SIG1/pow_IMD(n-1,k))+SIG1_dbfs;
    end
end

if num_interleave~=1
    for n=1:length(index_center_IL_OS)
        IL_OS_dbc(n)=-10*log10(pow_SIG1/pow_IL_OS(n));
        IL_OS_dbfs(n)=IL_OS_dbc(n)+SIG1_dbfs;
    end
    for n=1:length(index_center_IL_GTS_SIG1)
        IL_GTS_SIG1_dbc(n)=-10*log10(pow_SIG1/pow_IL_GTS_SIG1(n));
    end
    for n=1:length(index_center_IL_GTS_SIG1)
        IL_GTS_SIG2_dbc(n)=-10*log10(pow_SIG2/pow_IL_GTS_SIG2(n));
    end
else
    IL_OS_dbc=-200;
    IL_OS_dbfs=-200;
    IL_GTS_SIG1_dbc=-200;
    IL_GTS_SIG2_dbc=-200;
end

SFDR_dbc=-10*log10(pow_SIG1/pow_spur);
FullscalePower=10*log10((fullscale/1000/2)^2/2/Rl*1000);
if resolution~=0
    % if ADC, already normalize
    NoiseFloor_dbfs=10*log10(pow_noise)-10*log10(fs/dacOSR/2); % divide first nyquist BW
else
    NoiseFloor_dbfs=10*log10(pow_noise)-10*log10(fs/dacOSR/2)+20*log10(fullscale/2/1000); % noise Amplitude/fullscale Amplitude
end
NoiseVrms=sqrt(pow_noise/2)/2000*fullscale*1e6;    % (A^2)/2 like sin wave
% SNR_dbc=10*log10(pow_SIG/pow_noise);
% SNR_dbfs=10*log10(pow_SIG/pow_noise)-SIG_dbfs;
% ENOB_dbc=(SNR_dbc-1.76)/6.02;
% ENOB_dbfs=(SNR_dbfs-1.76)/6.02;

nq=nyquist_zone;
freq_SIG1=f_trans(index_center_SIG1-1,N_fft,fs,nq);
freq_SIG2=f_trans(index_center_SIG2-1,N_fft,fs,nq);

freq_HD_SIG1=f_trans(index_center_HD_SIG1-1,N_fft,fs,nq);
freq_HD_SIG2=f_trans(index_center_HD_SIG2-1,N_fft,fs,nq);

freq_IMD=f_trans(index_center_IMD-1,N_fft,fs,nq);

if num_interleave~=1
    freq_IL_OS=f_trans(index_center_IL_OS-1,N_fft,fs,nq);
    freq_IL_GTS_SIG1=f_trans(index_center_IL_GTS_SIG1-1,N_fft,fs,nq);
    freq_IL_GTS_SIG2=f_trans(index_center_IL_GTS_SIG2-1,N_fft,fs,nq);
else
    freq_IL_OS=-1;
    freq_IL_GTS_SIG1=-1;
    freq_IL_GTS_SIG2=-1;
end
freq_spur=f_trans(index_center_spur-1,N_fft,fs,nq);
%
performance.OS_mvpp=OS_mvpp;
performance.SIG1_mvpp=SIG1_mvpp;
performance.SIG1_dbm=SIG1_dbm;
performance.SIG1_dbfs=SIG1_dbfs;
performance.SIG2_mvpp=SIG2_mvpp;
performance.SIG2_dbm=SIG2_dbm;
performance.SIG2_dbfs=SIG2_dbfs;
performance.HD_SIG1_dbc=HD_SIG1_dbc;
performance.HD_SIG2_dbc=HD_SIG2_dbc;
performance.IMD_dbc=IMD_dbc;
performance.IL_OS_dbc=IL_OS_dbc;
performance.IL_OS_dbfs=IL_OS_dbfs;
performance.IL_GTS_SIG1_dbc=IL_GTS_SIG1_dbc;
performance.IL_GTS_SIG2_dbc=IL_GTS_SIG2_dbc;
performance.SFDR_dbc=SFDR_dbc;
performance.FullscalePower=FullscalePower;
performance.NoiseFloor_dbfs=NoiseFloor_dbfs;
performance.NoiseVrms=NoiseVrms;
% performance.SNR_dbc=SNR_dbc;
% performance.ENOB_dbc=ENOB_dbc;
% performance.SNR_dbfs=SNR_dbfs;
% performance.ENOB_dbfs=ENOB_dbfs;
performance.freq_SIG1=freq_SIG1;
performance.freq_SIG2=freq_SIG2;
performance.freq_HD_SIG1=freq_HD_SIG1;
performance.freq_HD_SIG2=freq_HD_SIG2;
performance.freq_IMD=freq_IMD;
performance.freq_IL_OS=freq_IL_OS;
performance.freq_IL_GTS_SIG1=freq_IL_GTS_SIG1;
performance.freq_IL_GTS_SIG2=freq_IL_GTS_SIG2;
performance.freq_spur=freq_spur;
%% plot
figure;
if plot_range~=0
    plot_range=min(plot_range,dacOSR);  % for dac, plot more than 1 nq zone, but limit to full zone
    xrange=(0:(N_nq*plot_range)/2)/N_fft*fs+(nq-1)/2*fs/dacOSR;
    plot(xrange,20*log10(mag_full(f_flip((1:(N_nq*plot_range)/2+1),nq))),'color',[.5 .5 .5]);
    axis([xrange([1 end]) -150 90]);
elseif plot_range==0
    xrange=(0:N_fft/2)/N_fft*fs+(nq-1)/2*fs; % for dac plot full zone
    plot(xrange,20*log10(mag_full(f_flip((1:N_fft/2+1),nq))),'color',[.5 .5 .5]);
    axis([xrange([1 end]) -150 90]);
end
title('Freqency domain');
xlabel('Freq.(Hz)');
ylabel('Unit: dB');
grid on;
set(gca,'Ytick',-150:10:90);
hold on;

% sig 
ind=f_trans((index_SIG1-1),N_fft,fs,nq);
plot(ind,20*log10(mag_all(f_flip(index_SIG1,nq))),'b');
ind=f_trans((index_SIG2-1),N_fft,fs,nq);
plot(ind,20*log10(mag_all(f_flip(index_SIG2,nq))),'b');

if isfield(para,'sigbw')
    plot([sigbw(1) sigbw(1)],[-150 90],'color','r','linestyle','--')
    plot([sigbw(2) sigbw(2)],[-150 90],'color','r','linestyle','--')
end
if isfield(para,'dpdbw')
    plot([dpdbw(1) dpdbw(1)],[-150 90],'color','k','linestyle','--')
    plot([dpdbw(2) dpdbw(2)],[-150 90],'color','k','linestyle','--')
end
% HD
for n=2:num_HD
    if disable_HD_SIG1(n-1)~=1
        ind=f_trans((index_HD_SIG1{n-1}-1),N_fft,fs,nq);
        plot(ind,20*log10(mag_all(f_flip(index_HD_SIG1{n-1},nq))),'r');
    end
end
for n=2:num_HD
    if disable_HD_SIG1(n-1)~=1
        ind=f_trans((index_HD_SIG2{n-1}-1),N_fft,fs,nq);
        plot(ind,20*log10(mag_all(f_flip(index_HD_SIG2{n-1},nq))),'r');
    end
end
% IMD
for n=2:num_IMD
    for k=1:2*(n-1)
        if disable_IMD(n-1,k)~=1
            ind=f_trans((index_IMD{n-1,k}-1),N_fft,fs,nq);
            plot(ind,20*log10(mag_all(f_flip(index_IMD{n-1,k},nq))),'color',[.1 .1 .9]);
        end
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
    for n=1:length(index_center_IL_GTS_SIG1)
        if disable_IL_GTS_SIG1(n)~=1
            ind=f_trans((index_IL_GTS_SIG1{n}-1),N_fft,fs,nq);
            plot(ind,20*log10(mag_all(f_flip(index_IL_GTS_SIG1{n},nq))),'m');
        end
    end
    for n=1:length(index_center_IL_GTS_SIG2)
        if disable_IL_GTS_SIG2(n)~=1
            ind=f_trans((index_IL_GTS_SIG2{n}-1),N_fft,fs,nq);
            plot(ind,20*log10(mag_all(f_flip(index_IL_GTS_SIG2{n},nq))),'m');
        end
    end
end
% spur
ind=f_trans((index_spur-1),N_fft,fs,nq);
plot(ind,20*log10(mag_all(f_flip(index_spur,nq))),'c');
%% mark
% sig
text(f_trans((index_center_SIG1-1),N_fft,fs,nq),...
            max(20*log10(mag_all(index_center_SIG1)))+10,...
        {'SIG1';strcat(num2str(freq_SIG1/1e6,'%6.2f'),'MHz')},...
        'FontSize',8)
text(f_trans((index_center_SIG2-1),N_fft,fs,nq),...
            max(20*log10(mag_all(index_center_SIG2)))+10,...
        {'SIG2';strcat(num2str(freq_SIG2/1e6,'%6.2f'),'MHz')},...
        'FontSize',8)
% HD
for n=2:num_HD
    if disable_HD_SIG1(n-1)~=1
        text(f_trans((index_center_HD_SIG1(n-1)-1),N_fft,fs,nq),...
            max(20*log10(mag_all(index_center_HD_SIG1(n-1))))+10,...
        {strcat('SIG1:HD',num2str(n));strcat(num2str(freq_HD_SIG1(n-1)/1e6,'%6.2f'),'MHz')},...
        'FontSize',8);
    end
end
for n=2:num_HD
    if disable_HD_SIG2(n-1)~=1
        text(f_trans((index_center_HD_SIG2(n-1)-1),N_fft,fs,nq),...
            max(20*log10(mag_all(index_center_HD_SIG2(n-1))))+10,...
        {strcat('SIG2:HD',num2str(n));strcat(num2str(freq_HD_SIG2(n-1)/1e6,'%6.2f'),'MHz')},...
        'FontSize',8);
    end
end
% IMD
for n=2:num_IMD
    for k=1:2*(n-1)
        if mod(k,2)
            m=(k+1)/2;
            if disable_IMD(n-1,k)~=1
                text(f_trans((index_center_IMD(n-1,k)-1),N_fft,fs,nq),...
                    max(20*log10(mag_all(index_center_IMD(n-1,k))))+10,...
                {strcat('IMD',num2str(n),':',num2str(m),'f1+',num2str(n-m),'f2');strcat(num2str(freq_IMD(n-1,k)/1e6,'%6.2f'),'MHz')},...
                'FontSize',8);
            end
        else
            m=(k)/2;
            if disable_IMD(n-1,k)~=1
                text(f_trans((index_center_IMD(n-1,k)-1),N_fft,fs,nq),...
                    max(20*log10(mag_all(index_center_IMD(n-1,k))))+10,...
                {strcat('IMD',num2str(n),':',num2str(m),'f1-',num2str(n-m),'f2');strcat(num2str(freq_IMD(n-1,k)/1e6,'%6.2f'),'MHz')},...
                'FontSize',8);
            end
        end
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
    for n=1:length(index_center_IL_GTS_SIG1)
        if disable_IL_GTS_SIG1(n)~=1
            text(f_trans((index_center_IL_GTS_SIG1(n)-1),N_fft,fs,nq),...
                max(20*log10(mag_all(index_center_IL_GTS_SIG1(n))))+10,...
                {strcat('SIG1_ILgts',num2str(n));strcat(num2str(freq_IL_GTS_SIG1(n)/1e6,'%6.2f'),'MHz')},...
                'FontSize',8);
        end
    end
    for n=1:length(index_center_IL_GTS_SIG2)
        if disable_IL_GTS_SIG2(n)~=1
            text(f_trans((index_center_IL_GTS_SIG2(n)-1),N_fft,fs,nq),...
                max(20*log10(mag_all(index_center_IL_GTS_SIG2(n))))+10,...
                {strcat('SIG2_ILgts',num2str(n));strcat(num2str(freq_IL_GTS_SIG2(n)/1e6,'%6.2f'),'MHz')},...
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


performance_str1=strcat('\bfFs:',num2str(fs/1e6,'%6.2f'),'MHz \bfFsig1:',num2str(freq_SIG1/1e6,'%6.2f'),'MHz Amp:',num2str(SIG1_mvpp,'%6.2f'),'mVpp \bfFsig2:',num2str(freq_SIG2/1e6,'%6.2f'),'MHz Amp:',num2str(SIG2_mvpp,'%6.2f'),'mVpp Offset:',num2str(OS_mvpp,'%6.2f'),'mV');
performance_str2=strcat('Sig1Power:',num2str(SIG1_dbm,'%6.2f'),'dBm  Sig1Scale:',num2str(SIG1_dbfs,'%6.2f'),'dBFs Sig2Power:',num2str(SIG2_dbm,'%6.2f'),'dBm  Sig2Scale:',num2str(SIG2_dbfs,'%6.2f'),'dBFs Fullscale:',num2str(FullscalePower,'%6.2f'),'dBm Rl:',num2str(Rl),'Ohm');
performance_str3=[];
for n=2:num_HD
    if disable_HD_SIG1(n-1)~=1
        if HD_SIG1_dbc(n-1)>dbc_th_HD
            performance_str3=[performance_str3,'SIG1HD',num2str(n),':\color[rgb]{1 0 0}',num2str(HD_SIG1_dbc(n-1),'%6.2f'),'dBc \bf\color[rgb]{0 0 0}'];
        else
            performance_str3=[performance_str3,'SIG1HD',num2str(n),':',num2str(HD_SIG1_dbc(n-1),'%6.2f'),'dBc \bf'];
        end
        if mod(n,8)==0
            performance_str3=[performance_str3 newline];
        end
    end
end
performance_str3=[performance_str3 newline];
for n=2:num_HD
    if disable_HD_SIG2(n-1)~=1
        if HD_SIG2_dbc(n-1)>dbc_th_HD
            performance_str3=[performance_str3,'SIG2HD',num2str(n),':\color[rgb]{1 0 0}',num2str(HD_SIG2_dbc(n-1),'%6.2f'),'dBc \bf\color[rgb]{0 0 0}'];
        else
            performance_str3=[performance_str3,'SIG2HD',num2str(n),':',num2str(HD_SIG2_dbc(n-1),'%6.2f'),'dBc \bf'];
        end
        if mod(n,8)==0
            performance_str3=[performance_str3 newline];
        end
    end
end
%
performance_str7=[];
for n=2:num_IMD
    for k=1:2*(n-1)
        if mod(k,2)
            m=(k+1)/2;
            if disable_IMD(n-1,k)~=1
                if IMD_dbc(n-1,k)>dbc_th_IMD
                    performance_str7=[performance_str7,'IMD',num2str(n),':\color[rgb]{1 0 0}',num2str(m),'f1+',num2str(n-m),'f2',':',num2str(IMD_dbc(n-1,k),'%6.2f'),'dBFs \bf\color[rgb]{0 0 0}'];
                else
                    performance_str7=[performance_str7,'IMD',num2str(n),':',num2str(m),'f1+',num2str(n-m),'f2',':',num2str(IMD_dbc(n-1,k),'%6.2f'),'dBFS \bf'];
                end
                if mod(k,8)==0
                    performance_str7=[performance_str7 newline];
                end
            end
        else
            m=(k)/2;
            if disable_IMD(n-1,k)~=1
                if IMD_dbc(n-1,k)>dbc_th_IMD
                    performance_str7=[performance_str7,'IMD',num2str(n),':\color[rgb]{1 0 0}',num2str(m),'f1-',num2str(n-m),'f2',':',num2str(IMD_dbc(n-1,k),'%6.2f'),'dBFs \bf\color[rgb]{0 0 0}'];
                else
                    performance_str7=[performance_str7,'IMD',num2str(n),':',num2str(m),'f1-',num2str(n-m),'f2',':',num2str(IMD_dbc(n-1,k),'%6.2f'),'dBFs \bf'];
                end
                    if mod(k,8)==0
                    performance_str7=[performance_str7 newline];
                end
            end
        end
    end
    if n~=num_IMD
        performance_str7=[performance_str7 newline];
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
    for n=1:length(index_center_IL_GTS_SIG1)
        if disable_IL_GTS_SIG1(n)~=1
            if IL_GTS_SIG1_dbc(n)>dbc_th_IL
                performance_str5=[performance_str5,'SIG1IL_{gts}',num2str(n),':\color[rgb]{1 0 0}',num2str(IL_GTS_SIG1_dbc(n),'%6.2f'),'dBc \bf\color[rgb]{0 0 0}'];
            else
                performance_str5=[performance_str5,'SIG1IL_{gts}',num2str(n),':',num2str(IL_GTS_SIG1_dbc(n),'%6.2f'),'dBc \bf'];
            end
        end
    end
    performance_str5=[performance_str5 newline];
    for n=1:length(index_center_IL_GTS_SIG2)
        if disable_IL_GTS_SIG2(n)~=1
            if IL_GTS_SIG2_dbc(n)>dbc_th_IL
                performance_str5=[performance_str5,'SIG2IL_{gts}',num2str(n),':\color[rgb]{1 0 0}',num2str(IL_GTS_SIG2_dbc(n),'%6.2f'),'dBc \bf\color[rgb]{0 0 0}'];
            else
                performance_str5=[performance_str5,'SIG2IL_{gts}',num2str(n),':',num2str(IL_GTS_SIG2_dbc(n),'%6.2f'),'dBc \bf'];
            end
        end
    end
end
% performance_str6=strcat('SFDR:',num2str(SFDR_dbc,'%6.2f'),'dBc SNR:',num2str(SNR_dbc,'%6.2f'),'dBc/',num2str(SNR_dbfs,'%6.2f'),'dBFs ENOB:',num2str(ENOB_dbc,'%6.2f'),'bit(dBc)/',num2str(ENOB_dbfs,'%6.2f'),'bit(dBFs)');
if SFDR_dbc>dbc_th_SFDR
    performance_str6=strcat('SFDR:\color[rgb]{1 0 0}',num2str(SFDR_dbc,'%6.2f'),'dBc \color[rgb]{0 0 0}NoiseFloor:',num2str(NoiseFloor_dbfs,'%6.2f'),'dBFs NoiseFloor:',num2str(NoiseFloor_dbfs+FullscalePower,'%6.2f'),'dBm NoiseVrms:', num2str(NoiseVrms,'%6.2f'),'uV');
else
    performance_str6=strcat('SFDR:',num2str(SFDR_dbc,'%6.2f'),'dBc NoiseFloor:',num2str(NoiseFloor_dbfs,'%6.2f'),'dBFs NoiseFloor:',num2str(NoiseFloor_dbfs+FullscalePower,'%6.2f'),'dBm NoiseVrms:', num2str(NoiseVrms,'%6.2f'),'uV');
end
% performance_str7=strcat('NoiseFloor:',num2str(NoiseFloor_dbfs,'%6.2f'),'dBFs NoiseFloor:',num2str(NoiseFloor_dbfs+FullscalePower,'%6.2f'),'dBm NoiseVrms:', num2str(NoiseVrms,'%6.2f'),'uV');
if num_interleave~=1
    performance_str={performance_str1;performance_str2;performance_str3;performance_str7;performance_str4;performance_str5;performance_str6};
else
    performance_str={performance_str1;performance_str2;performance_str3;performance_str7;performance_str6};
end
text(xrange(floor(end/20)),90,performance_str,'VerticalAlignment','top');

hold off;

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
