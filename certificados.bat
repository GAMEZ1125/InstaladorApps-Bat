@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo      GESTION DE CERTIFICADOS DE WINDOWS
echo ===============================================
echo.

:: Verificar permisos de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Se requieren permisos de administrador para gestionar certificados.
    echo Por favor, ejecute como administrador.
    pause
    exit /b 1
)

:menu
cls
echo.
echo 1. Instalar certificado (.cer)
echo 2. Listar certificados instalados
echo 3. Eliminar certificados por seleccion
echo 4. Salir
echo.
set /p "opt=Seleccione una opcion (1-4): "

if "!opt!"=="1" goto instalar
if "!opt!"=="2" goto listar
if "!opt!"=="3" goto eliminar
if "!opt!"=="4" goto fin

echo Opcion invalida.
pause
goto menu

:instalar
echo.
set /p "cer_path=Ruta completa del archivo .cer: "
if not exist "!cer_path!" (
    echo ERROR: El archivo no existe.
    pause
    goto menu
)
echo.
echo Seleccione el almacen de destino:
echo 1. Personal (CurrentUser\My)
echo 2. Personal (LocalMachine\My)
echo 3. Raiz Confiable (LocalMachine\Root)
echo 4. Cancelar
set /p "store=Opcion: "
if "!store!"=="1" set "storeloc=CurrentUser" & set "storename=My"
if "!store!"=="2" set "storeloc=LocalMachine" & set "storename=My"
if "!store!"=="3" set "storeloc=LocalMachine" & set "storename=Root"
if "!store!"=="4" goto menu
if not defined storeloc (
    echo Opcion invalida.
    pause
    goto menu
)
echo Instalando...
powershell -NoProfile -Command ^
    "try { " ^
    "  $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('!cer_path!'); " ^
    "  $store = New-Object System.Security.Cryptography.X509Certificates.X509Store('!storename!', '!storeloc!'); " ^
    "  $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite); " ^
    "  $store.Add($cert); " ^
    "  $store.Close(); " ^
    "  Write-Host '[EXITOSO] Certificado instalado correctamente' " ^
    "} catch { Write-Host '[ERROR] No se pudo instalar el certificado: ' + $_.Exception.Message }"
pause
goto menu

:listar
echo.
echo Listando certificados instalados...
powershell -NoProfile -Command ^
    "$almacenes = @(@{Location = 'CurrentUser'; Name = 'My'}, @{Location = 'CurrentUser'; Name = 'Root'}, @{Location = 'LocalMachine'; Name = 'My'}, @{Location = 'LocalMachine'; Name = 'Root'}); " ^
    "foreach ($almacen in $almacenes) { " ^
    "  $store = New-Object System.Security.Cryptography.X509Certificates.X509Store($almacen.Name, $almacen.Location); " ^
    "  $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly); " ^
    "  if ($store.Certificates.Count -gt 0) { " ^
    "    Write-Host ('--- ' + $almacen.Location + '\' + $almacen.Name + ' ---'); " ^
    "    $store.Certificates | ForEach-Object { Write-Host ('* ' + $_.Subject + ' [' + $_.Thumbprint + ']') } " ^
    "  } else { Write-Host ('--- ' + $almacen.Location + '\' + $almacen.Name + ' --- (vacio)') } " ^
    "  $store.Close(); " ^
    "}"
pause
goto menu

:eliminar
echo.
echo Seleccione el almacen:
echo 1. Personal (CurrentUser\My)
echo 2. Raiz Confiable (CurrentUser\Root)
echo 3. Personal (LocalMachine\My)
echo 4. Raiz Confiable (LocalMachine\Root)
echo 5. Cancelar
set /p "store=Opcion: "
if "!store!"=="1" set "storeloc=CurrentUser" & set "storename=My"
if "!store!"=="2" set "storeloc=CurrentUser" & set "storename=Root"
if "!store!"=="3" set "storeloc=LocalMachine" & set "storename=My"
if "!store!"=="4" set "storeloc=LocalMachine" & set "storename=Root"
if "!store!"=="5" goto menu
if not defined storeloc (
    echo Opcion invalida.
    pause
    goto menu
)
echo.
set /p "filtro=Ingrese parte del nombre o Thumbprint para filtrar: "
echo.
powershell -NoProfile -Command ^
    "$store = New-Object System.Security.Cryptography.X509Certificates.X509Store('!storename!', '!storeloc!'); " ^
    "$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite); " ^
    "$certs = $store.Certificates | Where-Object { $_.Subject -like '*!filtro!*' -or $_.Thumbprint -like '*!filtro!*' }; " ^
    "if ($certs.Count -eq 0) { Write-Host 'No se encontraron certificados.'; exit } " ^
    "$i=0; $certs | ForEach-Object { Write-Host ($i.ToString() + '. ' + $_.Subject + ' [' + $_.Thumbprint + ']'); $i++ }; " ^
    "$nums = Read-Host 'Ingrese los numeros de los certificados a eliminar (separados por coma)'; " ^
    "if ($nums -eq '') { exit } " ^
    "$arr = $nums -split ','; foreach ($n in $arr) { $ix = [int]$n.Trim(); if ($ix -ge 0 -and $ix -lt $certs.Count) { $store.Remove($certs[$ix]); Write-Host 'Eliminado: ' $certs[$ix].Subject } }; $store.Close()"
pause
goto menu

:fin
endlocal
exit /b 0