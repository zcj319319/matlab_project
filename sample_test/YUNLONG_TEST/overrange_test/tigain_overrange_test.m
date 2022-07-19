spi_write(BASE_ADDR_CALIB_ALG, "0x001", "0x00" ); % start
spi_write(BASE_ADDR_CALIB_ALG, "0x000", "0x00" ); % fsm en
%%
tigain.vth_h=floor(4096*0.7);
tigain.vth_l=floor(4096/10);
tigain.vol_h=5; %(1/128)
tigain.vol_l=12; %
tigain.det_vol=12;
%% tigain mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x636"   , "0x00" ); %tigain vth en
%spi_write(BASE_ADDR_CALIB_ALG, "0x638"   , dec2hex(floor(tigain.vth_h/2^8)) ); %tigain high vth part1 5+8bits
%spi_write(BASE_ADDR_CALIB_ALG, "0x637"   , dec2hex(mod(tigain.vth_h,2^8))   ); %tigain high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x638"   , "FFFF" ); %tigain high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x637"   , "FFFF" ); %tigain high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x63a"   , dec2hex(floor(tigain.vth_l/2^8)) ); %tigain low  vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x639"   , dec2hex(mod(tigain.vth_l,2^8))   ); %tigain low  vth part0
%spi_write(BASE_ADDR_CALIB_ALG, "0x63a"   , "0000" ); %tigain low  vth part1 5+8bits
%spi_write(BASE_ADDR_CALIB_ALG, "0x639"   , "00FF" ); %tigain low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x63b"   , dec2hex(tigain.vol_h) ); %tigain high volumn  2^8 1/16
%spi_write(BASE_ADDR_CALIB_ALG, "0x63c"   , dec2hex(tigain.vol_l) ); %tigain low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x63c"   , dec2hex(11)); %tigain low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x63d"   , dec2hex(tigain.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x63e"   , dec2hex(tigain.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x636"   , "0x01" ); %tigain vth en
rpt_calib;
calib
fsm_run = 0;
cfg_tigain_latest;
rpt_calib;