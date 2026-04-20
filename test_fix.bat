@echo off
setlocal enabledelayedexpansion
title Test Script
echo Testing ANSI colors...
for /f %%a in ('powershell -Command "[char]27"') do set "ESC=%%a"
echo %ESC%[96mThis should be Bright Cyan%ESC%[0m
echo %ESC%[92mThis should be Bright Green%ESC%[0m
pause
