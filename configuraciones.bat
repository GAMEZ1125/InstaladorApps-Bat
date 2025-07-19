@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo        GESTION DE ARCHIVO HOSTS DE WINDOWS
echo ===============================================
echo.

:: Verificar permisos de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Se requieren permisos de administrador para modificar el archivo hosts.
    echo Por favor, ejecute como administrador.
    pause
    exit /b 1
)

echo [INFO] Mostrando contenido actual de hosts:
echo --------------------------------------------------------
type "%WINDIR%\System32\Drivers\Etc\hosts"
echo --------------------------------------------------------
echo.

set /p "add_entry=¿Desea agregar una nueva entrada? [S/N]: "
if /i "!add_entry!"=="S" (
    echo.
    set /p "ip=Ingrese la IP: "
    set /p "dominio=Ingrese el dominio: "
    echo.
    echo Nueva entrada que se agregara: !ip! !dominio!
    set /p "confirm=¿Confirmar y agregar al archivo hosts? [S/N]: "
    if /i "!confirm!"=="S" (
        echo !ip! !dominio! >> "%WINDIR%\System32\Drivers\Etc\hosts"
        if !errorlevel! equ 0 (
            echo [EXITOSO] Entrada agregada al archivo hosts correctamente.
            echo.
            echo [INFO] Contenido actualizado del archivo hosts:
            echo --------------------------------------------------------
            type "%WINDIR%\System32\Drivers\Etc\hosts"
            echo --------------------------------------------------------
        ) else (
            echo [ERROR] No se pudo agregar la entrada al archivo hosts.
        )
    ) else (
        echo [INFO] Operacion cancelada por el usuario.
    )
) else (
    echo [INFO] No se agregaron nuevas entradas.
)

echo.
echo ===============================================
echo         FIN DE GESTION DE ARCHIVO HOSTS
echo ===============================================

endlocal
pause
exit /b 0