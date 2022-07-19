addpath(genpath([pwd, '\..\..\']));
load_spi_driver;

regMap;

%ip src sel
spi_write('0x10800', '0x0a', '0x4800'); %sel ddc source bit 14 data ch0 bit13 12, nco bit 11; nco00

%if rxadc clk and clk mem freq ok
spi_write(BASE_ADDR_TOP_MISC, '0x01', '0x2'); %sel clk rx_l

%fifo rd vld cfg
spi_write(BASE_ADDR_ANA, '0x360', '0x2084'); %vld 1 cycle 1 dly2

spi_write(BASE_ADDR_ANA, '0x37C', '0x1'); %dbg rd en for rx0

spi_write(BASE_ADDR_ANA, '0x360', '0x2086'); %alarm clr on
spi_write(BASE_ADDR_ANA, '0x360', '0x2084'); %alarm clr off

spi_write(BASE_ADDR_ANA, '0x360', '0x2085'); %fifo en


%other func off
spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % rgitf off
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x0'); % smp en off
spi_write(BASE_ADDR_TOP_MISC, '0x78', '0x0'); % send en off
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % manual en off

%smp cfg
%smp node en 0001
%smp ip sel 000
%smp trig sel 000
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x1E00_0000'); 

%smp node sel
%smp bit num 3
%spi_write(BASE_ADDR_TOP_MISC, '0x75', '0x00C_46DD'); 
spi_write(BASE_ADDR_TOP_MISC, '0x75', '0x0000_0492'); 

%smp start sect
spi_write(BASE_ADDR_TOP_MISC, '0x76', '0x0'); 
%smp end sect
spi_write(BASE_ADDR_TOP_MISC, '0x77', '0x00FF_FFFF'); 

%smp en 1

spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x1E00_0001'); 
%smp trig 1
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x1E00_0021'); 

%rpt smp mem done
spi_read(BASE_ADDR_TOP_MISC, '0x7A'); %3c

%smp trig 0
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x1E00_0001'); 

