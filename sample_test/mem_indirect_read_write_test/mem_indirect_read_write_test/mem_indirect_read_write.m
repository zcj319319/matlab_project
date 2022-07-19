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

for offset_addr = 0:511
    cfg_code = 3 + offset_addr*4;
    cfg_code = dec2hex(cfg_code);
    data = (offset_addr*2 + 1)*2^16 + (offset_addr*2 + 2);
    data_hex = dec2hex(data);
    spi_write(BASE_ADDR_TOP_MISC, '0x70', cfg_code); % manual en on bit1 manual read bit0
    spi_write(BASE_ADDR_TOP_MISC, '0x72', data_hex); % manual data
    spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x4'); % manual en on cs 1
    spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % manual en on cs 0
end

offset_addr=0;
fp = fopen('memory_dump_data.txt', 'w');
for offset_addr = 0:511
    cfg_code = 2 + offset_addr*4;
    cfg_code = dec2hex(cfg_code);
    spi_write(BASE_ADDR_TOP_MISC, '0x70', cfg_code); % manual en on bit1 manual read bit0
    spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x4'); % manual en on cs 1
    spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % manual en on cs 0
    read_buffer = spi_read(BASE_ADDR_TOP_MISC, '0x73'); % manual en read manual data
            fprintf(fp, "%02s",read_buffer(1,:));
            fprintf(fp, "%02s",read_buffer(2,:));
            fprintf(fp, "%02s",read_buffer(3,:));
            fprintf(fp, "%02s\n",read_buffer(4,:));
end
fclose(fp);


spi_write(BASE_ADDR_TOP_MISC, '0x71', '0x0'); % rgitf off
spi_write(BASE_ADDR_TOP_MISC, '0x74', '0x0'); % smp en off
spi_write(BASE_ADDR_TOP_MISC, '0x78', '0x0'); % send en off
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % manual en off
