:: Programmed by hXR16F
:: hXR16F.ar@gmail.com

@echo off
reg add "HKCU\Console" /V "ForceV2" /T "REG_DWORD" /D "0x00000000" /F > nul
mode 80,34 & consetbuffer.dll 130,34
title IP Crawler by hXR16F
setlocal EnableDelayedExpansion
color 0F

set /P "port=Port (def. 80) : "
set /P "timeout=Timeout (def. 0.25) : "
set /P "autoskip=Auto skip (def. 0) : "

if not defined port set port=80
if not defined timeout set timeout=0.25
if not defined autoskip set autoskip=0

(set "tab=	"&set "method=TCP"&set "id=0")
if not exist "log.txt" (
	echo # This file has been generated using IP-Crawler by hXR16F>> "log.txt"
	echo # https://github.com/hXR16F/IP-Crawler>> "log.txt"
	echo.>> "log.txt"
	echo IP Address!tab!Port!tab!Method!tab!Country!tab!Hostname>> "log.txt"
	echo ------------------------------------------------>> "log.txt"
)


:loop
	cls
	(echo.&echo.) & batbox.dll /c 0x07 /d "!tab!" /c 0xF0 /d "ID!tab!STATUS!tab!IP ADDRESS!tab!PORT!tab!METHOD!tab!COUNTRY!tab!HOSTNAME" /c 0x08 & (echo.&echo.)
	for /L %%n in (1,1,25) do (
		set "host_name=NULL"
		set "country=NULL"
		for /L %%i in (1,1,4) do call :random_ 0 255 num%%i
		tcping.dll -n 1 -w !timeout! -4 !num1!.!num2!.!num3!.!num4! !port! > nul && (
			for /F "tokens=2 delims= " %%o in ('2^>nul nslookup !num1!.!num2!.!num3!.!num4! ^| findstr /C:":    "') do if not "%%o" EQU "" set "host_name=%%o"
			pushD EXT
				ipinfooffline.exe /iplist !num1!.!num2!.!num3!.!num4! /stab cc.txt
				if exist "cc.txt" (
					for /F "tokens=1*" %%i in (cc.txt) do (
						set "country=%%i"
					)
					del /F /Q "cc.txt" >nul 2>&1
				) else (
					set "country=NULL"
				)
			popD
			batbox.dll /c 0x0F /d "!tab!" /c 0x0F /d "!id!!tab!OK!tab!!num1!.!num2!.!num3!.!num4!!tab!!port!!tab!!method!!tab!!country!!tab!!host_name!" & echo.
			echo !num1!.!num2!.!num3!.!num4!!tab!!port!!tab!!method!!tab!!country!!tab!!host_name!>> "log.txt"
		) || (batbox.dll /c 0x0F /d "!tab!" /c 0x08 /d "!id!!tab!FAIL!tab!!num1!.!num2!.!num3!.!num4!!tab!!port!!tab!!method!!tab!!country!!tab!!host_name!" & echo.)
		set /A id+=1
	)
	if "%autoskip%" equ "0" (
		echo. & batbox.dll /c 0x0F /d "!tab!" /c 0xF0 /d "PRESS ANY KEY TO CONTINUE CRAWLING..." /c 0x0F
		pause > nul
	)
	
	goto loop

:random_
	set "name=%3"
	set /A !name!=%random% * (%2 - %1 + 1) / 32768 + %1
	exit /b
	