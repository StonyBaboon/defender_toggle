@echo off

REM Detect if the script is already running with elevated privileges
NET SESSION >NUL 2>NUL
if %ERRORLEVEL% EQU 0 (
    goto :main
) else (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\elevate.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%TEMP%\elevate.vbs"
    "%TEMP%\elevate.vbs"
    del "%TEMP%\elevate.vbs"
    exit /b
)

:main
REM Set default language to English (United States)
chcp 437 > nul

REM Check if the script is being run with administrator privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo This script needs to be run with administrator privileges.
    pause
    exit /b
)

setlocal enabledelayedexpansion

:loop
echo.
echo Choose the action you want to perform:
echo   on    - To turn on Windows Defender
echo   off   - To turn off Windows Defender
echo   exit  - To exit this script
set /p choice="Enter your choice: "

if /i "!choice!"=="on" (
    echo Turning on Windows Defender...
    powershell.exe -command "Set-MpPreference -DisableRealtimeMonitoring:$false"
    echo Windows Defender has been turned on.
    goto loop
) else if /i "!choice!"=="off" (
    echo Turning off Windows Defender...
    powershell.exe -command "Set-MpPreference -DisableRealtimeMonitoring:$true"
    echo Windows Defender has been turned off temporarily.
    goto loop
) else if /i "!choice!"=="exit" (
    echo Exiting the script...
    pause
    exit /b
) else (
    echo Invalid option. Please enter "on", "off", or "exit".
    goto loop
)

