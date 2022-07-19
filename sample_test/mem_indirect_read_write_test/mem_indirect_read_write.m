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

datain = 0;
for i = 1:2^16
    datain1 = datain +1 ;
    datain2 = datain+2;
    total = datain2*2^16 + datain1;
    hex_in = dec2hex(total);
    % spi_write(BASE_ADDR_TOP_MISC, '0x7C', 'deadbeaf'); % manual en on cs 0
   spi_write(BASE_ADDR_TOP_MISC, '0x7C', hex_in); % manual en on cs 0
    datain = datain2;
end


for i = 1:2^16
    spi_write(BASE_ADDR_TOP_MISC, '0x7C', 'deadbeaf'); % manual en on cs 0
end

spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % rgitf offset addr
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x40000'); % rgitf offset addr vld on
spi_write(BASE_ADDR_TOP_MISC, '0x70', '0x0'); % rgitf offset addr

fp = fopen('memory_dump_data.txt', 'w');
    for i=1:20
        read_buffer = spi_read(BASE_ADDR_TOP_MISC, '0x7C', 64);
        for k=1:4:length(read_buffer)
            fprintf(fp, "%02s",read_buffer(k + 0,:));
            fprintf(fp, "%02s",read_buffer(k + 1,:));
            fprintf(fp, "%02s",read_buffer(k + 2,:));
            fprintf(fp, "%02s\n",read_buffer(k + 3,:));
        end
    end
fclose(fp);