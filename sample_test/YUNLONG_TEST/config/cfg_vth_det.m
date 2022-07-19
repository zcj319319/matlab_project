%%
gec.vth_h=floor(4096*0.7);
gec.vth_l=floor(4096/10);
gec.vol_h=5; %(1/128)
gec.vol_l=12; %
gec.det_vol=12;
%% gec mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x624"   , "0x00" ); %gec vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x626"   , dec2hex(floor(gec.vth_h/2^8)) ); %gec high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x625"   , dec2hex(mod(gec.vth_h,2^8))   ); %gec high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x628"   , dec2hex(floor(gec.vth_l/2^8)) ); %gec low  vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x627"   , dec2hex(mod(gec.vth_l,2^8))   ); %gec low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x629"   , dec2hex(gec.vol_h) ); %gec high volumn  2^8 1/16
spi_write(BASE_ADDR_CALIB_ALG, "0x62a"   , dec2hex(gec.vol_l) ); %gec low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x62b"   , dec2hex(gec.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x62c"   , dec2hex(gec.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x624"   , "0x01" ); %gec vth en
%%
subgec.vth_h=floor(4096*0.7);
subgec.vth_h=floor(4000);
subgec.vth_l=floor(4096/70);
subgec.vol_h=5; %(1/128)
subgec.vol_l=12; %
subgec.det_vol=12;
%% subgec mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x62d"   , "0x00" ); %subgec vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x62f"   , dec2hex(floor(subgec.vth_h/2^8)) ); %subgec high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x62e"   , dec2hex(mod(subgec.vth_h,2^8))   ); %subgec high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x631"   , dec2hex(floor(subgec.vth_l/2^8)) ); %subgec low  vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x630"   , dec2hex(mod(subgec.vth_l,2^8))   ); %subgec low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x633"   , dec2hex(subgec.vol_h) ); %subgec high volumn  2^8 1/16
spi_write(BASE_ADDR_CALIB_ALG, "0x632"   , dec2hex(subgec.vol_l) ); %subgec low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x634"   , dec2hex(subgec.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x635"   , dec2hex(subgec.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x62d"   , "0x01" ); %subgec vth en
%%
bkgec.vth_h=floor(256*0.7);
bkgec.vth_l=floor(256/7);
bkgec.vol_h=5; %(1/128)
bkgec.vol_l=12; %
bkgec.det_vol=12;
%% bkgec mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x61b"   , "0x00" ); %bkgec vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x61d"   , dec2hex(floor(bkgec.vth_h/2^8)) ); %bkgec high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x61c"   , dec2hex(mod(bkgec.vth_h,2^8))   ); %bkgec high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x61f"   , dec2hex(floor(bkgec.vth_l/2^8)) ); %bkgec low  vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x61e"   , dec2hex(mod(bkgec.vth_l,2^8))   ); %bkgec low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x620"   , dec2hex(bkgec.vol_h) ); %bkgec high volumn  2^8 1/16
spi_write(BASE_ADDR_CALIB_ALG, "0x621"   , dec2hex(bkgec.vol_l) ); %bkgec low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x622"   , dec2hex(bkgec.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x623"   , dec2hex(bkgec.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x61b"   , "0x01" ); %bkgec vth en
%%
tios.vth_h=floor(4096*0.7);
% tios.vth_l=floor(256/7);
tios.vol_h=5; %(1/128)
% tios.vol_l=12; %
tios.det_vol=12;
%% tios mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x600"   , "0x00" ); %tios vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x602"   , dec2hex(floor(tios.vth_h/2^8)) ); %tios high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x601"   , dec2hex(mod(tios.vth_h,2^8))   ); %tios high vth part0
% spi_write(BASE_ADDR_CALIB_ALG, "0x604"   , dec2hex(floor(tios.vth_l/2^8)) ); %tios low  vth part1 5+8bits
% spi_write(BASE_ADDR_CALIB_ALG, "0x603"   , dec2hex(mod(tios.vth_l,2^8))   ); %tios low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x605"   , dec2hex(tios.vol_h) ); %tios high volumn  2^8 1/16
% spi_write(BASE_ADDR_CALIB_ALG, "0x606"   , dec2hex(tios.vol_l) ); %tios low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x607"   , dec2hex(tios.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x608"   , dec2hex(tios.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x600"   , "0x01" ); %tios vth en
%%
tigain.vth_h=floor(4096*0.7);
tigain.vth_l=floor(4096/10);
tigain.vol_h=5; %(1/128)
tigain.vol_l=12; %
tigain.det_vol=12;
%% tigain mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x636"   , "0x00" ); %tigain vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x638"   , dec2hex(floor(tigain.vth_h/2^8)) ); %tigain high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x637"   , dec2hex(mod(tigain.vth_h,2^8))   ); %tigain high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x63a"   , dec2hex(floor(tigain.vth_l/2^8)) ); %tigain low  vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x639"   , dec2hex(mod(tigain.vth_l,2^8))   ); %tigain low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x63b"   , dec2hex(tigain.vol_h) ); %tigain high volumn  2^8 1/16
spi_write(BASE_ADDR_CALIB_ALG, "0x63c"   , dec2hex(tigain.vol_l) ); %tigain low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x63d"   , dec2hex(tigain.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x63e"   , dec2hex(tigain.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x636"   , "0x01" ); %tigain vth en
%%
tiskew.vth_h=floor(4096*0.7);
tiskew.vth_l=floor(4096/10);
tiskew.vol_h=5; %(1/128)
tiskew.vol_l=12; %
tiskew.det_vol=12;
%% tiskew mdac/mdac
spi_write(BASE_ADDR_CALIB_ALG, "0x63f"   , "0x00" ); %tiskew vth en
spi_write(BASE_ADDR_CALIB_ALG, "0x641"   , dec2hex(floor(tiskew.vth_h/2^8)) ); %tiskew high vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x640"   , dec2hex(mod(tiskew.vth_h,2^8))   ); %tiskew high vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x643"   , dec2hex(floor(tiskew.vth_l/2^8)) ); %tiskew low  vth part1 5+8bits
spi_write(BASE_ADDR_CALIB_ALG, "0x642"   , dec2hex(mod(tiskew.vth_l,2^8))   ); %tiskew low  vth part0
spi_write(BASE_ADDR_CALIB_ALG, "0x644"   , dec2hex(tiskew.vol_h) ); %tiskew high volumn  2^8 1/16
spi_write(BASE_ADDR_CALIB_ALG, "0x645"   , dec2hex(tiskew.vol_l) ); %tiskew low  volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x646"   , dec2hex(tiskew.det_vol) ); %duration 2^12
spi_write(BASE_ADDR_CALIB_ALG, "0x647"   , dec2hex(tiskew.det_vol) ); %clr volumn
spi_write(BASE_ADDR_CALIB_ALG, "0x63f"   , "0x01" ); %tiskew vth en