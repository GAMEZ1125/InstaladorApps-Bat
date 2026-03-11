@echo off
set "CARPETA=C:\Program Files\GalaxiaPOS\config"

echo Eliminando contenido de %CARPETA%...
if not exist "%CARPETA%" (
    echo La carpeta no existe.
    pause
    exit /b
)

REM Eliminar todos los archivos (/Q silencioso, /F fuerza)
del /F /Q /S "%CARPETA%\*.*" >nul 2>&1

REM Eliminar todas las subcarpetas vacías
for /F "delims=" %%i in ('dir "%CARPETA%" /B /AD 2^>nul') do rd /S /Q "%CARPETA%\%%i" >nul 2>&1

echo Carpeta vaciada permanentemente.
pause
