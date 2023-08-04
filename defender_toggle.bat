@echo off

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

:input
echo.
echo Choose the action you want to perform:
echo   on  - To turn on Windows Defender
echo   off - To turn off Windows Defender
set /p choice="Enter your choice: "

if /i "!choice!"=="on" (
    echo Turning on Windows Defender...
    powershell.exe -command "Set-MpPreference -DisableRealtimeMonitoring \$false"
    echo Windows Defender has been turned on.
) else if /i "!choice!"=="off" (
    echo Turning off Windows Defender...
    powershell.exe -command "Set-MpPreference -DisableRealtimeMonitoring \$true"
    echo Windows Defender has been turned off temporarily.
) else (
    echo Invalid option. Please enter "on" or "off".
    goto input
)

pause
