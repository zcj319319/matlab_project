%sysref off

%sysref gen on
%sysref_one_shot
%sysref_bypass_num0
spi_write("0xF48", "0x0");
spi_write("0xF30", "0xF"); %sysref posedge sysrefbypass off

spi_write("0xF30", "0x8"); %sysref posedge sysrefbypass off
spi_write("0xF31", "0x9");
spi_write("0x3F8", "0x8");

%sysref domain dly

spi_write("0xF32", "0x1");
spi_write("0xF33", "0x0");
spi_write("0xF34", "0xA");
spi_write("0xF35", "0x0");
spi_write("0xF36", "0xA");
spi_write("0xF37", "0x0");

spi_write("0xF48", "0x1");

%sysref domian selfgen

%sysref on
%sysref off

%sysref gen reset

spi_write("0xF48", "0x0");
spi_write("0xF30", "0xF"); %sysref posedge sysrefbypass on

spi_write("0xF30", "0x8"); %sysref posedge sysrefbypass off
spi_write("0xF31", "0x9");
spi_write("0x3F8", "0x8");

%sysref domain dly

spi_write("0xF32", "0x1");
spi_write("0xF33", "0x0");
spi_write("0xF34", "0xA");
spi_write("0xF35", "0x0");
spi_write("0xF36", "0xA");
spi_write("0xF37", "0x0");

spi_write("0xF48", "0x1");

%sysref on
%sysref off

