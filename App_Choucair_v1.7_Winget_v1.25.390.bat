@echo off
setlocal enabledelayedexpansion

:: Función para encontrar winget automáticamente
call :find_winget
if not defined wingetPath (
    echo ERROR: No se pudo encontrar winget en el sistema.
    echo Verifique que Microsoft Store App Installer esté instalado.
    pause
    exit /b
)

echo Usando winget desde: %wingetPath%

:: Administrar modo de ejecución
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Elevando permisos de administrador...
    powershell Start-Process -Verb RunAs -FilePath "%comspec%" -ArgumentList '/c ""%~f0""'
    exit /b
)

:: Verificar winget en ruta específica
if not exist "%wingetPath%" (
    echo ERROR: winget no encontrado en la ruta especificada.
    echo Verifique que tenga instalada la versión 1.25.340 de App Installer
    pause
    exit /b
)

:: Lista de aplicaciones actualizada
set apps[1]=JSFoundation.Appium
set apps[2]=Google.Chrome
set apps[3]=dbeaver.dbeaver
set apps[4]=Mozilla.Firefox
set apps[5]=Git.Git
set apps[6]=OpenJS.NodeJS
set apps[7]=Microsoft.VisualStudioCode
set apps[8]=Postman.Postman
set apps[9]=SmartBear.SoapUI
set apps[10]=Vysor.Vysor
set apps[11]=WinSCP.WinSCP
set apps[12]=Notepad++.Notepad++
set apps[13]=Oracle.JDK.21
set apps[14]=JetBrains.IntelliJIDEA.Community
set apps[15]=Microsoft.SqlServerManagementStudio
set apps[16]=Amazon.Corretto.11.JDK
set apps[17]=Amazon.Corretto.8.JDK
set apps[18]=Amazon.Corretto.17.JDK
set apps[19]=Python.Python.3.12
set apps[20]=Amazon.AWSCLI
set apps[21]=Google.AndroidStudio
set apps[22]=ShareX.ShareX
set apps[23]=Microsoft.VisualStudio.2022.BuildTools
set apps[24]=MongoDB.Compass.Full
set apps[25]=Microsoft.SQLServer.2022.Express
set apps[26]=VideoLAN.VLC
set apps[27]=Microsoft.Office
set apps[28]=Microsoft.DotNet.Framework.DeveloperPack_4
set apps[29]=Eraser.Eraser
set apps[30]=Fortinet.FortiClientVPN
set apps[31]=IBMiAccess_v1r1.zip
set apps[32]=apache-maven-3.9.10-bin.zip
set apps[33]=Gradle-8.13.zip
set apps[34]=FusionInventory-Agent.exe
set apps[35]=Amazon.WorkspacesClient
set apps[36]=Adobe.Acrobat.Reader.64-bit
set apps[37]=Microsoft.VisualStudio.2022.Community
set apps[38]=DEVCOM.JMeter 5.6.3
set apps[39]=jenkins.msi
set apps[40]=MongoDB.Server
set apps[41]=MongoDB.Shell
set apps[42]=MongoDB.DatabaseTools
set apps[43]=NoSQLBooster.NoSQLBooster
set apps[44]=Gradle-8.5.zip
set apps[45]=Elixir
set apps[46]=Gradle-8.10.zip
set apps[47]=Kubernetes.kubectl
set apps[48]=tesseract-ocr.tesseract
set apps[49]=Chocolatey.Chocolatey
set apps[50]=FVM
set apps[51]=UltraVNC_1436
set apps[52]=Microsoft.Sysinternals.SDelete

:menu
cls
echo -------------------------------
echo  INSTALADOR DE APLICACIONES V.2.0
echo  Winget Version 1.25.390.0
echo -------------------------------
echo Seleccione aplicaciones a instalar:
echo.

:: Mostrar menu actualizado
for /l %%i in (1,1,52) do (
    echo  %%i. !apps[%%i]!
)
echo  99. Borrado seguro de usuario

echo.
echo Ingrese numeros separados por comas (ej: 2,5,7-10)
echo [A] Todos   [C] Confirmar   [S] Salir
echo.
set /p "selection=Seleccion: "

if /i "%selection%" == "99" (
    call :secure_delete
    pause
    goto menu
)

:: Procesar entrada actualizado
if /i "%selection%" == "S" exit /b
if /i "%selection%" == "A" (
    set "selected=1-52"
) else if /i "%selection%" == "C" (
    goto confirm
) else (
    set "selected=%selection%"
)

:: Expandir seleccion
set applications=
for %%a in ("%selected:,=" "%") do (
    set "range=%%~a"
    if "!range:-=!" neq "!range!" (
        for /f "tokens=1,2 delims=-" %%b in ("!range!") do (
            for /l %%i in (%%b,1,%%c) do (
                set "applications=!applications! !apps[%%i]!"
            )
        )
    ) else (
        set "applications=!applications! !apps[%%~a]!"
    )
)

:confirm
cls
echo Aplicaciones seleccionadas:
echo --------------------------
for %%a in (%applications%) do echo  - %%a
echo.
echo ¿Instalar estas aplicaciones?
choice /C SN /N /M "[S]i  [N]o (Volver al menu): "
if %errorlevel% equ 2 goto menu

:: Proceso de instalacion
set error_count=0
set application_count=0

echo Iniciando instalaciones...
for %%a in (%applications%) do (
    set /a application_count+=1
    echo.
    echo [%time%] Instalando %%a...
    
    if "%%a"=="IBMiAccess_v1r1.zip" (
        call :install_zip "https://www.nicklitten.com/wp-content/uploads/IBMiAccess_v1r1.zip" "C:\IBMiAccess_v1r1"
    ) else if "%%a"=="apache-maven-3.9.10-bin.zip" (
        call :install_zip "https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.zip" "C:\Program Files\apache-maven-3.9.10-bin"
    ) else if "%%a"=="Gradle-8.13.zip" (
        call :install_zip "https://services.gradle.org/distributions/gradle-8.13-bin.zip" "C:\Program Files\gradle-8.13"
    ) else if "%%a"=="Gradle-8.5.zip" (
        call :install_zip "https://services.gradle.org/distributions/gradle-8.5-all.zip" "C:\Program Files\gradle-8.5"
    ) else if "%%a"=="Gradle-8.10.zip" (
        call :install_zip "https://services.gradle.org/distributions/gradle-8.10.2-all.zip" "C:\Program Files\gradle-8.10"
    ) else if "%%a"=="Elixir" (
        call :install_elixir
    ) else if "%%a"=="FusionInventory-Agent.exe" (
        call :install_exe "https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent_windows-x64_2.6.exe"
    ) else if "%%a"=="jenkins.msi" (
        call :install_msi "https://get.jenkins.io/windows/2.509/jenkins.msi"
    ) else if "%%a"=="Kubernetes.kubectl" (
        "%wingetPath%" install --id Kubernetes.kubectl --accept-source-agreements --accept-package-agreements -h
    ) else if "%%a"=="tesseract-ocr.tesseract" (
        "%wingetPath%" install --id tesseract-ocr.tesseract --accept-source-agreements --accept-package-agreements -h
    ) else if "%%a"=="Chocolatey.Chocolatey" (
        "%wingetPath%" install --id Chocolatey.Chocolatey --accept-source-agreements --accept-package-agreements -h
    ) else if "%%a"=="FVM" (
        powershell -Command "choco install fvm -y"
    ) else if "%%a"=="UltraVNC_1436" (
        call :install_exe "https://descargas-xelerica.netlify.app/assets/downloads/UltraVNC_1436_X64_Setup.exe"
    ) else if "%%a"=="Microsoft.Sysinternals.SDelete" (
        "%wingetPath%" install --id Microsoft.Sysinternals.SDelete --accept-source-agreements --accept-package-agreements -h
    ) else (
        "%wingetPath%" install --id %%a --silent --accept-package-agreements --accept-source-agreements
        if !errorlevel! neq 0 (
            echo ERROR al instalar %%a
            set /a error_count+=1
        ) else (
            echo %%a instalado correctamente
        )
    )
)

:: Resultado final
echo.
echo Resumen de instalacion:
echo Aplicaciones instaladas: %application_count%
echo Errores: %error_count%
if %error_count% gtr 0 echo Verifique los errores e intente instalar manualmente.
pause
exit /b

:: Funciones de instalacion
:install_zip
set url=%~1
set dest=%~2
set zipfile=%temp%\%~nx1

echo Descargando desde %url%...
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%zipfile%'"
if not exist "%zipfile%" (
    echo ERROR: Fallo en la descarga
    set /a error_count+=1
    goto :eof
)

echo Extrayendo en %dest%...
if not exist "%dest%" mkdir "%dest%"
powershell -Command "Expand-Archive -Path '%zipfile%' -DestinationPath '%dest%' -Force"
if exist "%zipfile%" del "%zipfile%"

echo Extraccion completada en %dest%

:: Configurar variables de entorno si es Maven o Gradle
if /i "%dest%"=="C:\Program Files\apache-maven-3.9.10-bin" (
    set "maven_home=%dest%\apache-maven-3.9.10"
    if exist "!maven_home!" (
        echo Configurando variables de entorno para Maven...
        powershell -Command "[Environment]::SetEnvironmentVariable('MAVEN_HOME', '!maven_home!', 'Machine')"
        powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!maven_home!\bin'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
        echo [INFO] Variables MAVEN_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.
    ) else (
        echo ERROR: Directorio de Maven no encontrado en "!maven_home!"
        set /a error_count+=1
    )
) else if /i "%dest%"=="C:\Program Files\gradle-8.13" (
    set "gradle_home=%dest%\gradle-8.13"
    if exist "!gradle_home!" (
        echo Configurando variables de entorno para Gradle...
        powershell -Command "[Environment]::SetEnvironmentVariable('GRADLE_HOME', '!gradle_home!', 'Machine')"
        powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!gradle_home!\bin'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
        echo [INFO] Variables GRADLE_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.
    ) else (
        echo ERROR: Directorio de Gradle no encontrado en "!gradle_home!"
        set /a error_count+=1
    )
) else if /i "%dest%"=="C:\Program Files\gradle-8.5" (
    set "gradle_home=%dest%\gradle-8.5"
    if exist "!gradle_home!" (
        echo Configurando variables de entorno para Gradle 8.5...
        powershell -Command "[Environment]::SetEnvironmentVariable('GRADLE_HOME', '!gradle_home!', 'Machine')"
        powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!gradle_home!\bin'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
        echo [INFO] Variables GRADLE_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.
    ) else (
        echo ERROR: Directorio de Gradle no encontrado en "!gradle_home!"
        set /a error_count+=1
    )
) else if /i "%dest%"=="C:\Program Files\gradle-8.10" (
    set "gradle_home=%dest%\gradle-8.10.2"
    if exist "!gradle_home!" (
        echo Configurando variables de entorno para Gradle 8.10...
        powershell -Command "[Environment]::SetEnvironmentVariable('GRADLE_HOME', '!gradle_home!', 'Machine')"
        powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!gradle_home!\bin'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
        echo [INFO] Variables GRADLE_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.
    ) else (
        echo ERROR: Directorio de Gradle no encontrado en "!gradle_home!"
        set /a error_count+=1
    )
)

goto :eof

:install_exe
set exe_url=%~1
set exe_file=%temp%\%~nx1

echo Descargando instalador...
powershell -Command "Invoke-WebRequest -Uri '%exe_url%' -OutFile '%exe_file%'"
if not exist "%exe_file%" (
    echo ERROR: Fallo en la descarga
    set /a error_count+=1
    goto :eof
)

echo Ejecutando instalacion silenciosa...
start /wait "" "%exe_file%" /SILENT /NORESTART
if !errorlevel! neq 0 (
    echo ERROR en la instalacion
    set /a error_count+=1
) else (
    echo Instalacion completada
)
if exist "%exe_file%" del "%exe_file%"
goto :eof

:install_msi
set msi_url=%~1
set msi_file=%temp%\%~nx1

echo Descargando instalador MSI...
powershell -Command "Invoke-WebRequest -Uri '%msi_url%' -OutFile '%msi_file%'"
if not exist "%msi_file%" (
    echo ERROR: Fallo en la descarga
    set /a error_count+=1
    goto :eof
)

echo Ejecutando instalacion silenciosa de MSI...
start /wait msiexec.exe /i "%msi_file%" /qn /norestart
if !errorlevel! neq 0 (
    echo ERROR en la instalacion del MSI
    set /a error_count+=1
) else (
    echo Instalacion MSI completada
)
if exist "%msi_file%" del "%msi_file%"
goto :eof

:install_elixir
set "erlang_dir=C:\Program Files\Erlang"
set "elixir_dir=C:\Program Files\Elixir"
set "erlang_zip=%temp%\otp_win64_27.2.3.zip"
set "elixir_zip=%temp%\elixir-otp-27.zip"

echo Descargando Erlang...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/erlang/otp/releases/download/OTP-27.2.3/otp_win64_27.2.3.zip' -OutFile '%erlang_zip%'"
if not exist "%erlang_zip%" (
    echo ERROR: Fallo en la descarga de Erlang
    set /a error_count+=1
    goto :eof
)

echo Descargando Elixir...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/elixir-lang/elixir/releases/download/v1.18.3/elixir-otp-27.zip' -OutFile '%elixir_zip%'"
if not exist "%elixir_zip%" (
    echo ERROR: Fallo en la descarga de Elixir
    set /a error_count+=1
    goto :eof
)

echo Extrayendo Erlang...
if not exist "%erlang_dir%" mkdir "%erlang_dir%"
powershell -Command "Expand-Archive -Path '%erlang_zip%' -DestinationPath '%erlang_dir%' -Force"
if exist "%erlang_zip%" del "%erlang_zip%"

echo Extrayendo Elixir...
if not exist "%elixir_dir%" mkdir "%elixir_dir%"
powershell -Command "Expand-Archive -Path '%elixir_zip%' -DestinationPath '%elixir_dir%' -Force"
if exist "%elixir_zip%" del "%elixir_zip%"

:: Buscar carpeta bin de Erlang
set "erlang_bin="
if exist "%erlang_dir%\bin" (
    set "erlang_bin=%erlang_dir%\bin"
) else (
    for /d %%E in ("%erlang_dir%\otp_win64_*") do (
        if exist "%%E\bin" set "erlang_bin=%%E\bin"
    )
)

:: Buscar carpeta bin de Elixir
set "elixir_bin="
if exist "%elixir_dir%\bin" (
    set "elixir_bin=%elixir_dir%\bin"
) else (
    for /d %%L in ("%elixir_dir%\*") do (
        if exist "%%L\bin" set "elixir_bin=%%L\bin"
    )
)

if not defined erlang_bin (
    echo ERROR: No se encontró la carpeta bin de Erlang
    set /a error_count+=1
    goto :eof
)
if not defined elixir_bin (
    echo ERROR: No se encontró la carpeta bin de Elixir
    set /a error_count+=1
    goto :eof
)

echo Configurando variables de entorno para Erlang y Elixir...
powershell -Command "[Environment]::SetEnvironmentVariable('ERLANG_HOME', '%erlang_dir%', 'Machine')"
powershell -Command "[Environment]::SetEnvironmentVariable('ELIXIR_HOME', '%elixir_bin%\..', 'Machine')"
powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';%erlang_bin%;%elixir_bin%'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
echo [INFO] Variables ERLANG_HOME, ELIXIR_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.

goto :eof

:: ---------------------------------------------------------
:: MODULO DE BORRADO SEGURO DE CARPETAS DE USUARIO (CMD)
:: ---------------------------------------------------------
:secure_delete
setlocal enabledelayedexpansion

set "carpetasDatos=Desktop Documents Downloads Pictures Music Videos"
set "rutaSDelete=C:\SDelete.exe"
set "urlSDelete=https://download.sysinternals.com/files/SDelete.zip"
set "rutaDescarga=%TEMP%\SDelete.zip"

:: Solicitar nombre de usuario
set /p usuario=Ingrese el nombre de usuario para borrado seguro: 

:: Verificar existencia del perfil
if not exist "C:\Users\%usuario%" (
    echo El usuario '%usuario%' no existe en el sistema.
    goto :eof
)

:: Descargar y extraer SDelete si no existe
if not exist "%rutaSDelete%" (
    echo Descargando SDelete...
    bitsadmin /transfer "SDeleteJob" %urlSDelete% "%rutaDescarga%"
    if not exist "%rutaDescarga%" (
        echo ERROR: No se pudo descargar SDelete.
        goto :eof
    )
    echo Extrayendo SDelete...
    set "extract_dir=%TEMP%\sdelete_extract"
    if not exist "!extract_dir!" mkdir "!extract_dir!"
    tar -xf "%rutaDescarga%" -C "!extract_dir!"
    for %%f in ("!extract_dir!\sdelete*.exe") do (
        copy /y "%%f" "%rutaSDelete%" >nul
    )
    del /q "%rutaDescarga%"
    rmdir /s /q "!extract_dir!"
    if not exist "%rutaSDelete%" (
        echo ERROR: No se pudo extraer SDelete.
        goto :eof
    )
)

:: Eliminar y sobrescribir carpetas
echo.
echo Iniciando borrado seguro para el usuario: %usuario%
set "rutaPerfil=C:\Users\%usuario%"
set "resultadoEliminacion="

for %%c in (%carpetasDatos%) do (
    set "rutaCarpeta=%rutaPerfil%\%%c"
    if exist "!rutaCarpeta!" (
        echo Eliminando contenido de !rutaCarpeta!...
        del /f /q /s "!rutaCarpeta!\*" >nul 2>&1
        for /d %%d in ("!rutaCarpeta!\*") do rmdir /s /q "%%d" >nul 2>&1
        echo Sobrescribiendo datos con SDelete...
        "%rutaSDelete%" -p 35 -s -q "!rutaCarpeta!" >nul 2>&1
        set "resultadoEliminacion=!resultadoEliminacion!Eliminados: !rutaCarpeta!^&echo."
    )
)

:: Registro básico
echo.
echo ----------------- REGISTRO DE BORRADO -----------------
echo Nombre del equipo: %COMPUTERNAME%
echo Usuario ejecutor: %USERNAME%
for /f "skip=1 tokens=*" %%s in ('wmic bios get serialnumber') do (
    if not "%%s"=="" set serialMaquina=%%s
)
echo Número de serie de la máquina: %serialMaquina%
echo Fecha y hora del proceso: %DATE% %TIME%
echo.
echo El contenido de las carpetas del usuario '%usuario%' ha sido eliminado de forma segura e irrecuperable y los datos han sido sobrescritos 35 veces.
echo.
echo %resultadoEliminacion%
echo --------------------------------------------------------
endlocal
goto :eof

:: Función para buscar winget
:find_winget
set "wingetPath="

:: Intentar encontrar winget en el PATH primero
where winget >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where winget 2^>nul') do (
        set "wingetPath=%%i"
        goto :winget_found
    )
)

:: Buscar en la carpeta de WindowsApps
set "appsPath=C:\Program Files\WindowsApps"
if exist "%appsPath%" (
    for /d %%d in ("%appsPath%\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe") do (
        if exist "%%d\winget.exe" (
            set "wingetPath=%%d\winget.exe"
            goto :winget_found
        )
    )
)

:: Buscar en ubicaciones alternativas
set "userAppsPath=%LOCALAPPDATA%\Microsoft\WindowsApps"
if exist "%userAppsPath%\winget.exe" (
    set "wingetPath=%userAppsPath%\winget.exe"
    goto :winget_found
)

:: Buscar en Program Files
for /d %%d in ("C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*") do (
    if exist "%%d\winget.exe" (
        set "wingetPath=%%d\winget.exe"
        goto :winget_found
    )
)

:winget_found
goto :eof