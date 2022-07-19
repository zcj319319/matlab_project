%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4C5" );%rpt_opgain_code ch0
calib.subgec_opgain_code(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4C6" );%rpt_opgain_code ch1
calib.subgec_opgain_code(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4C7" );%rpt_opgain_code ch2
calib.subgec_opgain_code(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4C8" );%rpt_opgain_code ch3
calib.subgec_opgain_code(4)=hex2dec(xtemp(4,:));

xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4C9");%rpt_subgec_coeff_ch0
calib.subgec_coeff(1)=hex2dec(xtemp(4,:))/16;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4CA");%rpt_subgec_coeff_ch1
calib.subgec_coeff(2)=hex2dec(xtemp(4,:))/16;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4CB");%rpt_subgec_coeff_ch2
calib.subgec_coeff(3)=hex2dec(xtemp(4,:))/16;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x4CC");%rpt_subgec_coeff_ch3
calib.subgec_coeff(4)=hex2dec(xtemp(4,:))/16;

%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x44E");%rpt_bkadc_fb3_part1 ch0
    calib.bkgec_coeff_fb3(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x44D");%rpt_bkadc_fb3_part0 ch0
    calib.bkgec_coeff_fb3(1)=(calib.bkgec_coeff_fb3(1)*2^8+hex2dec(xtemp(4,:)))/2^14;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x450");%rpt_bkadc_fb3_part1 ch1
    calib.bkgec_coeff_fb3(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x44F");%rpt_bkadc_fb3_part0 ch1
    calib.bkgec_coeff_fb3(2)=(calib.bkgec_coeff_fb3(2)*2^8+hex2dec(xtemp(4,:)))/2^14;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x452");%rpt_bkadc_fb3_part1 ch2
    calib.bkgec_coeff_fb3(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x451");%rpt_bkadc_fb3_part0 ch2
    calib.bkgec_coeff_fb3(3)=(calib.bkgec_coeff_fb3(3)*2^8+hex2dec(xtemp(4,:)))/2^14;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x454");%rpt_bkadc_fb3_part1 ch3
    calib.bkgec_coeff_fb3(4)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x453");%rpt_bkadc_fb3_part0 ch3
    calib.bkgec_coeff_fb3(4)=(calib.bkgec_coeff_fb3(4)*2^8+hex2dec(xtemp(4,:)))/2^14;
%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x455");%rpt_bkadc_fb2_gaincode ch0
    calib.bkgec_opgain_code(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x456");%rpt_bkadc_fb2_gaincode ch1
    calib.bkgec_opgain_code(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x457");%rpt_bkadc_fb2_gaincode ch2
    calib.bkgec_opgain_code(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x458");%rpt_bkadc_fb2_gaincode ch3
    calib.bkgec_opgain_code(4)=hex2dec(xtemp(4,:));
%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x446");%rpt_bkadc_fb2_part1 ch0
    calib.bkgec_coeff_fb2(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x445");%rpt_bkadc_fb2_part0 ch0
    calib.bkgec_coeff_fb2(1)=(calib.bkgec_coeff_fb2(1)*2^8+hex2dec(xtemp(4,:)))/2^14;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x448");%rpt_bkadc_fb2_part1 ch1
    calib.bkgec_coeff_fb2(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x447");%rpt_bkadc_fb2_part0 ch1
    calib.bkgec_coeff_fb2(2)=(calib.bkgec_coeff_fb2(2)*2^8+hex2dec(xtemp(4,:)))/2^14;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x44A");%rpt_bkadc_fb2_part1 ch2
    calib.bkgec_coeff_fb2(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x449");%rpt_bkadc_fb2_part0 ch2
    calib.bkgec_coeff_fb2(3)=(calib.bkgec_coeff_fb2(3)*2^8+hex2dec(xtemp(4,:)))/2^14;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x44C");%rpt_bkadc_fb2_part1 ch3
    calib.bkgec_coeff_fb2(4)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x44B");%rpt_bkadc_fb2_part0 ch3
    calib.bkgec_coeff_fb2(4)=(calib.bkgec_coeff_fb2(4)*2^8+hex2dec(xtemp(4,:)))/2^14;
%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x406"); %gec_coeff part1 ch0
    calib.gec_coeff(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x405"); %gec_coeff part0 ch0
    calib.gec_coeff(1)=(calib.gec_coeff(1)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x408"); %gec_coeff part1 ch1
    calib.gec_coeff(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x407"); %gec_coeff part0 ch1
    calib.gec_coeff(2)=(calib.gec_coeff(2)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x40A"); %gec_coeff part1 ch2
    calib.gec_coeff(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x409"); %gec_coeff part0 ch2
    calib.gec_coeff(3)=(calib.gec_coeff(3)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x40C"); %gec_coeff part1 ch3
    calib.gec_coeff(4)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x40B"); %gec_coeff part0 ch3
    calib.gec_coeff(4)=(calib.gec_coeff(4)*2^8+hex2dec(xtemp(4,:)))/2^15;
%%
% mdac weight1
for i_ch=1:4
    for j_w=1:8
        addr_l=hex2dec('3c')+(j_w-1)*3+(i_ch-1)*24;
        addr_m=addr_l+1;
        addr_h=addr_l+2;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight1 part2 ch0
    calib.dnc_weight1(i_ch,j_w)=hex2dec(xtemp(4,:))*2^16;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_m))); %dnc_mdac_weight1 part1 ch0
    calib.dnc_weight1(i_ch,j_w)=calib.dnc_weight1(i_ch,j_w)+hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight1 part0 ch0
    calib.dnc_weight1(i_ch,j_w)=(calib.dnc_weight1(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
% mdac weight2
for i_ch=1:4
    for j_w=1:8
        addr_l=hex2dec('9c')+(j_w-1)*2+(i_ch-1)*16;
        addr_h=addr_l+1;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
    calib.dnc_weight2(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
    calib.dnc_weight2(i_ch,j_w)=(calib.dnc_weight2(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
% bkadc weight1
for i_ch=1:4
    for j_w=1:8
        addr_l=hex2dec('dc')+(j_w-1)*2+(i_ch-1)*16;
        addr_h=addr_l+1;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
    calib.dnc_bkweight1(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
    calib.dnc_bkweight1(i_ch,j_w)=(calib.dnc_bkweight1(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
% bkadc weight2
for i_ch=1:4
    for j_w=1:8
        addr_l=hex2dec('11c')+(j_w-1)*2+(i_ch-1)*16;
        addr_h=addr_l+1;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
    calib.dnc_bkweight2(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
    calib.dnc_bkweight2(i_ch,j_w)=(calib.dnc_bkweight2(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
% bkadc weight3
for i_ch=1:4
    for j_w=1:13
        addr_l=hex2dec('15c')+(j_w-1)*2+(i_ch-1)*26;
        addr_h=addr_l+1;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight2 part1 ch0
    calib.dnc_bkweight3(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight2 part0 ch0
    calib.dnc_bkweight3(i_ch,j_w)=(calib.dnc_bkweight3(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
% % mdac dither
% for i_ch=1:4
%     addr_l=hex2dec('1c4')+(i_ch-1)*3;
%     addr_m=addr_l+1;
%     addr_h=addr_l+2;
% xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight1 part2 ch0
%     calib.dnc_dither(i_ch)=hex2dec(xtemp(4,:))*2^16;
% xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_m))); %dnc_mdac_weight1 part1 ch0
%     calib.dnc_dither(i_ch)=calib.dnc_dither(i_ch)+hex2dec(xtemp(4,:))*2^8;
% xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight1 part0 ch0
%     calib.dnc_dither(i_ch)=(calib.dnc_dither(i_ch)+hex2dec(xtemp(4,:)))/2^8;
% end
% mdac OS weight
for i_ch=1:4
    for j_w=1:2
        addr_l=hex2dec('01D')+(j_w-1)*2+(i_ch-1)*4;
%         addr_m=addr_l+1;
        addr_h=addr_l+1;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_h))); %dnc_mdac_weight1 part1 ch0
    calib.dnc_os_weight(i_ch,j_w)=hex2dec(xtemp(4,:))*2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, strcat('0x',dec2hex(addr_l))); %dnc_mdac_weight1 part0 ch0
    calib.dnc_os_weight(i_ch,j_w)=(calib.dnc_os_weight(i_ch,j_w)+hex2dec(xtemp(4,:)))/2^8;
    end
end
%%


xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x527"); %tios_coeff part1 ch0
    calib.tios_coeff(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x526"); %tios_coeff part0 ch0
    calib.tios_coeff(1)=(calib.tios_coeff(1)*2^8+hex2dec(xtemp(4,:)))/2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x529"); %tios_coeff part1 ch1
    calib.tios_coeff(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x528"); %tios_coeff part0 ch1
    calib.tios_coeff(2)=(calib.tios_coeff(2)*2^8+hex2dec(xtemp(4,:)))/2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x52b"); %tios_coeff part1 ch2
    calib.tios_coeff(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x52a"); %tios_coeff part0 ch2
    calib.tios_coeff(3)=(calib.tios_coeff(3)*2^8+hex2dec(xtemp(4,:)))/2^8;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x52d"); %tios_coeff part1 ch3
    calib.tios_coeff(4)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x52c"); %tios_coeff part0 ch3
    calib.tios_coeff(4)=(calib.tios_coeff(4)*2^8+hex2dec(xtemp(4,:)))/2^8;
    
%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x559"); %tigain_coeff part1 ch0
    calib.tigain_coeff(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x558"); %tigain_coeff part0 ch0
    calib.tigain_coeff(1)=(calib.tigain_coeff(1)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x55B"); %tigain_coeff part1 ch1
    calib.tigain_coeff(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x55A"); %tigain_coeff part0 ch1
    calib.tigain_coeff(2)=(calib.tigain_coeff(2)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x55D"); %tigain_coeff part1 ch2
    calib.tigain_coeff(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x55C"); %tigain_coeff part0 ch2
    calib.tigain_coeff(3)=(calib.tigain_coeff(3)*2^8+hex2dec(xtemp(4,:)))/2^15;
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x55F"); %tigain_coeff part1 ch3
    calib.tigain_coeff(4)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x55E"); %tigain_coeff part0 ch3
    calib.tigain_coeff(4)=(calib.tigain_coeff(4)*2^8+hex2dec(xtemp(4,:)))/2^15;
%%
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x58E"); %tiskew_code part1 ch0
    calib.tiskew_code(1)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x58D"); %tiskew_code part0 ch0
    calib.tiskew_code(1)=calib.tiskew_code(1)*2^8+hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x590"); %tiskew_code part1 ch1
    calib.tiskew_code(2)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x58F"); %tiskew_code part0 ch1
    calib.tiskew_code(2)=calib.tiskew_code(2)*2^8+hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x592"); %tiskew_code part1 ch2
    calib.tiskew_code(3)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x591"); %tiskew_code part0 ch2
    calib.tiskew_code(3)=calib.tiskew_code(3)*2^8+hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x594"); %tiskew_code part1 ch3
    calib.tiskew_code(4)=hex2dec(xtemp(4,:));
xtemp=spi_read(BASE_ADDR_CALIB_ALG, "0x593"); %tiskew_code part0 ch3
    calib.tiskew_code(4)=calib.tiskew_code(4)*2^8+hex2dec(xtemp(4,:));