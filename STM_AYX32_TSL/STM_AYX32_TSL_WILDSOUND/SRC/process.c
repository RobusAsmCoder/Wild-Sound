//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////


#include "SysType.h"
#include "hardware.h"
#include "interface.h"
#include "process.h"
#include "ChipAY_WildSound.h"
#include "ChipAY_Hardware.h"
#include "ChipAY_Interrupt.h"
#include "ChipAY_BootFlasher.h"
#include "ChipAY_WS_Process.h"



void CallProc(Tprocess *process, u32 pr, u32 pr_ret)
{
    if (pr_ret==proc_NOP) pr_ret=process->Mode;
    if (pr_ret==ProcSys_CALL_RET_NEXT) pr_ret=process->Mode+1;
    pr &= ProcSys_Mode_MASK;
    if (pr!=proc_NOP)
    {
      if (pr_ret!=proc_NOP)
      {
        process->Call_BUF[process->Call_BPTR++]=pr_ret;
      }
      process->Mode=pr;
    }
}

u32 ReturnProc(Tprocess *process)
{
   if (process->Call_BPTR)
   {
     process->Call_BPTR--;
     process->Mode=process->Call_BUF[process->Call_BPTR];
   }
   return process->Mode;
}

void ListProcADD(Tprocess *process, u32 pr)
{
    if (rb_fifo_free(process->ProceduresFIFOList))
    {
      rb_fifo_wr_D(process->ProceduresFIFOList, pr);
    }
}

u32 ListProcRoll(Tprocess *process)
{
    if ( (process->Mode==proc_NOP) && (process->Call_BPTR==0) )
    {
      process->Mode = rb_fifo_rd_D(process->ProceduresFIFOList);
      if (process->Mode & ProcSys_LOOP_INFINITE)
      {
        ListProcADD(process, process->Mode);
      }
    }
    return process->Mode;
}


void DoProc(Tprocess *process, u32 pr)
{
  
    if (pr)
    {
      CallProc(process, pr, proc_NOP);
      return;
    }
//label10:
    switch (process->Mode & ProcSys_Mode_MASK)
    {
      default:
        process->Mode=proc_NOP;
      case proc_NOP:
        if (process->Call_BPTR)
        {
        //if (ReturnProc()!=proc_NOP) goto label10;
          ReturnProc(process);
        } else {
          ListProcRoll(process);
        }
        break;
      
      
     //////////////////////////////
     //AY mixer and DAC processing
     //////////////////////////////
      case proc_LNG_AYDAC+0:
        Send_LOG_String("--------------------------------------\x0D\x0A");
        Send_LOG_String("- WildSound II DAC v.01 AYX-32(TSL)   \x0D\x0A");
        Send_LOG_String("--------------------------------------\x0D\x0A");
        ProcNext(process);
        break;
      case proc_LNG_AYDAC+1:
        {
          //static u8 a=0;
          //DACTEST(a&1);
          //a++;
          //u8 a=AYxPWMcur(AY0TONEA);
          //u8 a=AY0TONEA_PWMcur();
          //DACTEST(a);
          
          //ChipAY_Mixer(&ayStr);
          
          
        }
        //ProcWaitStart(process, 0, 50);
        ProcNext(process);
        break;
      case proc_LNG_AYDAC+2:
        
#if (isDoDacByTimer == 0)
        if (ProcWaitMcsContinue(process, 0, 1000000/AyFreqSND))
        {
//          DACTEST(0);
          ChipAY_DacStep();
          //ayDacVAL = ChipAY_Mixer(&ayStr);
          //DAC->DHR12R1 = ((u16)(ayDacVAL >>  0) & 0x0FFF);
          //DAC->DHR12R2 = ((u16)(ayDacVAL >> 16) & 0x0FFF);
//          {
//            u16 a=(TIM1->CNT & 0xF)<<7;
//            DAC->DHR12R1 = ((u16)(a) & 0x0FFF);
//            DAC->DHR12R2 = ((u16)(a) & 0x0FFF);
//          }
          //DAC->SWTRIGR = DAC_SWTRIGR_SWTRIG1 | DAC_SWTRIGR_SWTRIG2;
          
//          DACTEST(1);
          //ProcGoTo(process, proc_LNG_AYDAC+1);
        }
#endif
        break;
      
     //////////////////////////////
     //Loop Main
     //////////////////////////////
      case proc_LNG_Main+0:
        
        wsPoolFlasherMode();
        wsPoolTransMode();
        wsPoolStreamMode();
        wsPoolDigitalPlayer();
      
        //ProcNext(process);
        break;

        
        
          
        
      
    }
    
  
}








