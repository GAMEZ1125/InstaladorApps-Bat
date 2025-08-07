@echo off
setlocal enabledelayedexpansion

:menu
cls
echo ===============================================
echo     GESTION DE ADAPTADORES DE RED DE WINDOWS
echo ===============================================
echo.
echo 1. Listar adaptadores de red
echo 2. Ver configuracion de un adaptador
echo 3. Configurar IP y DNS manualmente
echo 4. Restablecer adaptador a DHCP (IP y DNS)
echo 5. Salir
echo.
set /p "opt=Seleccione una opcion (1-5): "

if "!opt!"=="1" goto listar
if "!opt!"=="2" goto ver
if "!opt!"=="3" goto configurar
if "!opt!"=="4" goto dhcp
if "!opt!"=="5" goto fin

goto menu

:listar
echo.
netsh interface show interface
pause
goto menu

:ver
echo.
netsh interface show interface
echo.
set /p "iface=Nombre del adaptador a ver: "
echo.
netsh interface ip show config name="!iface!"
pause
goto menu

:configurar
echo.
netsh interface show interface
echo.
set /p "iface=Nombre del adaptador a configurar: "
set /p "ip=IP (ej: 192.168.1.100): "
set /p "mask=Máscara (ej: 255.255.255.0): "
set /p "gw=Gateway (ej: 192.168.1.1): "
set /p "dns1=DNS primario (ej: 8.8.8.8): "
set /p "dns2=DNS secundario (opcional): "
echo.
echo Configurando IP...
netsh interface ip set address name="!iface!" static !ip! !mask! !gw! 1
echo Configurando DNS...
netsh interface ip set dns name="!iface!" static !dns1! primary
if not "!dns2!"=="" (
    netsh interface ip add dns name="!iface!" !dns2! index=2
)
echo.
netsh interface ip show config name="!iface!"
pause
goto menu

:dhcp
echo.
netsh interface show interface
echo.
set /p "iface=Nombre del adaptador a restablecer a DHCP: "
echo.
echo Restableciendo IP y DNS a DHCP...
netsh interface ip set address name="!iface!" dhcp
:: Elimina todos los DNS manuales configurados (hasta 5 posibles)
for /l %%n in (1,1,5) do (
    netsh interface ip delete dns name="!iface!" all >nul 2>&1
)
netsh interface ip set dns name="!iface!" dhcp
echo Liberando IP...
ipconfig /release "!iface!" >nul 2>&1
echo Renovando IP...
ipconfig /renew "!iface!" >nul 2>&1
echo.
netsh interface ip show config name="!iface!"
pause
goto menu

:fin
endlocal
exit /b 0