@echo off
set "CARPETA=C:\Program Files\C4POS\config"

echo Eliminando contenido sin cifrado...
if not exist "%CARPETA%" (
    echo La carpeta no existe.
    REM pause
    exit /b
)

REM Eliminar todos los archivos (/Q silencioso, /F fuerza)
del /F /Q /S "%CARPETA%\*.*" >nul 2>&1

REM Eliminar todas las subcarpetas vacías
for /F "delims=" %%i in ('dir "%CARPETA%" /B /AD 2^>nul') do rd /S /Q "%CARPETA%\%%i" >nul 2>&1

echo Carpeta vaciada permanentemente.
REM pause

exit /b
