;******************** (C) COPYRIGHT 2013 STMicroelectronics ********************
;* File Name          : startup_stm32f40_41xxx.s
;* Author             : MCD Application Team
;* Version            : V1.3.0
;* Date               : 08-November-2013
;* Description        : STM32F40xxx/41xxx devices vector table for MDK-ARM toolchain. 
;*                      This module performs:
;*                      - Set the initial SP
;*                      - Set the initial PC == Reset_Handler
;*                      - Set the vector table entries with the exceptions ISR address
;*                      - Configure the system clock and the external SRAM mounted on 
;*                        STM324xG-EVAL board to be used as data memory (optional, 
;*                        to be enabled by user)
;*                      - Branches to __main in the C library (which eventually
;*                        calls main()).
;*                      After Reset the CortexM4 processor is in Thread mode,
;*                      priority is Privileged, and the Stack is set to Main.
;* <<< Use Configuration Wizard in Context Menu >>>   
;*******************************************************************************
; 
; Licensed under MCD-ST Liberty SW License Agreement V2, (the "License");
; You may not use this file except in compliance with the License.
; You may obtain a copy of the License at:
; 
;        http://www.st.com/software_license_agreement_liberty_v2
; 
; Unless required by applicable law or agreed to in writing, software 
; distributed under the License is distributed on an "AS IS" BASIS, 
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
; 
;*******************************************************************************

; Amount of memory (in bytes) allocated for Stack
; Tailor this value to your application needs
; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000100

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp

; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000100

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit

                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset
                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp               ; Top of Stack
                DCD     Reset_Handler              ; Reset Handler
__Vectors_End
__Vectors_Size  EQU  __Vectors_End - __Vectors
    
                AREA    |.text|, CODE, READONLY
; Reset handler
Reset_Handler    PROC
                 EXPORT  Reset_Handler             [WEAK]
        IMPORT  SystemInit
        IMPORT  __main

                 LDR     R0, =SystemInit
                 BLX     R0
                 LDR     R0, =__main
                 BX      R0
                 ENDP


                AREA    STACK, NOINIT, READWRITE, ALIGN=3
                ;AREA    RAM_FREE, NOINIT, READWRITE, ALIGN=3
__ADDR_ram_free
                AREA    ccmram, NOINIT, READWRITE, ALIGN=3
__ADDR_ccmram_free
                ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************
                 IF      :DEF:__MICROLIB
                
                 EXPORT  __initial_sp
                 EXPORT  __heap_base
                 EXPORT  __heap_limit
                     
                 EXPORT  __ADDR_ram_free
                 EXPORT  __ADDR_ccmram_free

                 ELSE
                
                 IMPORT  __use_two_region_memory
                 EXPORT  __user_initial_stackheap
                 
__user_initial_stackheap

                 LDR     R0, =  Heap_Mem
                 LDR     R1, =(Stack_Mem + Stack_Size)
                 LDR     R2, = (Heap_Mem +  Heap_Size)
                 LDR     R3, = Stack_Mem
                 BX      LR

                 ALIGN

                 ENDIF

                 END

;************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE*****
