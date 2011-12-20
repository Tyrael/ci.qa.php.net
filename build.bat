@ECHO OFF
REM ## This is needed for setenv.cmd later
setlocal EnableDelayedExpansion
REM ## STORE OLD DIR
set olddir=%cd%

REM ## DETERMINE SDK DIR
SET SDKREG=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v6.1
SET SDKDIRQUERY=reg query "%SDKREG%" /v InstallationFolder
FOR /F "tokens=2* delims= " %%A IN ('%SDKDIRQUERY%') DO SET SDKDIR=%%B
REM Tab followed by Space ^^^^^^

REM ## STARTUP COMPILE ENVIRONMENT
call "%SDKDIR%\bin\setenv.cmd" /x86 /xp /debug

REM ## RESET DIRECTORY
chdir /d %olddir%

REM do what phpsdk_setvars.bat does

SET PHP_SDK_SCRIPT_PATH=C:\PHP\binary-tools\bin
SET PHP_SDK_BIN_PATH=%PHP_SDK_SCRIPT_PATH%
SET PHP_SDK_PATH=%PHP_SDK_SCRIPT_PATH%\..

SET PATH=%PATH%;%PHP_SDK_BIN_PATH%;%PHP_SDK_SCRIPT_PATH%;

REM Set BISON_SIMPLE
SET BISON_SIMPLE=%PHP_SDK_BIN_PATH%\bison.simple

REM copy the deps into the working directory
REM I have no idea why is the "no" directory expected in the Makefile

XCOPY "C:\PHP\5.4-deps\include" "%CD%\no\include" /D /E /C /R /I /K /Y 
XCOPY "C:\PHP\5.4-deps\lib" "%CD%\no\lib" /D /E /C /R /I /K /Y 
XCOPY "C:\PHP\5.4-deps\bin" "%CD%\no\bin" /D /E /C /R /I /K /Y 

REM build

call buildconf
call configure --enable-debug
nmake

REM test

nmake test

