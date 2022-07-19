addpath(genpath([pwd, '\..\..\']));
load_spi_driver;

regMap;

% close other mem funciton

spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % rgitf off
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x0'); % smp en off
spi_write(BASE_ADDR_TOP_MISC, '0x78', '0x0'); % send en off
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % manual en off

spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x2'); % rgitf on
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % rgitf offset addr
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x40000'); % rgitf offset addr vld on
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % rgitf offset addr

spi_write(BASE_ADDR_TOP_MISC, '0x7C', '0x88888888'); % manual en on cs 0
spi_write(BASE_ADDR_TOP_MISC, '0x7D', '0x99999999'); % manual en on cs 0

spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % rgitf offset addr
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x40000'); % rgitf offset addr vld on
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % rgitf offset addr

spi_read(BASE_ADDR_TOP_MISC, '0x7C',2); 