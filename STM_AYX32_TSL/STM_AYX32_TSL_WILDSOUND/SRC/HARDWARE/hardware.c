//////////////////////////////////////////////////////////////////////////////////////
// 
// Low level for STM32F100
// 
// By Rob F. / Entire Group
// 
//////////////////////////////////////////////////////////////////////////////////////

#include "SysType.h"
#include "hardware.h"
//#include "STM32_Init.h"

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////// 
////////////////////////////////////////////////////////////////////////////////////////////////////////// 
////////////////////////////////////////////////////////////////////////////////////////////////////////// 
////////////////////////////////////////////////////////////////////////////////////////////////////////// 
enum {
  RCC_Speed_100mHz        = 0 ,
  RCC_Speed_168mHz            ,
  RCC_Speed_192mHz            ,
  RCC_Speed_200mHz            ,
  RCC_Speed_210mHz            ,
  RCC_Speed_220mHz            ,
  RCC_Speed_230mHz            ,
  RCC_Speed_240mHz            ,
};  

//OUT:TRUE If Done
u8 RCC_Configuration(u8 speedm)
{
    ErrorStatus errorStatus;
    // Resets the clock configuration to the default reset state
    RCC_DeInit();
    // Enable external crystal (HSE)
    RCC_HSEConfig(RCC_HSE_ON);
    // Wait until HSE ready to use or not
    errorStatus = RCC_WaitForHSEStartUp();

    if (errorStatus == SUCCESS)
    {
      
        switch(speedm)
        {
          case RCC_Speed_100mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16  , 100*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_168mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16  , 168*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_192mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16  , 192*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_200mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16  , 200*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_210mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16  , 210*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_220mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16/4, 220/2, 2,  7);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_230mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16/4, 230/2, 2,  7);      //Divisor by 4 because TSL use not stable Quartz
            break;
          case RCC_Speed_240mHz:
            RCC_PLLConfig(RCC_PLLSource_HSE, 16/4, 240/2, 2,  7);      //Divisor by 4 because TSL use not stable Quartz
            break;
          default:
          // Configure the PLL for 168MHz SysClk and 48MHz for USB OTG, SDIO
          //RCC_PLLConfig(RCC_PLLSource_HSE, 16/4, 336/4, 2, 7);      //Divisor by 4 because TSL use not stable Quartz
  //        RCC_PLLConfig(RCC_PLLSource_HSE, 16, 336, 2, 7);      //Divisor by 4 because TSL use not stable Quartz
  //        RCC_PLLConfig(RCC_PLLSource_HSE, 16, 240*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
  //        RCC_PLLConfig(RCC_PLLSource_HSE, 16, 250*2, 2, 15);      //Divisor by 4 because TSL use not stable Quartz
            break;
        }
        // Enable PLL
        RCC_PLLCmd(ENABLE);
        // Wait until main PLL clock ready
        while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET);

        // Set flash latency
        FLASH_SetLatency(FLASH_Latency_5);    //Maybe need FLASH_Latency_5 ? // I test this value with 50 degress heating ... on 405
        FLASH_PrefetchBufferCmd(ENABLE);
        FLASH_InstructionCacheCmd(ENABLE);    //IORQ clear caching and slowpoke enter in to the Interrupt ... DISABLE for max speed !!!
        FLASH_DataCacheCmd(ENABLE);

        // AHB 168MHz
        RCC_HCLKConfig(RCC_SYSCLK_Div1);
        if (speedm<=RCC_Speed_168mHz)
        {
          // APB1 42MHz
          RCC_PCLK1Config(RCC_HCLK_Div1);     //RCC_HCLK_Div4
          // APB2 84 MHz
          RCC_PCLK2Config(RCC_HCLK_Div1);     //RCC_HCLK_Div2
        } else if (speedm<=RCC_Speed_220mHz) {
          // APB1 42MHz
          RCC_PCLK1Config(RCC_HCLK_Div2);     //RCC_HCLK_Div4
          // APB2 84 MHz
          RCC_PCLK2Config(RCC_HCLK_Div2);     //RCC_HCLK_Div2
        } else {
          // APB1 42MHz
          RCC_PCLK1Config(RCC_HCLK_Div4);     //RCC_HCLK_Div4
          // APB2 84 MHz
          RCC_PCLK2Config(RCC_HCLK_Div4);     //RCC_HCLK_Div2
        }

        // Set SysClk using PLL
        RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);
    }
    else
    {
        // Do something to indicate that error clock configuration
        //while (1); //no wait i will work on the stupid 16mhz ... BRRR
    }

    return (errorStatus!=ERROR)?1:0;
}


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
u16 SPI3DMAbufferTx[1]={0x00AA<<2};
u16 SPI3DMAbufferRx[1]={0x00BB<<2};

#define  SPI_CR2_FRF                       ((u8)0x10)               //FRF Interrupt Enable

void SetupSPI(void)
{
      RCC_APB1PeriphClockCmd(RCC_APB1Periph_SPI3, ENABLE) ;
      RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_DMA1, ENABLE) ;
  

      GpioInit_SPI3_CLK();
      GpioInit_SPI3_MISO();
      GpioInit_SPI3_MOSI();
      GpioInit_SPI3_NSS();
  
      GPIO_PinAFConfig(GPIOC, GPIO_PinSource10, GPIO_AF_SPI3);    //CLK
      GPIO_PinAFConfig(GPIOC, GPIO_PinSource11, GPIO_AF_SPI3);    //MISO
      GPIO_PinAFConfig(GPIOC, GPIO_PinSource12, GPIO_AF_SPI3);    //MOSI
      GPIO_PinAFConfig(GPIOA, GPIO_PinSource15, GPIO_AF_SPI3);    //NSS
    

////////////////////
////////////////////
////////////////////
      DMA_InitTypeDef DMA_InitStructure;

      DMA_InitStructure.DMA_FIFOMode            = DMA_FIFOMode_Disable;
      DMA_InitStructure.DMA_FIFOThreshold       = DMA_FIFOThreshold_1QuarterFull;
      DMA_InitStructure.DMA_MemoryBurst         = DMA_MemoryBurst_Single;
      DMA_InitStructure.DMA_MemoryDataSize      = DMA_MemoryDataSize_HalfWord;
      DMA_InitStructure.DMA_Mode                = DMA_Mode_Normal;

      DMA_InitStructure.DMA_PeripheralBaseAddr  = (u32)(&(SPI3->DR));
      DMA_InitStructure.DMA_PeripheralBurst     = DMA_PeripheralBurst_Single;
      DMA_InitStructure.DMA_PeripheralDataSize  = DMA_PeripheralDataSize_HalfWord;
      DMA_InitStructure.DMA_MemoryDataSize      = DMA_MemoryDataSize_HalfWord;
      DMA_InitStructure.DMA_PeripheralInc       = DMA_PeripheralInc_Disable;
      DMA_InitStructure.DMA_Priority            = DMA_Priority_High;
      DMA_InitStructure.DMA_Mode                = DMA_Mode_Circular;
    // Configure Tx DMA
      DMA_InitStructure.DMA_Channel             = DMA_Channel_0;
      DMA_InitStructure.DMA_DIR                 = DMA_DIR_MemoryToPeripheral;
      DMA_InitStructure.DMA_Memory0BaseAddr     = (u32) &SPI3DMAbufferTx[0];
      DMA_InitStructure.DMA_BufferSize          = 1;//sizeof(SPI3DMAbufferTx);
      DMA_InitStructure.DMA_MemoryInc           = DMA_MemoryInc_Disable;
      DMA_Cmd(DMA1_Stream7, DISABLE);
      while (DMA1_Stream7->CR & DMA_SxCR_EN);
      DMA_Init(DMA1_Stream7, &DMA_InitStructure);
    // Configure Rx DMA 
      DMA_InitStructure.DMA_Channel             = DMA_Channel_0;
      DMA_InitStructure.DMA_DIR                 = DMA_DIR_PeripheralToMemory;
      DMA_InitStructure.DMA_Memory0BaseAddr     = (u32) &SPI3DMAbufferRx[0];
      DMA_InitStructure.DMA_BufferSize          = 1;//sizeof(SPI3DMAbufferRx);
      DMA_InitStructure.DMA_MemoryInc           = DMA_MemoryInc_Enable;
      DMA_Cmd(DMA1_Stream0, DISABLE);
      while (DMA1_Stream0->CR & DMA_SxCR_EN);
      DMA_Init(DMA1_Stream0, &DMA_InitStructure);
    // Enable the DMA channel
      DMA_ClearFlag(DMA1_Stream0, DMA_FLAG_FEIF0|DMA_FLAG_DMEIF0|DMA_FLAG_TEIF0|DMA_FLAG_HTIF0|DMA_FLAG_TCIF0);
      DMA_ClearFlag(DMA1_Stream7, DMA_FLAG_FEIF5|DMA_FLAG_DMEIF5|DMA_FLAG_TEIF5|DMA_FLAG_HTIF5|DMA_FLAG_TCIF5);

      DMA_Cmd(DMA1_Stream0, ENABLE); // Enable the DMA SPI TX Stream
      DMA_Cmd(DMA1_Stream7, ENABLE); // Enable the DMA SPI RX Stream

////////////////////
////////////////////
////////////////////

  
      SPI_DeInit(SPI3);
      SPI_InitTypeDef SPI_InitStructure;
      SPI_InitStructure.SPI_Direction           = SPI_Direction_1Line_Tx;//SPI_Direction_1Line_Tx; 
      SPI_InitStructure.SPI_Mode                = SPI_Mode_Master;
      SPI_InitStructure.SPI_DataSize            = SPI_DataSize_16b; 
      SPI_InitStructure.SPI_CPOL                = SPI_CPOL_High;
      SPI_InitStructure.SPI_CPHA                = SPI_CPHA_1Edge;
      SPI_InitStructure.SPI_NSS                 = SPI_NSS_Hard; // | SPI_NSSInternalSoft_Set  //SPI_NSS_Hard;
      SPI_InitStructure.SPI_BaudRatePrescaler   = SPI_BaudRatePrescaler_2; // fPCLK/128
      SPI_InitStructure.SPI_FirstBit            = SPI_FirstBit_MSB;
      SPI_InitStructure.SPI_CRCPolynomial       = 7;
      SPI_Init(SPI3, &SPI_InitStructure);

      SPI_SSOutputCmd(SPI3, ENABLE);
      SPI3->CR2 |= SPI_CR2_FRF;
      SPI_NSSInternalSoftwareConfig(SPI3, SPI_NSSInternalSoft_Set); //!!!!
      SPI_Cmd(SPI3, ENABLE); //SPI_SSOutputCmd(SPI3, ENABLE);
      
      // Enable the SPI Rx/Tx DMA request
      SPI_I2S_DMACmd(SPI3, SPI_I2S_DMAReq_Rx, ENABLE);
      SPI_I2S_DMACmd(SPI3, SPI_I2S_DMAReq_Tx, ENABLE);

      //SPI_I2S_DMACmd(SPI3, SPI_I2S_DMAReq_Tx, ENABLE);


      //SPI_I2S_ClearFlag(SPI3, SPI_I2S_FLAG_TXE);
      //SPI_Cmd(SPI3, ENABLE);  
      //SPI3->DR = 0; //SPI_I2S_SendData(SPI3, 0);
      
      //SPI_NSSInternalSoftwareConfig(SPI3, ENABLE);
      //SPI_SSOutputCmd(SPI3, ENABLE);

      //SPI_I2S_SendData(

      
        DMA_ITConfig(DMA1_Stream0, DMA_IT_TC, ENABLE); //| DMA_IT_HT
        //DMA_ITConfig(DMA1_Stream7, DMA_IT_TC | DMA_IT_TE, ENABLE); //| DMA_IT_HT
/*
      while(1)
      {
        static u8 b=0;
        SPI3->DR = b;
        SPI3DMAbufferTx[0] = b;
//        DMA_ITConfig(DMA1_Stream0, DMA_IT_TC | DMA_IT_HT | DMA_IT_TE, ENABLE); //| DMA_IT_HT
////        SPI_Cmd(SPI3, DISABLE);
////        
////        DMA_Cmd(DMA1_Stream0, DISABLE); // Enable the DMA SPI TX Stream
////        DMA_Cmd(DMA1_Stream5, DISABLE); // Enable the DMA SPI RX Stream
////        DMA_ITConfig(DMA1_Stream0, DMA_IT_TC | DMA_IT_TE, ENABLE); //| DMA_IT_HT
////        DMA_ITConfig(DMA1_Stream5, DMA_IT_TC | DMA_IT_TE, ENABLE); //| DMA_IT_HT
////        DMA_Cmd(DMA1_Stream0, ENABLE); // Enable the DMA SPI TX Stream
////        DMA_Cmd(DMA1_Stream5, ENABLE); // Enable the DMA SPI RX Stream
////        
////        SPI_Cmd(SPI3, ENABLE);
        
//        DMA1_Stream5->CR |= 0x00000001 | 0x00000002;
//        DMA1_Stream0->CR |= 0x00000001 | 0x00000002;
        DelayMS(10);
//        DMA1_Stream5->CR &=~0x00000001;
//        DMA1_Stream0->CR &=~0x00000001;
        b++;
      }
*/
    //while(1)__nop();
}


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

void SystemInit(void)
{
  #if (__FPU_PRESENT == 1) && (__FPU_USED == 1)
    SCB->CPACR |= ((3UL << 10*2)|(3UL << 11*2));  // set CP10 and CP11 Full Access
  #endif
  //      RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_BKPSRAM, ENABLE);
      RCC_Configuration(RCC_Speed_100mHz);
}


u8 isRbousCFG = 0;

void SelectInitGPIO(void)
{
    GpioInit_SWO();
  
//    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);
//    GpioInit_TIM1CH2();
//    GpioAFCF_TIM1CH2(GPIO_AF_TIM1); //GPIO_PinAFConfig
    //GpioInit_TIM1CH3();
    //GpioAFCF_TIM1CH3(GPIO_AF_TIM1);
//    GpioInit_DACTEST();
  

      GpioInit_BOOT1CFG();
//      GpioInit_LASPI_CLK();
//      GpioInit_LASPI_MOSI();
//      GpioInit_LASPI_NSS();
      SetupSPI();
  
      GpioInit_DAC1();
      GpioInit_DAC2();
  
      GpioInit_AY_BDIR(); //GpioInit_PRTB0();
      GpioInit_AY_BC1();  //GpioInit_PRTB1();
      GpioInit_PRTB2();
      GpioInit_PRTB4();
      GpioInit_PRTB5();
      GpioInit_PRTB6();
      GpioInit_PRTB7();
      GpioInit_PRTB8();
      GpioInit_PRTB9();
      GpioInit_PRTB10();
      GpioInit_PRTB11();
      GpioInit_PRTB12();
      GpioInit_PRTB13();
      GpioInit_PRTB14();
      GpioInit_PRTB15();
  
      GpioInit_AY_RESET();

//      GpioInit_AYPIOA0();
//      GpioInit_AYPIOA1();
//      GpioInit_AYPIOA2();
//      GpioInit_AYPIOA3();
//      GpioInit_AYPIOA4();
//      GpioInit_AYPIOA5();
//      GpioInit_AYPIOA6();
//      GpioInit_AYPIOA7();

      DelayMS(5);
      isRbousCFG = BOOT1CFG();
}
void Init(void)
{
      RCC_Configuration(RCC_Speed_220mHz);
        RCC_GetClocksFreq(&MPU_ClocksStatus);
//        PCLK1=RCC_ClocksStatus.PCLK1_Frequency;// stm32_GetPCLK1();
//        PCLK2=RCC_ClocksStatus.PCLK2_Frequency;// stm32_GetPCLK2();
        PCLK1_NOP=MPU_ClocksStatus.SYSCLK_Frequency/1000000;
//        TIMER0_PER=stm32_TimerGetReload(0);
//        TIMER1_PER=stm32_TimerGetReload(1);
//        TIMER2_PER=stm32_TimerGetReload(2);
//        TIMER3_PER=stm32_TimerGetReload(3);
//        TIMER4_PER=stm32_TimerGetReload(4);

        SelectInitGPIO();
/*  
        SPI2_Init();
        SPI2_DMA_Init();
        SPI2_GPIO_ON();

        SPI3_Init();
        SPI3_DMA_Init();
        SPI3_GPIO_ON();
  */

  
}





//


