addpath(genpath([pwd, '\..\..\']));
load_spi_driver;

regMap;

% close other mem funciton

spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % rgitf off
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x0'); % smp en off
spi_write(BASE_ADDR_TOP_MISC, '0x78', '0x0'); % send en off
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % manual en off

spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x3'); % manual en on bit1 manual write bit0
%spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x6'); % manual en on manual waddr 1
%spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x2'); % manual en on manual waddr 0
spi_write(BASE_ADDR_TOP_MISC, '0x72', '0x8888'); % manual en on cs 0
spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % manual en on cs 0
spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x4'); % manual en on cs 1
spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % manual en on cs 0

spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x2'); % manual en on bit1 manual read bit0
spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x4'); % manual en on cs 1
spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % manual en on cs 0
spi_read(BASE_ADDR_TOP_MISC, '0x73'); % manual en read manual data
