@echo off




set path=%path%;res;..\..\SDCC\bin\

fw_tool.exe ..\..\STM_AYX32_TSL_WILDFIRMWARE\OBJ\STM_AYX32_TSL_WILDFIRMWARE.bin
ren *.fw fw.fw
copy /b fw.fw res\fw.bin
del *.fw

..\BININC\BININC.exe RES\fw.bin RES\fw.h !fw_bin
rem ..\BININC\BININC.exe RES\fw_tsl_2016.bin RES\fw.h !fw_bin
rem ..\BININC\BININC.exe RES\fw_tsl_2017.bin RES\fw.h !fw_bin

if not exist obj md obj
del /q /s obj >nul

sdasz80 -o obj/crt0.rel src/crt0.s
sdcc -mz80 --std-sdcc11 --no-std-crt0 --opt-code-speed -Wl-b_HEADER=0x6000 -Wl-b_HOME=0x6010 -Wl-b_CODE=0x6200 -Wl-b_DATA=0x5B00 obj/crt0.rel src/main.c -o obj/out.hex
rem sdcc -mz80 --std-c99 --no-std-crt0 --opt-code-size -Wl-b_HEADER=0x6000 -Wl-b_HOME=0x6010 -Wl-b_CODE=0x6200 -Wl-b_DATA=0x5B00 obj/crt0.rel src/main.c -o obj/out.hex

hex2bin obj/out.hex >nul
ren obj\out.bin code.C

rem trdtool # ayx32_fw.trd >nul
rem trdtool + ayx32_fw.trd res/boot.$b >nul
rem trdtool + ayx32_fw.trd obj/code.C >nul


CD BOOT
rem CALL LINK.BAT
 CD LINKER
  link.exe
 CD ..
CD ..

copy /b BOOT\LINKER\ayx32_fw.trd ayx32_fw.trd
rem res\rs232mnt.exe -a ayx32_fw.trd -com com8 -baud 115200 -slowpoke
