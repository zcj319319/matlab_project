%% available spec
% performance.OS_mvpp=OS_mvpp;
% performance.SIG1_mvpp=SIG1_mvpp;
% performance.SIG1_dbm=SIG1_dbm;
% performance.SIG1_dbfs=SIG1_dbfs;
%     performance.SIG2_mvpp=SIG2_mvpp;
%     performance.SIG2_dbm=SIG2_dbm;
%     performance.SIG2_dbfs=SIG2_dbfs;
% performance.HD_SIG1_dbc=HD_SIG1_dbc;
%     performance.HD_SIG2_dbc=HD_SIG2_dbc;
%     performance.IMD_dbc=IMD_dbc;
% performance.IL_OS_dbc=IL_OS_dbc;
% performance.IL_OS_dbfs=IL_OS_dbfs;
% performance.IL_GTS_SIG1_dbc=IL_GTS_SIG1_dbc;
%     performance.IL_GTS_SIG2_dbc=IL_GTS_SIG2_dbc;
% performance.SFDR_dbc=SFDR_dbc;
% performance.SFDR_dbfs=SFDR_dbfs;
% performance.FullscalePower=FullscalePower;
% performance.NoiseFloor_dbfs=NoiseFloor_dbfs;
% performance.NoiseVrms=NoiseVrms;
% performance.SNR_dbc=SNR_dbc;
% performance.SNDR_dbc=SNDR_dbc;
% performance.ENOB_dbc=ENOB_dbc;
% performance.SNR_dbfs=SNR_dbfs;
% performance.SNDR_dbfs=SNDR_dbfs;
% performance.ENOB_dbfs=ENOB_dbfs;
% performance.THD_dbc=THD_dbc;
% performance.THD_dbfs=THD_dbfs;
% performance.freq_SIG1=freq_SIG1;
%     performance.freq_SIG2=freq_SIG2;
% performance.freq_HD_SIG1=freq_HD_SIG1;
%     performance.freq_HD_SIG2=freq_HD_SIG2;
%     performance.freq_IMD=freq_IMD;
% performance.freq_IL_OS=freq_IL_OS;
% performance.freq_IL_GTS_SIG1=freq_IL_GTS_SIG1;
%     performance.freq_IL_GTS_SIG2=freq_IL_GTS_SIG2;
% performance.freq_REF_SPUR_SIG1=freq_REF_SPUR_SIG1;
%     performance.freq_REF_SPUR_SIG2=freq_REF_SPUR_SIG2;
% performance.freq_spur=freq_spur;
%%
fsig_set=1e9:500e6:8e9;
fdelta=0e6; % for 2tone test
amp_set=-15;
dsa_set=0;

hd3_array=[];
hd5_array=[];
fsig1_array=[];

for ifsig=1:length(fsig_set)
    for ifdelta=1:length(fdelta)
        for iamp=1:length(amp_set) % adjust amp only at amp phase, not in dsa phase
            for idsa=1:length(dsa_set)
                strfold=strcat('./test_data/',testid,'_',ALG_IND,'_',date,'_',num2str(fref,'%2.3E'),'_',num2str(fs,'%2.3E'),'_',num2str(fsig_set(ifsig),'%2.3E'),'_',num2str(fdelta(ifdelta),'%2.3E'),'_',num2str(amp_set(iamp)),'_',num2str(dsa_set(idsa)));
                load(strcat(strfold,'/matlab.mat'));
                hd3_array=[hd3_array perf.HD_SIG1_dbc(2)];
                hd5_array=[hd5_array perf.HD_SIG1_dbc(4)];
                fsig1_array=[fsig1_array perf.freq_SIG1];
            end
        end
    end
end
figure;plot(fsig1_array,hd3_array);grid on;
% figure;plot(fsig1_array,hd5_array);grid on;