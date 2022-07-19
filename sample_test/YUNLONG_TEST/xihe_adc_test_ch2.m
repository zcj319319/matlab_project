
%% bkgec
% spi_write('0x11100', "0x473"   , "0x60" ); %bkgec coeff ideal part1
% spi_write('0x11100', "0x472"   , "0x00" ); %bkgec coeff ideal part0
% spi_write('0x11100', "0x443"   , "0x14" ); %accnum_power2
% spi_write('0x11100', "0x440"   , "0x01" ); %bkgec_en
% 
%     
% while(1)
%     xtemp=spi_read('0x11100', "0x441" );%rpt_bkgec_done
%     done=hex2dec(xtemp(4,:));
%     if done~=0
%         break
%     else
%         pause(0.01);
%     end
% end
% spi_write('0x11100', "0x440"   , "0x00" ); %bkgec_en off
% %%
% for i_ch=1:4
%     for j_w=1:8
%         addr_l=hex2dec('dc')+(j_w-1)*2+(i_ch-1)*16;
%         addr_h=addr_l+1;
% xtemp=spi_read('0x11100', strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
%     calib.dnc_bkweight1(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
% xtemp=spi_read('0x11100', strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
%     calib.dnc_bkweight1(i_ch,j_w)=(calib.dnc_bkweight1(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
%     end
% end
% % bkadc weight2
% for i_ch=1:4
%     for j_w=1:8
%         addr_l=hex2dec('11c')+(j_w-1)*2+(i_ch-1)*16;
%         addr_h=addr_l+1;
% xtemp=spi_read('0x11100', strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
%     calib.dnc_bkweight2(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
% xtemp=spi_read('0x11100', strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
%     calib.dnc_bkweight2(i_ch,j_w)=(calib.dnc_bkweight2(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
%     end
% end
% % bkadc weight3
% for i_ch=1:4
%     for j_w=1:8
%         addr_l=hex2dec('15c')+(j_w-1)*2+(i_ch-1)*16;
%         addr_h=addr_l+1;
% xtemp=spi_read('0x11100', strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
%     calib.dnc_bkweight3(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
% xtemp=spi_read('0x11100', strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
%     calib.dnc_bkweight3(i_ch,j_w)=(calib.dnc_bkweight3(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
%     end
% end
% calib.dnc_bkweight1
% calib.dnc_bkweight2
% calib.dnc_bkweight3


%% gec
spi_write('0x11100', "0x400", "0x1" ); %ctrl_gec_en
pause(1); 
spi_write('0x11100', "0x400", "0x0" ); %ctrl_gec_en off
xtemp=spi_read('0x11100', "0x406"); %gec_coeff part1 ch0
    calib.gec_coeff(1)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x405"); %gec_coeff part0 ch0
    calib.gec_coeff(1)=(calib.gec_coeff(1)*2^8+hex2dec(xtemp(4,:)))/2^15;


xtemp=spi_read('0x11100', "0x408"); %gec_coeff part1 ch0
    calib.gec_coeff(2)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x407"); %gec_coeff part0 ch0
    calib.gec_coeff(2)=(calib.gec_coeff(2)*2^8+hex2dec(xtemp(4,:)))/2^15;


xtemp=spi_read('0x11100', "0x40a"); %gec_coeff part1 ch0
    calib.gec_coeff(3)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x409"); %gec_coeff part0 ch0
    calib.gec_coeff(3)=(calib.gec_coeff(3)*2^8+hex2dec(xtemp(4,:)))/2^15;


xtemp=spi_read('0x11100', "0x40c"); %gec_coeff part1 ch0
    calib.gec_coeff(4)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x40b"); %gec_coeff part0 ch0
    calib.gec_coeff(4)=(calib.gec_coeff(4)*2^8+hex2dec(xtemp(4,:)))/2^15;
calib
%%
%% ti os
spi_write('0x11100', "0x523", "0x00" ); %cfg_tios_refch_sel 0 no ref;1~4: refch0~3
spi_write('0x11100', "0x524", "0x16" ); %cfg_tios_accnum_power2

% spi_write('0x11100', "0x53E"  , "0x1" ); %clr tios error done on
% spi_write('0x11100', "0x53E"  , "0x0" ); %clr tios error done off

spi_write('0x11100', "0x520"   , "0x01" ); %tios_en

  
while(1)
    xtemp=spi_read('0x11100', "0x522");%wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end

spi_write('0x11100', "0x520" , "0x0" ); %tios_off



xtemp=spi_read('0x11100', "0x527"); %tios_coeff part1 ch0
    calib.tios_coeff(1)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x526"); %tios_coeff part0 ch0
    calib.tios_coeff(1)=(calib.tios_coeff(1)*2^8+hex2dec(xtemp(4,:)))/2^8;
xtemp=spi_read('0x11100', "0x529"); %tios_coeff part1 ch1
    calib.tios_coeff(2)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x528"); %tios_coeff part0 ch1
    calib.tios_coeff(2)=(calib.tios_coeff(2)*2^8+hex2dec(xtemp(4,:)))/2^8;
xtemp=spi_read('0x11100', "0x52b"); %tios_coeff part1 ch2
    calib.tios_coeff(3)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x52a"); %tios_coeff part0 ch2
    calib.tios_coeff(3)=(calib.tios_coeff(3)*2^8+hex2dec(xtemp(4,:)))/2^8;
xtemp=spi_read('0x11100', "0x52d"); %tios_coeff part1 ch3
    calib.tios_coeff(4)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x52c"); %tios_coeff part0 ch3
    calib.tios_coeff(4)=(calib.tios_coeff(4)*2^8+hex2dec(xtemp(4,:)))/2^8;
calib
%% ti 
spi_write('0x11100', "0x56f", "0x01" ); %cfg_ti_distort_filter_bypass

spi_write('0x11100', "0x553", "0x18" ); %tigain_accnum_power2

% spi_write('0x11100', "0x571"  , "0x1" ); %clr tigain error done on
% spi_write('0x11100', "0x571"  , "0x0" ); %clr tigain error done off
spi_write('0x11100', "0x554", "0x00" ); %tigain_cal_mode
spi_write('0x11100', "0x557", "0x00" ); %round,must be 0 when mode=0
spi_write('0x11100', "0x555", "0x1e" ); %cfg_tigain_filter_phase_dly

spi_write('0x11100', "0x556", "0x08" ); %wait cycle power2

spi_write('0x11100', "0x550"   , "0x01" ); %tigain_en

while(1)
    xtemp=spi_read('0x11100', "0x551");%wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write('0x11100', "0x550" , "0x0" ); %tigain_off

xtemp=spi_read('0x11100', "0x559"); %tigain_coeff part1 ch0
    calib.tigain_coeff(1)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x558"); %tigain_coeff part0 ch0
    calib.tigain_coeff(1)=(calib.tigain_coeff(1)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read('0x11100', "0x55B"); %tigain_coeff part1 ch1
    calib.tigain_coeff(2)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x55A"); %tigain_coeff part0 ch1
    calib.tigain_coeff(2)=(calib.tigain_coeff(2)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read('0x11100', "0x55D"); %tigain_coeff part1 ch2
    calib.tigain_coeff(3)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x55C"); %tigain_coeff part0 ch2
    calib.tigain_coeff(3)=(calib.tigain_coeff(3)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read('0x11100', "0x55F"); %tigain_coeff part1 ch3
    calib.tigain_coeff(4)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x55E"); %tigain_coeff part0 ch3
    calib.tigain_coeff(4)=(calib.tigain_coeff(4)*2^8+hex2dec(xtemp(4,:)))/2^15;
calib
%% ti skew
spi_write('0x11100', "0x583", "0x18" ); %tiskew_accnum_power2
spi_write('0x11100', "0x587", "0x09" ); %tiskew_cal_rounds_power2

spi_write('0x11100', "0x588", "0x01" ); %cfg_tiskew_code_step

spi_write('0x11100', "0x58A", "0x01" ); %tiskew_auto_direction_en
spi_write('0x11100', "0x58B", "0x08" ); %tiskew reverse count
spi_write('0x11100', "0x584", "0x00" ); %tiskew_cal mode
spi_write('0x11100', "0x585", "0x1e" ); %cfg_tiskew_filter_phase_dly

spi_write('0x11100', "0x5A6", "0x1" ); %clr tiskew error done on
spi_write('0x11100', "0x5A6", "0x0" ); %clr tiskew error done off

spi_write('0x11100', "0x580"   , "0x01" ); %tiskew_en

    
while(1)
    xtemp=spi_read('0x11100', "0x581");%wait done
    done=hex2dec(xtemp(4,:));
    if done~=0
        break
    else
        pause(0.01);
    end
end
spi_write('0x11100', "0x580" , "0x0" ); %tiskew_off


xtemp=spi_read('0x11100', "0x58E"); %tiskew_code part1 ch0
    calib.tiskew_code(1)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x58D"); %tiskew_code part0 ch0
    calib.tiskew_code(1)=calib.tiskew_code(1)*2^8+hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x590"); %tiskew_code part1 ch1
    calib.tiskew_code(2)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x58F"); %tiskew_code part0 ch1
    calib.tiskew_code(2)=calib.tiskew_code(2)*2^8+hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x592"); %tiskew_code part1 ch2
    calib.tiskew_code(3)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x591"); %tiskew_code part0 ch2
    calib.tiskew_code(3)=calib.tiskew_code(3)*2^8+hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x594"); %tiskew_code part1 ch3
    calib.tiskew_code(4)=hex2dec(xtemp(4,:));
xtemp=spi_read('0x11100', "0x593"); %tiskew_code part0 ch3
    calib.tiskew_code(4)=calib.tiskew_code(4)*2^8+hex2dec(xtemp(4,:));
    calib;


