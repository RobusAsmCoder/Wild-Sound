//////////////////////////////////////////////////////////////////////////////////////
// By Rob F. / Entire Group
//////////////////////////////////////////////////////////////////////////////////////

#ifndef __PROCESS_H
#define __PROCESS_H

#include "SysType.h"
#include "rb_fifo.h"

typedef struct {
  u32          Mode;
  u32         *Call_BUF;
  u8           Call_BPTR;
  u8           Call_MAXSIZE;
  Trb_fifo    *ProceduresFIFOList;
  u32         *TimerMS_Array;
} volatile Tprocess;

//#define rb_fifo_alloc(__x__,__siz__)   u8 __x__##_buf[(__siz__)];               \
//                                       Trb_fifo __x__={0,                       \
//                                                       0,                       \
//                                                       (__siz__)-1,             \
//                                                       (void *)(&__x__##_buf)}
//rb_fifo_alloc(_name_##call_fifo,_size_*4);         \
//

#define process_alloc(_name_,_lst_,_size_,_tmr_)              u32 _name_##_call_buf[(_size_)];                  \
                                                              u32 _name_##_timers_buf[(_tmr_)];                 \
                                                              rb_fifo_alloc(_name_##_list, ((_lst_)+1)*4);      \
                                                              Tprocess _name_={proc_NOP,                        \
                                                                               (u32 *)(&_name_##_call_buf),     \
                                                                               0,                               \
                                                                               _size_,                          \
                                                                               &_name_##_list,                  \
                                                                               (u32 *)(&_name_##_timers_buf)    \
                                                                              }
//
//                                                                              (u32 *)(&_name_##_timers),       \
//
                                                                              
#define ProcSys_LOOP_ONCE         0x00000000
#define ProcSys_LOOP_INFINITE     0x80000000
#define ProcSys_CALL_RET_NEXT     0xFFFFFFFF
#define ProcSys_Flag_MASK         0xF0000000
#define ProcSys_Mode_MASK         ~ProcSys_Flag_MASK


                                                            
typedef enum { proc_NOP                         = 0x00000000,
               proc_LNG_AYDAC                   = 0x00000100,
               proc_LNG_Main                    = 0x00000F00,
               proc_LastRecord
} enProcDef;

extern void ListProcADD(Tprocess *process, u32 pr);
extern void DoProc(Tprocess *process, u32 pr);

#define Send_PROCDBG_String(_vA)        //Send_RS_String(_vA)
#define Send_PROCDBG_HEX(_vA,_vB)       //Send_RS_HEX(_vA,_vB)
#define Send_PROCDBG_DEC(_vA)           //Send_RS_DEC(_vA)

#define Send_LOG_String(_vA)            //Send_DC0_String(_vA)
#define Send_LOG_HEX(_vA,_vB)           //Send_DC0_HEX(_vA,_vB)
#define Send_LOG_DEC(_vA)               //Send_DC0_DEC(_vA)
#define Send_LOG_BIN(_vA,_max)                        \
          {                                           \
            for (u32 n=0; n<_max; n++)                \
            {                                         \
              Send_LOG_DEC( ((_vA)>>(_max-1-n))&1 );  \
            }                                         \
          }

#define ProcOffset(_p_,_ofs_)               _p_->Mode = (u32)((s32)(_p_->Mode) + (s32)(_ofs_));
#define ProcCur(_p_)                        _p_->Mode
#define ProcNext(_p_)                       _p_->Mode++
#define ProcGoTo(_p_,_pr_)                  _p_->Mode=_pr_
#define ProcJr(_p_,_ofs)                    _p_->Mode=(s32)(_p_->Mode)+(s32)(_ofs)
#define ProcEnd(_p_)                        _p_->Mode=proc_NOP
#define ProcCall(_p_,_cal_)                 CallProc(_p_, _cal_, proc_NOP)
#define ProcNextAndCall(_p_,_cal_)          ProcNext(_p_); ProcCall(_cal_)
#define ProcWaitStart(_p_,_n_,_ms_)         WaitMS_Start(&_p_->TimerMS_Array[_n_],_ms_)
#define ProcWaitCheck(_p_,_n_)              WaitMS_Check(&_p_->TimerMS_Array[_n_])
#define ProcWaitContinue(_p_,_n_,_ms_)      WaitMS_CheckContinue(&_p_->TimerMS_Array[_n_],_ms_)
#define ProcWaitMcsStart(_p_,_n_,_ms_)      WaitMCS_Start(&_p_->TimerMS_Array[_n_],_ms_)
#define ProcWaitMcsCheck(_p_,_n_)           WaitMCS_Check(&_p_->TimerMS_Array[_n_])
#define ProcWaitMcsContinue(_p_,_n_,_ms_)   WaitMCS_CheckContinue(&_p_->TimerMS_Array[_n_],_ms_)
          
          
#endif
