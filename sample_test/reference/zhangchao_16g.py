from ctypes import *
from time import sleep
# Import module
import ControlSPI

# Scan device
nRet = ControlSPI.VSI_ScanDevice(1)
if(nRet <= 0):
    print("No device connect!")
  #  exit()
else:
    print("Connected device number is:"+repr(nRet))

# Open device
nRet = ControlSPI.VSI_OpenDevice(ControlSPI.VSI_USBSPI,0,0)
if(nRet != ControlSPI.ERR_SUCCESS):
    print("Open device error!")
    #exit()
else:
    print("Open device success!")
# Initialize device
SPI_Init = ControlSPI.VSI_INIT_CONFIG()
SPI_Init.ClockSpeed = 1125000;
SPI_Init.ControlMode = 3;
SPI_Init.CPHA = 0;
SPI_Init.CPOL = 0;
SPI_Init.LSBFirst = 0;
SPI_Init.MasterMode = 1;
SPI_Init.SelPolarity = 0;
SPI_Init.TranBits = 8;

nRet = ControlSPI.VSI_InitSPI(ControlSPI.VSI_USBSPI,0,byref(SPI_Init))
if(nRet != ControlSPI.ERR_SUCCESS):
    print("Initialization device error!")
   # exit()
else:
    print("Initialization device success!")


write_buffer = (c_ubyte * 1024)()
read_buffer = (c_ubyte * 8192)()


#### function define
def read_spi_reg(addr0,addr1):
    write_buffer = (c_ubyte * 2)()
    read_buffer = (c_ubyte * 2)()
    write_buffer[0] = addr0
    write_buffer[1] = addr1
    nRet = ControlSPI.VSI_WriteReadBytes(ControlSPI.VSI_USBSPI, 0, 0, write_buffer, 2, read_buffer, 2)
    return read_buffer

def write_spi_reg(addr0,addr1,data):
    write_buffer = (c_ubyte * 3)()
    read_buffer = (c_ubyte * 2)()
    write_buffer[0] = addr0
    write_buffer[1] = addr1
    write_buffer[2] = data
    nRet = ControlSPI.VSI_WriteBytes(ControlSPI.VSI_USBSPI, 0, 0, write_buffer, 3)

use_full_rate=0;
only_test_serdes_prbs7=0;
test_1611_dcm4=0;
test_1611_dcm5=0;
test_1611_dcm6=0;
test_1611_dcm8=1;
test_1611_dcm10=0;
test_1612=0;
test_1613=0;
test_1614=0;
test_1615=0;
test_1616=0;
test_1621=0;
test_1622=0;
test_1623=0;
test_1624=0;
test_1625=0;
test_1626=0;
test_1627=0;
test_1628=0;#full speed mode
test_fsx4=0;
test_1628_cbit=0;
test_1641=0;
test_1642=0;
test_1643=0;
test_1682=0;
test_1644=0;
test_1645=0;
test_1646=0;
test_1647=0;
test_1681=0;
test_1683=0;
test_1684=0;
test_1685=0;
test_1686=0;
test_1214=0;
test_1223=0;
test_1243=0;
test_0811=0;
test_0812=0;
test_0813=0;
test_0814=0;
test_0815=0;
test_0821=0;
test_0822=0;
test_0823=0;
test_0824=0;
test_0825=0;
test_0826=0;



import os
os.system('D:\projects\DIQUN\diqun_fpga\write\zhangchao\zanalog_set.py')
sleep(0.5)
use_full_rate == 0;
write_spi_reg(0x10, 0x7d, 0x0C)  ## refclk divider div 0x0c=24
write_spi_reg(0x11, 0x48, 0x3c)  ######PLL FBC divider by 0x3c=60
if test_1611_dcm4 == 1:
    use_full_rate == 0;
    write_spi_reg(0x10,0x7d,0x0C)  ## refclk divider div 0x0c=24
    write_spi_reg(0x11,0x48,0x3c) ######PLL FBC divider by 0x3c=60
if test_1611_dcm5 == 1:#有毛刺
    use_full_rate == 0;
    write_spi_reg(0x10, 0x7d, 0x0C)  ## refclk divider div 0x0c=24
    write_spi_reg(0x11, 0x48, 0x30)  ######PLL FBC divider by 0x3c=60
if test_1611_dcm6 == 1:
    use_full_rate == 0;
    write_spi_reg(0x10,0x7d,0x0C)  ## refclk divider div 0x0c=24
    write_spi_reg(0x11,0x48,0x28) ######PLL FBC divider by 0x3c=60
if test_1611_dcm8 == 1:
    use_full_rate == 0;
    write_spi_reg(0x10,0x7d,0x0C)  ## refclk divider div 0x0c=24
    write_spi_reg(0x11,0x48,0x1e) ######PLL FBC divider by 0x3c=60
if test_1611_dcm10 == 1:
    use_full_rate == 1;
    write_spi_reg(0x10,0x7d,0x0C)  ## refclk divider div 0x0c=24
    write_spi_reg(0x11,0x48,0x18) ######PLL FBC divider by 0x3c=60


if use_full_rate == 1:
    os.system('D:\projects\DIQUN\diqun_fpga\write\zhangchao\diqun_serdes_tx_test_PLL_4GHz.py')
else:
    os.system('D:\projects\DIQUN\diqun_fpga\write\zhangchao\diqun_serdes_tx_test_PLL_8GHz.py')

#ffe settings
sleep(0.5)
os.system('D:\projects\DIQUN\diqun_fpga\write\zhangchao\diqun_serdes_tx_test_step1_PRBS7_1tap_onlyFFEsettingsz.py')
sleep(0.5)
if use_full_rate == 1:
    os.system('D:\projects\DIQUN\diqun_fpga\write\zhangchao\diqun_serdes_tx_test_step2_PRBS7_FULLRATE_1TAPz0.py')
else:
    os.system('D:\projects\DIQUN\diqun_fpga\write\zhangchao\diqun_serdes_tx_test_step2_PRBS7_HALFRATE_1TAPz.py')


sleep(0.5)

if only_test_serdes_prbs7==1:
    ###TXREADY bypass
    write_spi_reg(0x10, 0x87, 0x04)
    ####txready enable
    write_spi_reg(0x10, 0x87, 0x0c)
    write_spi_reg(0x10, 0x8d, 0x80)
    write_spi_reg(0x10, 0x97, 0x80)
    write_spi_reg(0x10, 0xa1, 0x80)
    write_spi_reg(0x10, 0xab, 0x80)
    write_spi_reg(0x10, 0xb5, 0x80)
    write_spi_reg(0x10, 0xbf, 0x80)
    write_spi_reg(0x10, 0xc9, 0x80)
    write_spi_reg(0x10, 0xd3, 0x80)
    sleep(1)
    write_spi_reg(0x10, 0x8d, 0xa0)
    write_spi_reg(0x10, 0x97, 0xa0)
    write_spi_reg(0x10, 0xa1, 0xa0)
    write_spi_reg(0x10, 0xab, 0xa0)
    write_spi_reg(0x10, 0xb5, 0xa0)
    write_spi_reg(0x10, 0xbf, 0xa0)
    write_spi_reg(0x10, 0xc9, 0xa0)
    write_spi_reg(0x10, 0xd3, 0xa0)
else:
    write_spi_reg(0x10,0x8d,0x00)#serdes send normal data
    write_spi_reg(0x10,0x97,0x00)
    write_spi_reg(0x10,0xa1,0x00)
    write_spi_reg(0x10,0xab,0x00)
    write_spi_reg(0x10,0xb5,0x00)
    write_spi_reg(0x10,0xbf,0x00)
    write_spi_reg(0x10,0xc9,0x00)
    write_spi_reg(0x10,0xd3,0x00)

    write_spi_reg(0x10, 0x00, 0x00)#reset dig
    write_spi_reg(0x10, 0x00, 0x03)
#analog config ends






#ddc config begins
    ddc_nco_bypass = 1 # use nco test data , not adc source
    if ddc_nco_bypass == 1:

        write_spi_reg(0x03, 0x16, 0x00)#nco 0
        write_spi_reg(0x03, 0x17, 0x55)
        write_spi_reg(0x03, 0x18, 0x55)
        write_spi_reg(0x03, 0x19, 0x55)
        write_spi_reg(0x03, 0x1a, 0x55)
        write_spi_reg(0x03, 0x1b, 0x00)

        write_spi_reg(0x03, 0x36, 0x00)#nco 1
        write_spi_reg(0x03, 0x37, 0x55)
        write_spi_reg(0x03, 0x38, 0x55)
        write_spi_reg(0x03, 0x39, 0x55)
        write_spi_reg(0x03, 0x3a, 0x55)
        write_spi_reg(0x03, 0x3b, 0x00)

        write_spi_reg(0x03, 0x56, 0x00)#nco 2
        write_spi_reg(0x03, 0x57, 0x55)
        write_spi_reg(0x03, 0x58, 0x55)
        write_spi_reg(0x03, 0x59, 0x55)
        write_spi_reg(0x03, 0x5a, 0x55)
        write_spi_reg(0x03, 0x5b, 0x00)

        write_spi_reg(0x03, 0x76, 0x00)#nco 3
        write_spi_reg(0x03, 0x77, 0x55)
        write_spi_reg(0x03, 0x78, 0x55)
        write_spi_reg(0x03, 0x79, 0x55)
        write_spi_reg(0x03, 0x7a, 0x55)
        write_spi_reg(0x03, 0x7b, 0x00)

        write_spi_reg(0x03,0x27,0x00)
        if test_1611_dcm4 == 1:#m and dcm
            write_spi_reg(0x03, 0x10, 0x30)#dcm
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1611_dcm5 == 1:  # m and dcm
            write_spi_reg(0x03, 0x10, 0x37)  # dcm 5
            write_spi_reg(0x03, 0x11, 0xa0)  #
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1611_dcm6 == 1:#m and dcm
            write_spi_reg(0x03, 0x10, 0x34)#dcm 6
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1611_dcm8 == 1:#m and dcm
            write_spi_reg(0x03, 0x10, 0x31)#dcm 8
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1611_dcm10 == 1:#m and dcm
            write_spi_reg(0x03, 0x10, 0x37)#dcm 10
            write_spi_reg(0x03, 0x11, 0x20)  #
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1612 == 1:
            write_spi_reg(0x03, 0x10, 0x30)
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1613 == 1:
            write_spi_reg(0x03, 0x10, 0x33)
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1614 == 1:
            write_spi_reg(0x03, 0x10, 0x33)
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1615 == 1:
            write_spi_reg(0x03, 0x10, 0x37)
            write_spi_reg(0x03, 0x11, 0xf4)
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1616 == 1:
            write_spi_reg(0x03, 0x10, 0x37)
            write_spi_reg(0x03, 0x11, 0xf4)
            write_spi_reg(0x02, 0x00, 0x01)#m
        if test_1621 == 1:
            write_spi_reg(0x03, 0x10, 0x31)
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1622 == 1:
            write_spi_reg(0x03, 0x10, 0x31)
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1623 == 1:
            write_spi_reg(0x03, 0x10, 0x30)#dcm
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1624 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1625 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1626 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1627 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1628 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_fsx4 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x00)  # m
        if test_1628_cbit == 1:
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1641 == 1:
            write_spi_reg(0x03, 0x10, 0x32)  # dcm=16
            write_spi_reg(0x03, 0x30, 0x32)  # dcm=16
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_1642 == 1:
            write_spi_reg(0x03, 0x10, 0x31)  # dcm=8
            write_spi_reg(0x03, 0x30, 0x31)  # dcm=8
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1643 == 1:
            write_spi_reg(0x03, 0x10, 0x31)  # dcm=8
            write_spi_reg(0x03, 0x30, 0x31)  # dcm=8
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1644 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm=4
            write_spi_reg(0x03, 0x30, 0x30)  # dcm=4
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1645 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm=4
            write_spi_reg(0x03, 0x30, 0x30)  # dcm=4
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1646 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x03, 0x30, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1647 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x03, 0x30, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_1681 == 1:
            write_spi_reg(0x03, 0x10, 0x36)  # dcm=24
            write_spi_reg(0x03, 0x30, 0x36)  # dcm=24
            write_spi_reg(0x03, 0x50, 0x36)  # dcm=24
            write_spi_reg(0x03, 0x70, 0x36)  # dcm=24
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1682 == 1:
            write_spi_reg(0x03, 0x10, 0x32)  # dcm=16
            write_spi_reg(0x03, 0x30, 0x32)  #
            write_spi_reg(0x03, 0x50, 0x32)  #
            write_spi_reg(0x03, 0x70, 0x32)  #
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1683 == 1:
            write_spi_reg(0x03, 0x10, 0x31)  # dcm=8
            write_spi_reg(0x03, 0x30, 0x31)  #
            write_spi_reg(0x03, 0x50, 0x31)  #
            write_spi_reg(0x03, 0x70, 0x31)  #
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1684 == 1:
            write_spi_reg(0x03, 0x10, 0x31)  # dcm=8
            write_spi_reg(0x03, 0x30, 0x31)  #
            write_spi_reg(0x03, 0x50, 0x31)  #
            write_spi_reg(0x03, 0x70, 0x31)  #
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1685 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm=4
            write_spi_reg(0x03, 0x30, 0x30)  #
            write_spi_reg(0x03, 0x50, 0x30)  #
            write_spi_reg(0x03, 0x70, 0x30)  #
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1686 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm=4
            write_spi_reg(0x03, 0x30, 0x30)  #
            write_spi_reg(0x03, 0x50, 0x30)  #
            write_spi_reg(0x03, 0x70, 0x30)  #
            write_spi_reg(0x02, 0x00, 0x03)  # m
        if test_1214 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1223 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_1243 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm=4
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_0811 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_0812 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_0813 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_0814 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_0815 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x01)  # m
        if test_0821 == 1:
            write_spi_reg(0x03, 0x10, 0x30)  # dcm=4
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_0822 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_0823 == 1:
            write_spi_reg(0x03, 0x10, 0x33)  # dcm=2
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_0824 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_0825 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x02)  # m
        if test_0826 == 1:
            write_spi_reg(0x03, 0x10, 0x37)  # dcm=1
            write_spi_reg(0x03, 0x11, 0xf4)  # dcm=1
            write_spi_reg(0x02, 0x00, 0x02)  # m

    ddc_test_bypass = 0# is ramp, not sin
    if ddc_test_bypass == 1:
        write_spi_reg(0x03, 0x27, 0x07)
        write_spi_reg(0x02, 0x00, 0x00)
        write_spi_reg(0x03, 0x10, 0x10)
        write_spi_reg(0x03, 0x11, 0x04)
        write_spi_reg(0x05, 0x50, 0x0f)
        write_spi_reg(0x05, 0x50, 0x0f)
        write_spi_reg(0x03, 0x10, 0x37)
        write_spi_reg(0x03, 0x11, 0xf4)

    write_spi_reg(0x03, 0x00, 0x10)#reset nco
    write_spi_reg(0x03, 0x00, 0x00)

#ddc config end







#204b config begins
    write_spi_reg(0x05, 0xf9, 0x02)#sysref_came_delay
    write_spi_reg(0x0f, 0x0d, 0x02)  # 204b clk div

    write_spi_reg(0x05, 0x72, 0x00)

    if test_1611_dcm4 == 1:
        write_spi_reg(0x0f, 0x0d, 0x02)  # 204b clk div
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg


    if test_1611_dcm5 == 1:
        write_spi_reg(0x0f, 0x0d, 0x02)  # 204b clk div
        write_spi_reg(0x0f, 0x0a, 0x01)  # 5/2 clock; divmult2_en
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1611_dcm6 == 1:
        write_spi_reg(0x0f, 0x0d, 0x03)  # 204b clk div
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1611_dcm8 == 1:
        write_spi_reg(0x0f, 0x0d, 0x04)  # 204b clk div
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg


    if test_1611_dcm10 == 1:
        write_spi_reg(0x0f, 0x0d, 0x05)  # 204b clk div
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg


    if test_1612 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)#m_reg
        write_spi_reg(0x05, 0x8c, 0x03)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1613 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)#m_reg
        write_spi_reg(0x05, 0x8c, 0x00)#f_reg
        write_spi_reg(0x05, 0x91, 0x00)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1614 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1615 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)#m_reg
        write_spi_reg(0x05, 0x8c, 0x00)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1616 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x03)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1621 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x03)#f_reg
        write_spi_reg(0x05, 0x91, 0x00)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1622 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x07)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1623 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x00)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1624 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x03)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1625 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x00)#f_reg
        write_spi_reg(0x05, 0x91, 0x00)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1626 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1627 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x00)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1628 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x03)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_fsx4 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x03)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)#n_reg
        write_spi_reg(0x05, 0x90, 0x0f)#n_total_reg
        write_spi_reg(0x0f, 0x0a, 0x01)#5/2 clock; divmult2_en
        write_spi_reg(0x05, 0x70, 0xfe)#enable fsx4 mode in ddc

    if test_1628_cbit == 1:
        write_spi_reg(0x05, 0x8b, 0x87)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)#m_reg
        write_spi_reg(0x05, 0x8c, 0x01)#f_reg
        write_spi_reg(0x05, 0x91, 0x03)#s_reg
        write_spi_reg(0x05, 0x8f, 0x8d)# cs_number,n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg
        write_spi_reg(0x05, 0x59, 0x25)  # cbit:{sigmon,sysref}
        write_spi_reg(0x02, 0x70, 0x01)  # sigmon en


    if test_1641 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)#m_reg
        write_spi_reg(0x05, 0x8c, 0x07)#f_reg
        write_spi_reg(0x05, 0x91, 0x00)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1642 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)#m_reg
        write_spi_reg(0x05, 0x8c, 0x03)#f_reg
        write_spi_reg(0x05, 0x91, 0x00)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1643 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)#scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)#m_reg
        write_spi_reg(0x05, 0x8c, 0x07)#f_reg
        write_spi_reg(0x05, 0x91, 0x01)#s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)# n_reg
        write_spi_reg(0x05, 0x90, 0x0f)# n_total_reg

    if test_1644 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1645 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x03)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1646 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1647 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1681 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x07)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x0f)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1682 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x07)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x07)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg


    if test_1683 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x07)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x03)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1684 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x07)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x07)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg


    if test_1685 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x07)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg


    if test_1686 == 1:
        write_spi_reg(0x05, 0x8b, 0x87)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x07)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x03)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0f)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0f)  # n_total_reg

    if test_1214 == 1:
        write_spi_reg(0x05, 0x8b, 0x82)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0b)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0b)  # n_total_reg


    if test_1223 == 1:
        write_spi_reg(0x05, 0x8b, 0x82)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0b)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0b)  # n_total_reg


    if test_1243 == 1:
        write_spi_reg(0x05, 0x8b, 0x82)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x03)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x0b)  # n_reg
        write_spi_reg(0x05, 0x90, 0x0b)  # n_total_reg


    if test_0811 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0812 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0813 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg


    if test_0814 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x03)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0815 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x00)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x03)  # f_reg
        write_spi_reg(0x05, 0x91, 0x07)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0821 == 1:
        write_spi_reg(0x05, 0x8b, 0x80)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0822 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0823 == 1:
        write_spi_reg(0x05, 0x8b, 0x81)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x00)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0824 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x00)  # f_reg
        write_spi_reg(0x05, 0x91, 0x01)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0825 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x01)  # f_reg
        write_spi_reg(0x05, 0x91, 0x03)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg

    if test_0826 == 1:
        write_spi_reg(0x05, 0x8b, 0x83)  # scr/l_reg
        write_spi_reg(0x05, 0x8e, 0x01)  # m_reg
        write_spi_reg(0x05, 0x8c, 0x03)  # f_reg
        write_spi_reg(0x05, 0x91, 0x07)  # s_reg
        write_spi_reg(0x05, 0x8f, 0x07)  # n_reg
        write_spi_reg(0x05, 0x90, 0x07)  # n_total_reg





    write_spi_reg(0x05, 0x8d, 0x1f)#k_reg
    write_spi_reg(0x05, 0xe4, 0x40)
    write_spi_reg(0x05, 0xb2, 0x45)#lane cross
    write_spi_reg(0x05, 0xb3, 0x76)
    write_spi_reg(0x05, 0xb5, 0x03)
    write_spi_reg(0x05, 0xb6, 0x12)
    write_spi_reg(0x05, 0x77, 0x00)#serdes test pattern

    # sysref adjust
    write_spi_reg(0x0f, 0x31, 0x08)



    write_spi_reg(0x05, 0x71, 0x05)  # long_test, enablemodule
