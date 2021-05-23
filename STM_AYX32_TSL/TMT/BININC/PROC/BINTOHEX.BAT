@ECHO OFF
cls

For %%i In ("%0") Do SET filepas=%%~ni

ECHO ===================================
ECHO = Compile %filepas%.pas
ECHO ===================================

REM SET filepas=TEST
CALL :CompilePasWin

LOADER\SAVER.EXE %filepas%.EXE %filepas%.ZPC

DEL *.FPW
exit /b 0


rem ==========================================================================
:CompilePasWin
REM TARGET=WIN32:CON;DOS
SET PAS_TARGET=WIN32:CON

SET PASCAL_DIR=TMTPL\BIN
:CompPasFindDir
SET COMPILER=%PASCAL_DIR%\tmtpc.exe
IF NOT EXIST "%COMPILER%" (SET PASCAL_DIR=..\%PASCAL_DIR%&goto:CompPasFindDir)
ECHO TMT PATH = %PASCAL_DIR%

SET EXE_DIR=.
SET OBJECTS_DIR=.

SET COMPILE_FLAGS=-$LOGO- -$AMD+ -$MAP- -$OPT+ -$MMX+^
 -OBJ:%OBJECTS_DIR% -OUT:%EXE_DIR% -$B+ -$D- -$L- -$X+^
 -T:%PAS_TARGET% -EXEMAX:221048576

%COMPILER% %COMPILE_FLAGS% %filepas%.PAS
DEL %filepas%.FPW

exit /b 0

