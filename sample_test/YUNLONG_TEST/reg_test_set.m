%%
TEST_CH='rx2'
% BUFF=0;VGA=1;LDO=2 ;BG =3;CK=4;AVDD18=5;AVDDCK =6;AVSS=7;
TEST_CLASS='LDO';
% TEST_CLASS='AVDD18';
% TEST_CLASS='AVDDCK';
% TEST_CLASS='AVSS';
TEST_CLASS='CK';
TEST_CLASS='BG';
TEST_CLASS='BUFF';
TEST_CLASS='VGA';
%%
test_fb0=11;
test_fb1=12;
test_rx0=3;
test_rx1=4;
test_rx2=5;
test_rx3=6;
test_rx4=7;
test_rx5=8;
test_rx6=9;
test_rx7=10;
%%
test_reg_fb0=0;
test_reg_fb1=23;
test_reg_rx0=46;
test_reg_rx1=69;
test_reg_rx2=92;
test_reg_rx3=115;
test_reg_rx4=138;
test_reg_rx5=161;
test_reg_rx6=184;
test_reg_rx7=207;
%%
TEST_BUFF=0;
TEST_VGA=1;
TEST_LDO=2 ;
TEST_BG =3;
TEST_CK=4;
TEST_AVDD18=5;
TEST_AVDDCK =6;
TEST_AVSS=7;
%%

spi_write('0x0', '0x1c9' ,strcat('0x',dec2hex(2^6+2^2*eval(strcat('test_',TEST_CH))))); 

spi_write('0x0', strcat('0x',dec2hex(eval(strcat('test_reg_',TEST_CH)))),strcat('0x',dec2hex(2^23+2^16*eval(strcat('TEST_',TEST_CLASS)))));
%%
if strcmp(TEST_CLASS,'BUFF')
% BUFF 0x07
% <2:1> 9 10 
% TEST SEL
% 0 refp 1p1
% 1 refn 0p75
% 2 refp 0p75
% 3 VCM SIG(输入共模）
% <0>  8
% TEST EN

test_num=0;
test_num=dec2bin(test_num,2);
test_part0=str2num(test_num(2));
test_part1=str2num(test_num(1));
% en
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+7)*32+8,1);
%
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+7)*32+9,test_part0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+7)*32+10,test_part1);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+7)*32+8,0);
end
%%
if strcmp(TEST_CLASS,'VGA')
% VGA op 0xC
% 15：VGA LBW
% 14：DSA LBW
% TEST SEL VGAOP
% 15:
% 14:
% 13:T_VCM
% 12:T_VCM
% 11:T_VCM
% 10:VREF_OUT
% 9:VCMP_MAIN
% 8:VCASP_MAIN
% 7:VCASN_MAIN
% 6:VCMN_MAIN
% 5:VCMP_GB
% 4:VCASP_GB1
% 3:VCASN_GB1
% 2:VCMN_GB
% 1:VCASP_GB
% 0:VCASN_GB
test_num=13;
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+0,test_num==0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+1,test_num==1);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+2,test_num==2);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+3,test_num==3);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+4,test_num==4);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+5,test_num==5);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+6,test_num==6);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+7,test_num==7);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+8,test_num==8);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+9,test_num==9);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+10,test_num==10);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+11,test_num==11);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+12,test_num==12);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+13,test_num==13);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+0,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+1,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+2,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+3,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+4,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+5,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+6,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+7,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+8,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+9,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+10,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+11,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+12,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+12)*32+13,0);
end
%%
if strcmp(TEST_CLASS,'VGA')
% TEST SEL VGA bias 0xB
% 15:100u
% 14/13/12:
% 11:bst vbn
% 10:bst vcasn
% 9:bst vbp
% 8:bst vcasp
% 7:main vbp
% 6:main vcasp
% 5:main vbn
% 4:main vcasn
% 3:input bias n
% 2:input bias n cas
% 1:input bias p
% 0:input bias p cas
test_num=13;
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+2,test_num==0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+3,test_num==1);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+4,test_num==2);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+5,test_num==3);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+6,test_num==4);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+7,test_num==5);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+8,test_num==6);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+9,test_num==7);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+10,test_num==8);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+11,test_num==9);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+12,test_num==10);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+13,test_num==11);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+14,test_num==12);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+15,test_num==13);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+16,test_num==14);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+17,test_num==15);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+2,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+3,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+4,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+5,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+6,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+7,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+8,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+9,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+10,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+11,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+12,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+13,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+14,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+15,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+16,0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+11)*32+17,0);
end
%%
if strcmp(TEST_CLASS,'LDO')
% LDO 0x4
% TEST SEL
% <7> EN group1
% <6> EN group2
% <2:0>
% group1
% 0 1.8
% 1 1.2
% 2 gnd
% 3 AVDD CLK
% 4 AVDD REFP
% 5 AVDD SAR
% 6 VCM
% 7 VCM SAR
% group2
% 0 VREFN SKEW
% 1 VBP
% 2 VCMP MDAC
% 3 VCM_BT
% 4 VCM_BT INTERNAL
% 5 VDS
% 6 IPPN50U
% 7 NA
test_num=0;
test_num=dec2bin(test_num,3);
test_part0=str2num(test_num(3));
test_part1=str2num(test_num(2));
test_part2=str2num(test_num(1));
% en1
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+7,1);
%
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+0,test_part0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+1,test_part1);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+2,test_part2);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+7,0);

test_num=1;
test_num=dec2bin(test_num,3);
test_part0=str2num(test_num(3));
test_part1=str2num(test_num(2));
test_part2=str2num(test_num(1));
% en2
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+6,1);
%
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+0,test_part0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+1,test_part1);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+2,test_part2);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+4)*32+6,0);
end
%%
if strcmp(TEST_CLASS,'BG')
% 0x3
% <7>TEST SEL EN 31
% <6>NA
% <5:4> 29 28
% 0 TEST 1V
% 1 IP10U
% 2 IPT5U
% 3 IPT5U
test_num=0;
test_num=dec2bin(test_num,2);
test_part0=str2num(test_num(2));
test_part1=str2num(test_num(1));
% en
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+3)*32+31,1);
%
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+3)*32+28,test_part0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+3)*32+29,test_part1);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+3)*32+31,0);
end
%%
if strcmp(TEST_CLASS,'CK')
% 0x1
% TEST SEL 
% <3>EN
% <2:0>
% 0 VREFN
% 1 AVSS
% 2 AVDD CLK
% 3 VDAC3
% 4 VDAC2
% 5 VDAC1
% 6 VDAC0
% 7 AVSS
test_num=0;
test_num=dec2bin(test_num,3);
test_part0=str2num(test_num(3));
test_part1=str2num(test_num(2));
test_part2=str2num(test_num(1));
% en
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+1)*32+3,1);
%
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+1)*32+0,test_part0);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+1)*32+1,test_part1);
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+1)*32+2,test_part2);
% close
spi_singlebit((eval(strcat('test_reg_',TEST_CH))+1)*32+3,0);
end

