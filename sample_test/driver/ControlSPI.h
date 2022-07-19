/**
  ******************************************************************************
  * @file    ControlSPI.h
  * $Author: viewtool $
  * $Revision: 447 $
  * $Date:: 2020-06-02 18:24:57 +0800 #$
  * @brief   Ginkgo USB-SPI�������ײ�������API��������.
  ******************************************************************************
  * @attention
  *
  *<h3><center>&copy; Copyright 2009-2012, ViewTool</center>
  *<center><a href="http:\\www.viewtool.com">http://www.viewtool.com</a></center>
  *<center>All Rights Reserved</center></h3>
  * 
  ******************************************************************************
  */
#ifndef _CONTROLSPI_H_
#define _CONTROLSPI_H_

#include <stdint.h>
#include "ErrorType.h"
#ifndef OS_UNIX
#include <Windows.h>
#else
#include <unistd.h>
#ifndef WINAPI
#define WINAPI
#endif
#endif

#define VT_MW_DEVICE_MAX         32

//���������Ͷ���
#define VSI_USBSPI		(2)
enum OP { 	//Operations
	CONTROL	= 0x00,
	WRITE	= 0x01,
	READ	= 0x02,
	ERASE	= 0x03
};

enum CC { // Control Codes
	EW_DISABLE	= 0x00,
	WRITE_ALL	= 0x01,
	ERASE_ALL	= 0x02,
	EW_ENABLE	= 0x03
};

#define PRODUCT_NAME_SIZE     64
#define HARDWARE_VERSION_SIZE     4
#define FIRMWARE_VERSION_SIZE     4
#define SERIAL_NUMBER_SIZE     12
#define DLL_VERSION_SIZE       12 

//1.Ginkgoϵ�нӿڿ���Ϣ���������͡�
typedef  struct  _VSI_BOARD_INFO{
	uint8_t		ProductName[PRODUCT_NAME_SIZE];	//Ӳ�����ƣ����硰Ginkgo-SPI-Adaptor����ע�⣺�����ַ�����������\0����
	uint8_t		FirmwareVersion[FIRMWARE_VERSION_SIZE];	//�̼��汾
	uint8_t		HardwareVersion[HARDWARE_VERSION_SIZE];	//Ӳ���汾
	uint8_t		SerialNumber[SERIAL_NUMBER_SIZE];	//���������к�
	uint8_t     DllVersion[DLL_VERSION_SIZE]; 
} VSI_BOARD_INFO,*PVSI_BOARD_INFO; 


//2.�����ʼ��SPI����������
typedef struct _VSI_INIT_CONFIG{
    uint8_t     ControlMode;	//SPI���Ʒ�ʽ:0-Ӳ�����ƣ�ȫ˫��ģʽ��,1-Ӳ�����ƣ���˫��ģʽ����2-������ƣ���˫��ģʽ��,3-������ģʽ�����������������ΪMOSI
    uint8_t     TranBits;		//���ݴ����ֽڿ�ȣ���8��16֮��ȡֵ
    uint8_t     MasterMode;		//����ѡ�����:0-�ӻ���1-����
    uint8_t     CPOL;			//ʱ�Ӽ��Կ���:0-SCK����Ч��1-SCK����Ч
    uint8_t     CPHA;			//ʱ����λ����:0-��һ��SCKʱ�Ӳ�����1-�ڶ���SCKʱ�Ӳ���
    uint8_t     LSBFirst;		//������λ��ʽ:0-MSB��ǰ��1-LSB��ǰ
    uint8_t     SelPolarity;	//Ƭѡ�źż���:0-�͵�ƽѡ�У�1-�ߵ�ƽѡ��
	uint32_t	ClockSpeed;		//SPIʱ��Ƶ��:��λΪHZ
}VSI_INIT_CONFIG,*PVSI_INIT_CONFIG;

//2. Define data type of initialize SPI
typedef struct _VSI_INIT_CONFIG_EX{
	uint8_t     SPIIndex; 
	// SPI Index: used to select which SPI peripheral to be used in adapter
    uint8_t     ControlMode;
    // SPI control mode: 0->hardware control(full duplex) 1->hardware control(half duplex) 2->software control(half duplex) 3-> one wire mode
    uint8_t     TranBits;
    // Width  of data (between 8 and 16)
    uint8_t     MasterMode;	
    // Master mode : 0 -> slave mode 1 -> master mode
    uint8_t     CPOL;		
    // Clock Polarity: 0 -> SCK active-high  1->SCK active-low 
    uint8_t     CPHA;		
    // Clock Phase: 0 -> sample on the leading (first) clock edge 1-> sample on the trailing (second) clock edge
    uint8_t     LSBFirst;	
    // whether or not LSB first: 0->MSB first 1-> LSB first
    uint8_t     SelPolarity;
    // Chip select Polarity: 0-> low to select 1-> high to select
    uint32_t	ClockSpeed;		
    // SPI clock frequency
}VSI_INIT_CONFIG_EX,*PVSI_INIT_CONFIG_EX;

//3.SPI Flash������ʼ�����ݽṹ
typedef struct _VSI_FLASH_INIT_CONFIG
{
	uint32_t	page_size;
	uint32_t	page_num;
	uint8_t		write_enable[8];
	uint8_t		read_status[8];
	uint8_t		chip_erase[8];
	uint8_t		write_data[8];
	uint8_t		read_data[8];
	uint8_t		first_cmd[8];
	uint8_t		busy_bit;
	uint8_t		busy_mask;
	uint8_t		addr_bytes;
	uint8_t		addr_shift;
	uint8_t		init_flag;
}VSI_FLASH_INIT_CONFIG,*PVSI_FLASH_INIT_CONFIG;

typedef struct _VSI_MW_INIT_CONFIG{
    int8_t   MW_START;
    int8_t   ORG;
    int32_t  SIZE;
    int8_t   MWIndex;		   
	int16_t  MWAddr;
    struct{
        int8_t EW_DISABLE;
        int8_t WRITE_ALL;
        int8_t ERASE_ALL;
        int8_t EW_ENABLE;
    }CC_CMD; //Control Codes
    struct{
        int8_t CONTROL;
        int8_t WRITE;
        int8_t READ;
        int8_t ERASE;
    }OP_CMD; //Operations
}VSI_MW_INIT_CONFIG,*PVSI_MW_INIT_CONFIG;

#ifdef __cplusplus
extern "C"
{
#endif

int32_t WINAPI VSI_ScanDevice(uint8_t NeedInit);
int32_t WINAPI VSI_OpenDevice(int32_t DevType,int32_t DevIndex,int32_t Reserved);
int32_t WINAPI VSI_CloseDevice(int32_t DevType,int32_t DevIndex);
int32_t WINAPI VSI_InitSPI(int32_t DevType, int32_t DevIndex, PVSI_INIT_CONFIG pInitConfig);
int32_t WINAPI VSI_InitSPIEx(int32_t DevType, int32_t DevIndex, PVSI_INIT_CONFIG_EX pInitConfig);
int32_t WINAPI VSI_ReadBoardInfo(int32_t DevIndex,PVSI_BOARD_INFO pInfo);
int32_t WINAPI VSI_WriteBytes(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pWriteData,uint16_t Len);
int32_t WINAPI VSI_ReadBytes(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pReadData,uint16_t Len);
int32_t WINAPI VSI_WriteReadBytes(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t* pWriteData,uint16_t WriteLen,uint8_t * pReadData,uint16_t ReadLen);
int32_t WINAPI VSI_WriteReadBytesEx(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t* pWriteData,uint32_t WriteLen,uint8_t * pReadData,uint32_t ReadLen);
int32_t WINAPI VSI_WriteBits(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pWriteBitStr);
int32_t WINAPI VSI_ReadBits(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pReadBitStr,int32_t ReadBitsNum);
int32_t WINAPI VSI_WriteReadBits(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pWriteBitStr,uint8_t *pReadBitStr,int32_t ReadBitsNum);

int32_t WINAPI VSI_SlaveModeSet(int32_t DevType,int32_t DevIndex,uint8_t SlaveMode,uint16_t CmdBytes,uint16_t DataBytes);
int32_t WINAPI VSI_SlaveReadBytes(int32_t DevType,int32_t DevIndex,uint8_t *pReadData,int32_t *pBytesNum,int32_t WaitTime);
int32_t WINAPI VSI_SlaveWriteBytes(int32_t DevType,int32_t DevIndex,uint8_t *pWriteData,int32_t WriteBytesNum);

int32_t WINAPI VSI_FlashInit(int32_t DevType,int32_t DevIndex, PVSI_FLASH_INIT_CONFIG pFlashInitConfig);
int32_t WINAPI VSI_FlashWriteBytes(int32_t DevType,int32_t DevIndex,int32_t PageAddr,uint8_t *pWriteData,uint16_t WriteLen);
int32_t WINAPI VSI_FlashReadBytes(int32_t DevType,int32_t DevIndex,int32_t PageAddr,uint8_t *pReadData,uint16_t ReadLen);

int32_t WINAPI VSI_SetUserKey(int32_t DevType,int32_t DevIndex,uint8_t* pUserKey);
int32_t WINAPI VSI_CheckUserKey(int32_t DevType,int32_t DevIndex,uint8_t* pUserKey);

int32_t WINAPI VSI_BlockWriteBytes(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pWriteData,uint16_t BlockSize,uint16_t BlockNum,uint32_t IntervalTime);
int32_t WINAPI VSI_BlockReadBytes(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pReadData,uint16_t BlockSize,uint16_t BlockNum,uint32_t IntervalTime);
int32_t WINAPI VSI_BlockWriteReadBytes(int32_t DevType,int32_t DevIndex,int32_t SPIIndex,uint8_t *pWriteData,uint16_t WriteBlockSize,uint8_t *pReadData,uint16_t ReadBlockSize,uint16_t BlockNum,uint32_t IntervalTime);

int32_t WINAPI VSI_MW_Init(int32_t DevType, int32_t DevIndex,PVSI_MW_INIT_CONFIG pInitConfig);
int32_t WINAPI VSI_MW_WriteBytes(int32_t DevType,int32_t DevIndex,int32_t MWIndex,uint32_t MemAddr,uint16_t *pWriteData,uint16_t Len); 
int32_t WINAPI VSI_MW_ReadBytes(int32_t DevType,int32_t DevIndex,int32_t MWIndex,uint32_t MemAddr,uint16_t *pReadData,uint16_t Len); 

#ifdef __cplusplus
}
#endif

#endif

