spi_write(BASE_ADDR_TOP, "0xf18", "0x00");
spi_write(BASE_ADDR_TOP, "0xf16", "0x00");
spi_write(BASE_ADDR_TOP, "0xf1d", "0x1 ");
spi_write(BASE_ADDR_TOP, "0xf1c", "0x1 ");
spi_write(BASE_ADDR_TOP, "0xf16", "0x08");
spi_write(BASE_ADDR_TOP, "0xf17", "0x40");
spi_write(BASE_ADDR_TOP, "0xf19", "0x3c");
spi_write(BASE_ADDR_TOP, "0xf1a", "0x00");
spi_write(BASE_ADDR_TOP, "0xf1b", "0x10");
spi_write(BASE_ADDR_TOP, "0xf1d", "0x0 ");
spi_write(BASE_ADDR_TOP, "0xf1c", "0x0 ");
spi_write(BASE_ADDR_TOP, "0xf18", "0x02");

status = 0;
status = spi_read(BASE_ADDR_TOP,'0xF25');
pause(0.1);
status = 0;
status = spi_read(BASE_ADDR_TOP,'0xF25');

spi_write(BASE_ADDR_TOP, "0xf16", "0x10");
spi_write(BASE_ADDR_TOP, "0xf10", "0x01");
spi_write(BASE_ADDR_TOP, "0xf10", "0x0 ");
spi_write(BASE_ADDR_TOP, "0xf11", "0x0 ");

offset = "00";
data_old = "55";
fp = fopen('memory_dump_data.txt', 'w');
for i=0:31
    data_new = dec2hex(i * 4 + hex2dec(offset));
    spi_write(BASE_ADDR_TOP, "0xf11", data_old);
    spi_write(BASE_ADDR_TOP, "0xf11", data_new);
    read_buffer = spi_read(BASE_ADDR_TOP, "0xF24", 4096);
    for k=1:length(read_buffer)
        fprintf(fp, "%02s\n",read_buffer(k,:));
    end
end
fclose(fp);
