% 首先fsm en
% 各个算法en
% 配置start
% always run 算法配置
%% cfg all alg en
fsm_run=1;
% fsm_run=0;
%% clear all alg
spi_write(BASE_ADDR_CALIB_ALG, "0x666", "0x01ff" );
spi_write(BASE_ADDR_CALIB_ALG, "0x666", "0x00" );
%%
spi_write(BASE_ADDR_CALIB_ALG, "0x000", "0x01" );% fsm en
spi_write(BASE_ADDR_CALIB_ALG, "0x002", "0xA" ); %alg wait 校准间延时等待配置0~46，等待时间2^0~2^46 cycles。 750M时钟对应：1.3ns~1.08天
spi_write(BASE_ADDR_CALIB_ALG, "0x003", "0xA" ); %rnd wait 校准一轮间延时等待配置0~46，等待时间2^0~2^46 cycles。 750M时钟对应：1.3ns~1.08天
spi_write(BASE_ADDR_CALIB_ALG, "0x009", "0x01" ); % dnc run once 
% bit0:DNC
% bit1:GEC
% bit2:BKGEC
% bit3:SUBGEC
% bit4:CHOPPER
% bit5:TIOS
% bit6:TIGAIN
% bit7:TISKEW
spi_write(BASE_ADDR_CALIB_ALG, "0x00B", "0xf3" ); % no first turn jump
%% alg en
cfg_subgec_latest;
cfg_bkgec_latest;
cfg_gec_latest;
cfg_dnc_latest;
cfg_tios_latest;
cfg_tigain_latest;
cfg_tiskew_latest;

%% start
spi_write(BASE_ADDR_CALIB_ALG, "0x006", "0x00" ); % set stop=0
spi_write(BASE_ADDR_CALIB_ALG, "0x001", "0x01" ); % start
%% always run
spi_write(BASE_ADDR_CALIB_ALG, "0x00A", "0x20" ); % tios always on