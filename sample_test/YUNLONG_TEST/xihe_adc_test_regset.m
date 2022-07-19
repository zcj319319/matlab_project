%% initial
clear all
close all
addpath(genpath([pwd, '\..\']));
load_spi_driver;
regMap;
% spi_write('0x10100', "0x403", "0x16" ); %cfg_gec_accnum_power2
% spi_write('0x10100', "0x41D"  , "0x1" ); %clr gec error done on
% spi_write('0x10100', "0x41D"  , "0x0" ); %clr gec error done off