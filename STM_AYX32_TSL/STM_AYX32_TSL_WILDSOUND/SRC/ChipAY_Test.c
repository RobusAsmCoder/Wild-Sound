//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
#include "ChipAY_Test.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_Hardware.h"
#include <cstddef>


//__attribute__((section("ccmram")))
u32 extra_buff[2] = {
  0x12345678,
  0x00000000
};



#define MPU_REGION_SIZE_32B     (0x04U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_64B     (0x05U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_128B    (0x06U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_256B    (0x07U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_512B    (0x08U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_1KB     (0x09U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_2KB     (0x0AU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_4KB     (0x0BU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_8KB     (0x0CU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_16KB    (0x0DU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_32KB    (0x0EU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_64KB    (0x0FU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_128KB   (0x10U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_256KB   (0x11U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_512KB   (0x12U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_1MB     (0x13U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_2MB     (0x14U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_4MB     (0x15U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_8MB     (0x16U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_16MB    (0x17U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_32MB    (0x18U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_64MB    (0x19U << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_128MB   (0x1AU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_256MB   (0x1BU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_512MB   (0x1CU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_1GB     (0x1DU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_2GB     (0x1EU << MPU_RASR_SIZE_Pos)
#define MPU_REGION_SIZE_4GB     (0x1FU << MPU_RASR_SIZE_Pos)

#define MPU_REGION_NO_ACCESS    (0x00U << MPU_RASR_AP_Pos)
#define MPU_REGION_PRIV_RW      (0x01U << MPU_RASR_AP_Pos)
#define MPU_REGION_PRIV_RW_URO  (0x02U << MPU_RASR_AP_Pos)
#define MPU_REGION_FULL_ACCESS  (0x03U << MPU_RASR_AP_Pos)
#define MPU_REGION_PRIV_RO      (0x05U << MPU_RASR_AP_Pos)
#define MPU_REGION_PRIV_RO_URO  (0x06U << MPU_RASR_AP_Pos)

#define MpuRegNum(_p)           ((u32)((_p)<<MPU_RNR_REGION_Pos))


#define CCM_ADDRESS_START                        (0x10000000UL)
#define CCM_SIZE                                 (0x19UL << 0UL)
#define CCM_REGION_NUMBER                        (0x03UL << MPU_RNR_REGION_Pos) 

#define RAM_ADDRESS_START                        (0x20000000UL)
#define RAM_SIZE                                 (0x19UL << 0UL)
#define PERIPH_ADDRESS_START                     (0x40000000)
#define PERIPH_SIZE                              (0x39UL << 0UL)
#define FLASH_ADDRESS_START                      (0x08000000)
#define FLASH_SIZE                               (0x27UL << 0UL)
#define portMPU_REGION_READ_WRITE                (0x03UL << MPU_RASR_AP_Pos)
#define portMPU_REGION_PRIVILEGED_READ_ONLY      (0x05UL << MPU_RASR_AP_Pos)
#define portMPU_REGION_READ_ONLY                 (0x06UL << MPU_RASR_AP_Pos)
#define portMPU_REGION_PRIVILEGED_READ_WRITE     (0x01UL << MPU_RASR_AP_Pos)
#define RAM_REGION_NUMBER                        (0x00UL << MPU_RNR_REGION_Pos)
#define FLASH_REGION_NUMBER                      (0x01UL << MPU_RNR_REGION_Pos)
#define PERIPH_REGION_NUMBER                     (0x02UL << MPU_RNR_REGION_Pos)


/*
#define ARRAY_ADDRESS_START    (0x20002000UL*0+0x10001000)
#define ARRAY_SIZE             (0x09UL << 0UL)
#define ARRAY_REGION_NUMBER    (0x03UL << MPU_RNR_REGION_Pos) 

// Private macro -------------------------------------------------------------
// Private variables ---------------------------------------------------------
#if defined ( __CC_ARM   )
 uint8_t PrivilegedReadOnlyArray[32] __attribute__((at(0x20002000*0+0x10001000)));

#elif defined ( __ICCARM__ )
 #pragma location=0x20002000
 __no_init uint8_t PrivilegedReadOnlyArray[32];

#elif defined   (  __GNUC__  )
 uint8_t PrivilegedReadOnlyArray[32] __attribute__((section(".ROarraySection")));

#elif defined   (  __TASKING__  )
 uint8_t PrivilegedReadOnlyArray[32] __at(0x20002000);
#endif
*/

void MPU_RegionConfig(void)
{

  MPU->CTRL &= ~MPU_CTRL_ENABLE_Msk;

  // Configure RAM region as Region N°0, 8kB of size and R/W region
  MPU->RNR  = RAM_REGION_NUMBER;
  MPU->RBAR = RAM_ADDRESS_START;
  MPU->RASR = RAM_SIZE | portMPU_REGION_READ_WRITE;
  
  // Configure FLASH region as REGION N°1, 1MB of size and R/W region
  MPU->RNR  = FLASH_REGION_NUMBER;
  MPU->RBAR = FLASH_ADDRESS_START;
  MPU->RASR = FLASH_SIZE | portMPU_REGION_READ_WRITE;
  
  // Configure Peripheral region as REGION N°2, 0.5GB of size, R/W and Execute
  // Never region
  MPU->RNR  = PERIPH_REGION_NUMBER;  
  MPU->RBAR = PERIPH_ADDRESS_START;
  MPU->RASR = PERIPH_SIZE | portMPU_REGION_READ_WRITE | MPU_RASR_XN_Msk;
  
  // Enable the memory fault exception
  SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
  // Enable MPU
  MPU->CTRL |= MPU_CTRL_PRIVDEFENA_Msk | MPU_CTRL_ENABLE_Msk;  
/*
  MPU->RNR  = ARRAY_REGION_NUMBER;
  MPU->RBAR |= ARRAY_ADDRESS_START;
  MPU->RASR |= ARRAY_SIZE*0 + RAM_SIZE | portMPU_REGION_READ_WRITE; //portMPU_REGION_PRIVILEGED_READ_ONLY;
  
  PrivilegedReadOnlyArray[0] = 0x12;
  */
  MPU->RNR  = CCM_REGION_NUMBER;
  MPU->RBAR |= CCM_ADDRESS_START;
  MPU->RASR |= CCM_SIZE | portMPU_REGION_READ_WRITE; //portMPU_REGION_PRIVILEGED_READ_ONLY;
  
  //TPI->
  
}


void MPU_ExceptionByDMA_Test(void)
{
  
  MPU->CTRL &= ~MPU_CTRL_ENABLE_Msk;

  // Configure RAM region as Region N°0, 8kB of size and R/W region
  MPU->RNR  = RAM_REGION_NUMBER;//MpuRegNum(0);
  MPU->RBAR = (u32)&TIM3->CCR1 & 0xFFFFFFE4;
  MPU->RASR = MPU_REGION_SIZE_32B | MPU_REGION_PRIV_RO;//MPU_REGION_NO_ACCESS;
  
  // Enable the memory fault exception
  SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
  // Enable MPU
  MPU->CTRL |= MPU_CTRL_PRIVDEFENA_Msk | MPU_CTRL_ENABLE_Msk;  
  
  
}


u8 TEST_SpiSend(u8 b)
{
    SPI_I2S_SendData(SPI1, b);
    while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_BSY) == SET);
    b = SPI_I2S_ReceiveData(SPI1);
    return b;
}


u8 aTxBuffer[]={
  0,1,2,3,4,5,6,7,8,9,
  0,1,2,3,4,5,6,7,8,9,
  0,1,2,3,4,5,6,7,8,9,
  0,1,2,3,4,5,6,7,8,9,
};

void TEST_Spi(void)
{
      GPIO_InitTypeDef GPIO_InitStruct;
      SPI_InitTypeDef SPI_InitStruct;
      // enable clock for used IO pins
      RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);
      // configure pins used by SPI1
      // PA5 = SCK
      // PA6 = MISO
      // PA7 = MOSI
      GPIO_InitStruct.GPIO_Pin = GPIO_Pin_7 | GPIO_Pin_6 | GPIO_Pin_5;
      GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF;
      GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
      GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
      GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_UP;
      GPIO_Init(GPIOA, &GPIO_InitStruct);
      // connect SPI1 pins to SPI alternate function
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource5, GPIO_AF_SPI1);
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource6, GPIO_AF_SPI1);
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource7, GPIO_AF_SPI1);
  
      // enable peripheral clock
      RCC_APB2PeriphClockCmd(RCC_APB2Periph_SPI1, ENABLE);
      // configure SPI1 in Mode 0 
      // CPOL = 0 --> clock is low when idle
      // CPHA = 0 --> data is sampled at the first edge
      SPI_InitStruct.SPI_Direction = SPI_Direction_2Lines_FullDuplex; // set to full duplex mode, seperate MOSI and MISO lines
      SPI_InitStruct.SPI_Mode = SPI_Mode_Master; // transmit in master mode, NSS pin has to be always high
      SPI_InitStruct.SPI_DataSize = SPI_DataSize_8b; // one packet of data is 8 bits wide
      SPI_InitStruct.SPI_CPOL = SPI_CPOL_High; // clock is low when idle
      SPI_InitStruct.SPI_CPHA = SPI_CPHA_2Edge; // data sampled at first edge
      SPI_InitStruct.SPI_NSS = SPI_NSS_Soft | SPI_NSSInternalSoft_Set; // set the NSS management to internal and pull internal NSS high
      SPI_InitStruct.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_32; // SPI frequency is APB2 frequency / 4
      SPI_InitStruct.SPI_FirstBit = SPI_FirstBit_MSB;// data is transmitted MSB first
      SPI_Init(SPI1, &SPI_InitStruct); 
      SPI_Cmd(SPI1, ENABLE); // enable SPI1
  
  
////////  
//      TIM_SelectSlaveMode(TIM3, TIM_SlaveMode_External1);
      TIM_ITConfig(TIM3, TIM_IT_CC3 | TIM_IT_CC4, ENABLE);
      
    DMA_InitTypeDef        DMA_InitStructureTIM;

    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_DMA1, ENABLE);
    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_DMA2, ENABLE);
  
      DMA_InitStructureTIM.DMA_BufferSize = 24 ;
      DMA_InitStructureTIM.DMA_FIFOMode = DMA_FIFOMode_Disable ;
      DMA_InitStructureTIM.DMA_FIFOThreshold = DMA_FIFOThreshold_1QuarterFull ;
      DMA_InitStructureTIM.DMA_MemoryBurst = DMA_MemoryBurst_Single ;
      DMA_InitStructureTIM.DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
      DMA_InitStructureTIM.DMA_MemoryInc = DMA_MemoryInc_Disable;
      DMA_InitStructureTIM.DMA_Mode = DMA_Mode_Circular;
      DMA_InitStructureTIM.DMA_PeripheralBaseAddr = (u32)&TIM3->CCR3;//SPI1->DR;//TIM6->CNT;//SPI1->DR; //SPI1->DR;//TIM3->CCR3; // &extra_buff[0];//(u32)(&(SPI1->DR)) ;
      DMA_InitStructureTIM.DMA_PeripheralBurst = DMA_PeripheralBurst_Single;
      DMA_InitStructureTIM.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Word;
      DMA_InitStructureTIM.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
      DMA_InitStructureTIM.DMA_Priority = DMA_Priority_High;
      // Configure TX DMA
      DMA_InitStructureTIM.DMA_Channel = DMA_Channel_5; //TIM1CC1_DMA_CHANNEL;
      DMA_InitStructureTIM.DMA_DIR = DMA_DIR_PeripheralToMemory;//DMA_DIR_PeripheralToMemory;//DMA_DIR_MemoryToPeripheral;//DMA_DIR_MemoryToMemory;
      DMA_InitStructureTIM.DMA_Memory0BaseAddr = (u32)&extra_buff[0];//SPI1->DR;//&extra_buff[0]; //extra_buff[0]; //;aTxBuffer[0];
      DMA_Init(DMA1_Stream7, &DMA_InitStructureTIM);        //TIM1CC1_DMA_STREAM
      DMA_Cmd(DMA1_Stream7, ENABLE);
      
      DMA_InitStructureTIM.DMA_Channel = DMA_Channel_3;
      DMA_InitStructureTIM.DMA_DIR = DMA_DIR_PeripheralToMemory;
      DMA_InitStructureTIM.DMA_Memory0BaseAddr = (u32)&extra_buff[0];
      DMA_InitStructureTIM.DMA_PeripheralBaseAddr = (u32)&SPI1->DR;
      DMA_Init(DMA2_Stream2, &DMA_InitStructureTIM);
      DMA_Cmd(DMA2_Stream2, ENABLE);
      
      
}






