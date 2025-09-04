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
set apps[32]=apache-maven-3.9.11-bin.zip
set apps[33]=Gradle-8.13.zip
set apps[34]=FusionInventory-Agent.exe
set apps[35]=Amazon.WorkspacesClient
set apps[36]=Adobe.Acrobat.Reader.64-bit
set apps[37]=Microsoft.VisualStudio.2022.Community
set apps[38]=DEVCOM.JMeter
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
set apps[53]=Microsoft.DesktopAppInstaller
set apps[54]=Instalar_Winget
set apps[55]=SaenzFety_Atera-SanDiego
set apps[56]=SaenzFety_Atera-Access
set apps[57]=SaenzFety_Atera-Comerciales_Externos
set apps[58]=SaenzFety_Atera-CID
set apps[59]=PL/SQL_Developer
set apps[60]=Cisco_Secure_Client_v5.1.2.42
set apps[61]=Gradle-8.14.3.zip
set apps[62]=MongoDB-Compass
set apps[63]=npm_appium
set apps[64]=Gestion_Hosts
set apps[65]=apache-jmeter-5.6.3.zip
set apps[66]=mysql-connector-odbc-9.4.0-winx64.msi
set apps[67]=mysql-connector-net-9.4.0.msi
set apps[68]=Docker.DockerDesktop
set apps[69]=Gestion_Certificados
set apps[70]=Gestion_Adaptadores_de_Red
set apps[71]=OfimaBot
set apps[72]=UIPath
set apps[73]=Office365_32bits
set apps[74]=Gradle_v9.0.0
set apps[75]=HelpDesk_Xelerica


:menu
cls
echo -------------------------------
echo  INSTALADOR DE APLICACIONES V.2.0
echo  Winget instalador de aplicaciones
echo -------------------------------
echo Seleccione aplicaciones a instalar:
echo.

:: Mostrar menu en dos columnas (1-37 y 36-74)
echo  COLUMNA 1                        COLUMNA 2
echo  ---------                        ---------
for /l %%i in (1,1,39) do (
    set /a right_col=%%i+37
    for %%j in (!right_col!) do (
        set "left_app=%%i. !apps[%%i]!                                "
        set "left_app=!left_app:~0,37!"
        if %%i leq 37 (
            if %%j leq 75 (
                call echo  !left_app!%%j. !apps[%%j]!
            ) else (
                echo  !left_app!
            )
        ) else if %%i gtr 37 (
            if %%j leq 75 (
                echo                                 %%j. !apps[%%j]!
            )
        )
    )
)
echo  99. Borrado seguro de usuario
echo  98. Temp_SQLDeveloper
echo  97. Buscar aplicaciones
echo.
echo Ingrese numeros separados por comas (ej: 2,5,7-10)
echo [A] Todos   [C] Confirmar   [S] Salir   [B] Buscar
echo.
set /p "selection=Seleccion: "

if /i "%selection%" == "99" (
    call :secure_delete
    pause
    goto menu
)

if /i "%selection%" == "98" (
    call :clean_sqldeveloper
    pause
    goto menu
)

if /i "%selection%" == "97" (
    call :search_applications
    pause
    goto menu
)

if /i "%selection%" == "B" (
    call :search_applications
    pause
    goto menu
)

:: Procesar entrada actualizado
if /i "%selection%" == "S" exit /b
if /i "%selection%" == "A" (
    set "selected=1-75"
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
    ) else if "%%a"=="apache-maven-3.9.11-bin.zip" (
        call :install_zip "https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.zip" "C:\Program Files\apache-maven-3.9.11-bin"
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
    ) else if "%%a"=="Microsoft.DesktopAppInstaller" (
        call :install_winget_update
    ) else if "%%a"=="Instalar_Winget" (
        call :install_winget_only
    ) else if "%%a"=="SaenzFety_Atera-SanDiego" (
        call :install_msi "https://descargas-xelerica.netlify.app/assets/downloads/atera-sandiego.msi"
    ) else if "%%a"=="SaenzFety_Atera-Access" (
        call :install_msi "https://descargas-xelerica.netlify.app/assets/downloads/atera-access.msi"
    ) else if "%%a"=="SaenzFety_Atera-Comerciales_Externos" (
        call :install_msi "https://descargas-xelerica.netlify.app/assets/downloads/atera-Equipos_Externos.msi"
    ) else if "%%a"=="SaenzFety_Atera-CID" (
        call :install_msi "https://descargas-xelerica.netlify.app/assets/downloads/atera-CID.msi"
    ) else if "%%a"=="PL/SQL_Developer" (
        call :install_zip "https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-24.3.1.347.1826-x64.zip" "C:\sqldeveloper"
    ) else if "%%a"=="Cisco_Secure_Client_v5.1.2.42" (
        call :install_msi "https://descargas-xelerica.netlify.app/assets/downloads/cisco-secure-client-win-5.1.2.42.msi"
    ) else if "%%a"=="Gradle-8.14.3.zip" (
        call :install_zip "https://services.gradle.org/distributions/gradle-8.14.3-all.zip" "C:\Program Files\gradle-8.14.3"
    ) else if "%%a"=="MongoDB-Compass" (
        call :install_exe "https://dw.uptodown.net/dwn/RvVkii134Riphftvun7hQBZyU0aCwJjJMFI3FD3XyiRi0C7C1tKU5X0Pf15N_2JMoxSAFNFbUkqB5n99hv--lniGF9thVLBxuJXkeuUCMmaE0HWFlt_kpQaypgkqkrxM/MqtJ-IhY5h-7rmxHLgdKTffsbsEbJSnfF18NzrCeMZWLnLoEx64VYXBcsZLEzuhY0n7dPloJ2oYLKpWKSHSyWNQKkCV_Qc_xzsZ9rzLZ__astxn6sY5NT4yzjnUfEejW/jx6cW_oauyrVt72wYVkDJ53rbfa0JdRC1XV9lAs6rvscToJi9CkXdhtO1skSss_2u6l11_s8tarAhYa0kzmPUzKpX87HGpgoBNSTOn4drgw=/mongodb-compass-1-46-5.exe"
    ) else if "%%a"=="npm_appium" (
        call :install_npm_appium
    ) else if "%%a"=="Gestion_Hosts" (
        echo Descargando herramienta de gestion de hosts...
        curl -o "%temp%\configuraciones.bat" "https://raw.githubusercontent.com/GAMEZ1125/InstaladorApps-Bat/main/configuraciones.bat" 2>nul
        if exist "%temp%\configuraciones.bat" (
            echo Ejecutando gestion de hosts...
            call "%temp%\configuraciones.bat"
            if exist "%temp%\configuraciones.bat" del "%temp%\configuraciones.bat"
        ) else (
            echo ERROR: No se pudo descargar la herramienta de configuracion
            set /a error_count+=1
        )
    ) else if "%%a"=="Gestion_Certificados" (
        echo Descargando herramienta de gestion de certificados...
        curl -o "%temp%\certificados.bat" "https://raw.githubusercontent.com/GAMEZ1125/InstaladorApps-Bat/main/certificados.bat" 2>nul
        if exist "%temp%\certificados.bat" (
            echo Ejecutando gestion de certificados...
            call "%temp%\certificados.bat"
            if exist "%temp%\certificados.bat" del "%temp%\certificados.bat"
        ) else (
            echo ERROR: No se pudo descargar la herramienta de certificados
            set /a error_count+=1
        )
    ) else if "%%a"=="Gestion_Adaptadores_de_Red" (
        echo Descargando herramienta de gestion de adaptadores de red...
        curl -o "%temp%\adaptadores.bat" "https://raw.githubusercontent.com/GAMEZ1125/InstaladorApps-Bat/main/adaptadores.bat" 2>nul
        if exist "%temp%\adaptadores.bat" (
            echo Ejecutando gestion de adaptadores de red...
            call "%temp%\adaptadores.bat"
            if exist "%temp%\adaptadores.bat" del "%temp%\adaptadores.bat"
        ) else (
            echo ERROR: No se pudo descargar la herramienta de adaptadores de red
            set /a error_count+=1
        )
    ) else if "%%a"=="apache-jmeter-5.6.3.zip" (
        call :install_zip "https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.zip" "C:\Program Files\apache-jmeter-5.6.3"
    ) else if "%%a"=="mysql-connector-odbc-9.4.0-winx64.msi" (
        call :install_msi "https://dev.mysql.com/get/mysql-connector-odbc-9.4.0-winx64.msi"
    ) else if "%%a"=="mysql-connector-net-9.4.0.msi" (
        call :install_msi "https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-9.4.0.msi"
    ) else if "%%a"=="OfimaBot" (
        call :install_ofimabot
    ) else if "%%a"=="UIPath" (
        call :install_uipath
    ) else if "%%a"=="Office365_32bits" (
        call :install_office365_32bits
    ) else if "%%a"=="Gradle_v9.0.0" (
        call :install_gradle_v9
    ) else if "%%a"=="HelpDesk_Xelerica" (
        call :install_helpdesk_xelerica
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

:: ======== TODAS LAS FUNCIONES DEBEN IR AQUÍ ========

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

:: Intentar Expand-Archive primero, si falla usar método alternativo
powershell -Command "try { Expand-Archive -Path '%zipfile%' -DestinationPath '%dest%' -Force } catch { throw 'PowerShell Archive failed' }" 2>nul
if !errorlevel! neq 0 (
    echo Metodo PowerShell fallo, usando extraccion alternativa...
    :: Usar tar como método alternativo principal (más confiable)
    tar -xf "%zipfile%" -C "%dest%" 2>nul
    if !errorlevel! neq 0 (
        echo Tar fallo, usando VBScript...
        :: Método VBScript como último recurso
        echo Set objShell = CreateObject^("Shell.Application"^) > "%temp%\extract.vbs"
        echo Set objFolder = objShell.NameSpace^("%zipfile%"^) >> "%temp%\extract.vbs"
        echo Set objFolderItem = objShell.NameSpace^("%dest%"^) >> "%temp%\extract.vbs"
        echo If Not objFolder Is Nothing Then objFolderItem.CopyHere objFolder.Items, 256 >> "%temp%\extract.vbs"
        cscript //nologo "%temp%\extract.vbs"
        del "%temp%\extract.vbs"
    )
)

if exist "%zipfile%" del "%zipfile%"
echo Extraccion completada en %dest%

:: Configuraciones específicas por aplicación
if /i "%dest%"=="C:\IBMiAccess_v1r1" (
    if exist "%dest%\IBMiAccess_v1r1\QIBM\ProdData\OS400\QDLS" (
        echo Instalando IBM i Access Client Solutions...
        "%dest%\IBMiAccess_v1\QIBM\ProdData\OS400\QDLS\_ibm_i_access_client_solutions.exe" -i silent
    ) else (
        echo ERROR: Ruta de instalacion de IBM i Access no encontrada
        set /a error_count+=1
    )
) else if /i "%dest%"=="C:\Program Files\apache-maven-3.9.11-bin" (
    set "maven_home=%dest%\apache-maven-3.9.11"
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
) else if /i "%dest%"=="C:\sqldeveloper" (
    echo Configurando SQL Developer...
    if exist "%dest%\sqldeveloper" (
        echo [INFO] SQL Developer instalado correctamente en C:\sqldeveloper
        echo [INFO] Ejecutable disponible en: C:\sqldeveloper\sqldeveloper\bin\sqldeveloper.exe
    ) else (
        echo [INFO] SQL Developer instalado correctamente en C:\sqldeveloper
        echo [INFO] Verifique la estructura de carpetas para localizar el ejecutable
    )
) else if /i "%dest%"=="C:\Program Files\gradle-8.14.3" (
    set "gradle_home=%dest%\gradle-8.14.3"
    if exist "!gradle_home!" (
        echo Configurando variables de entorno para Gradle 8.14.3...
        powershell -Command "[Environment]::SetEnvironmentVariable('GRADLE_HOME', '!gradle_home!', 'Machine')"
        powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!gradle_home!\bin'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
        echo [INFO] Variables GRADLE_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.
    ) else (
        echo ERROR: Directorio de Gradle no encontrado en "!gradle_home!"
        set /a error_count+=1
    )
) else if /i "%dest%"=="C:\Program Files\apache-jmeter-5.6.3" (
    set "jmeter_home=%dest%\apache-jmeter-5.6.3"
    if exist "!jmeter_home!" (
        echo Configurando variables de entorno para Apache JMeter...
        powershell -Command "[Environment]::SetEnvironmentVariable('JMETER_HOME', '!jmeter_home!', 'Machine')"
        powershell -Command "$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!jmeter_home!\bin'; [Environment]::SetEnvironmentVariable('Path', $env:Path, 'Machine')"
        echo [INFO] Variables JMETER_HOME y PATH actualizadas. Reinicie la consola para aplicar cambios.
        echo [INFO] JMeter GUI disponible ejecutando: jmeter
        echo [INFO] JMeter CLI disponible ejecutando: jmeter -n -t test.jmx
    ) else (
        echo ERROR: Directorio de JMeter no encontrado en "!jmeter_home!"
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

echo Verificando archivo descargado...
for %%F in ("%exe_file%") do set file_size=%%~zF
if %file_size% LSS 1000000 (
    echo ERROR: Archivo descargado incompleto ^(tamaño: %file_size% bytes^)
    set /a error_count+=1
    if exist "%exe_file%" del "%exe_file%"
    goto :eof
)

echo Ejecutando instalacion silenciosa...
:: Parámetros específicos para cada aplicación
if /i "%~nx1"=="mongodb-compass-1-46-5.exe" (
    echo Usando parametros silenciosos para MongoDB Compass: /S
    start /wait "" "%exe_file%" /S
    set install_exit_code=!errorlevel!
) else if /i "%~nx1"=="UltraVNC_1436_X64_Setup.exe" (
    echo Usando parametros silenciosos para UltraVNC: /SILENT
    start /wait "" "%exe_file%" /SILENT /NORESTART
    set install_exit_code=!errorlevel!
) else if /i "%~nx1"=="fusioninventory-agent_windows-x64_2.6.exe" (
    echo Usando parametros silenciosos para FusionInventory: /S
    start /wait "" "%exe_file%" /S
    set install_exit_code=!errorlevel!
) else (
    echo Usando parametros silenciosos genericos: /SILENT /NORESTART
    start /wait "" "%exe_file%" /SILENT /NORESTART
    set install_exit_code=!errorlevel!
)

if !install_exit_code! neq 0 (
    echo ERROR en la instalacion ^(codigo de salida: !install_exit_code!^)
    echo Intentando instalacion con parametros alternativos...
    
    :: Intentar con parámetros alternativos para MongoDB Compass
    if /i "%~nx1"=="mongodb-compass-1-46-5.exe" (
        echo Probando con /VERYSILENT /NORESTART...
        start /wait "" "%exe_file%" /VERYSILENT /NORESTART
        set install_exit_code=!errorlevel!
        
        if !install_exit_code! neq 0 (
            echo Probando con /SILENT...
            start /wait "" "%exe_file%" /SILENT
            set install_exit_code=!errorlevel!
        )
    )
    
    if !install_exit_code! neq 0 (
        echo ERROR: Instalacion fallo con todos los parametros intentados
        echo Codigo de salida final: !install_exit_code!
        set /a error_count+=1
    ) else (
        echo Instalacion completada con parametros alternativos
    )
) else (
    echo Instalacion completada correctamente
)

if exist "%exe_file%" del "%exe_file%"
goto :eof

:install_msi
set msi_url=%~1
set msi_file=%temp%\%~nx1

echo Descargando instalador MSI...

:: URLs de respaldo para MySQL Connector
if "%~nx1"=="mysql-connector-odbc-9.4.0-winx64.msi" (
    echo Intentando descarga desde servidor principal...
    powershell -Command "Invoke-WebRequest -Uri '%msi_url%' -OutFile '%msi_file%'"
    
    if not exist "%msi_file%" (
        echo Servidor principal no disponible, probando URL alternativa...
        powershell -Command "Invoke-WebRequest -Uri 'https://cdn.mysql.com/Downloads/Connector-ODBC/9.4/mysql-connector-odbc-9.4.0-winx64.msi' -OutFile '%msi_file%'"
    )
    
    if not exist "%msi_file%" (
        echo Probando espejo de descarga...
        powershell -Command "Invoke-WebRequest -Uri 'https://downloads.mysql.com/archives/get/p/10/file/mysql-connector-odbc-9.4.0-winx64.msi' -OutFile '%msi_file%'"
    )
    
    if not exist "%msi_file%" (
        echo Probando descarga directa desde archivo local...
        powershell -Command "Invoke-WebRequest -Uri 'https://dev.mysql.com/get/mysql-connector-odbc-9.4.0-winx64.msi' -OutFile '%msi_file%'"
    )
) else if "%~nx1"=="mysql-connector-net-9.4.0.msi" (
    echo Intentando descarga desde servidor principal...
    powershell -Command "Invoke-WebRequest -Uri '%msi_url%' -OutFile '%msi_file%'"
    
    if not exist "%msi_file%" (
        echo Servidor principal no disponible, probando URL alternativa...
        powershell -Command "Invoke-WebRequest -Uri 'https://cdn.mysql.com/Downloads/Connector-Net/mysql-connector-net-9.4.0.msi' -OutFile '%msi_file%'"
    )
    
    if not exist "%msi_file%" (
        echo Probando espejo de descarga...
        powershell -Command "Invoke-WebRequest -Uri 'https://downloads.mysql.com/archives/get/p/6/file/mysql-connector-net-9.4.0.msi' -OutFile '%msi_file%'"
    )
    
    if not exist "%msi_file%" (
        echo Probando descarga directa desde archivo local...
        powershell -Command "Invoke-WebRequest -Uri 'https://dev.mysql.com/get/mysql-connector-net-9.4.0.msi' -OutFile '%msi_file%'"
    )
) else (
    :: Para otros MSI usar la URL original
    powershell -Command "Invoke-WebRequest -Uri '%msi_url%' -OutFile '%msi_file%'"
)

if not exist "%msi_file%" (
    echo ERROR: Fallo en la descarga desde todas las fuentes disponibles
    if "%~nx1"=="mysql-connector-odbc-9.4.0-winx64.msi" (
        echo INFO: El sitio de MySQL puede estar experimentando problemas temporales
        echo SOLUCION: Intente nuevamente en unos minutos o descargue manualmente desde:
        echo https://dev.mysql.com/downloads/connector/odbc/
    ) else if "%~nx1"=="mysql-connector-net-9.4.0.msi" (
        echo INFO: El sitio de MySQL puede estar experimentando problemas temporales
        echo SOLUCION: Intente nuevamente en unos minutos o descargue manualmente desde:
        echo https://dev.mysql.com/downloads/connector/net/
    ) else (
        echo INFO: Verifique la URL de descarga e intente nuevamente
    )
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

:install_winget_update
echo Actualizando Microsoft App Installer (Winget)...
set "winget_url=https://aka.ms/getwinget"
set "winget_file=%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

echo Descargando la ultima version de Winget...
powershell -Command "Invoke-WebRequest -Uri '%winget_url%' -OutFile '%winget_file%'"
if not exist "%winget_file%" (
    echo ERROR: Fallo en la descarga de Winget
    set /a error_count+=1
    goto :eof
)

echo Instalando Winget actualizado...
powershell -Command "Add-AppxPackage -Path '%winget_file%'"
if !errorlevel! neq 0 (
    echo ERROR en la instalacion de Winget
    set /a error_count+=1
) else (
    echo Winget actualizado correctamente
    echo [INFO] Reinicie la aplicacion para usar la nueva version de Winget
)
if exist "%winget_file%" del "%winget_file%"
goto :eof

:install_winget_only
echo Instalando Winget (App Installer)...
set "winget_url=https://aka.ms/getwinget"
set "winget_file=%temp%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

echo Descargando instalador de Winget...
powershell -Command "Invoke-WebRequest -Uri '%winget_url%' -OutFile '%winget_file%'"
if not exist "%winget_file%" (
    echo ERROR: Fallo en la descarga de Winget
    set /a error_count+=1
    goto :eof
)

echo Instalando Winget...
powershell -Command "Add-AppxPackage -Path '%winget_file%'"
if !errorlevel! neq 0 (
    echo ERROR en la instalacion de Winget
    set /a error_count+=1
) else (
    echo Winget instalado correctamente
    echo [INFO] Reinicie la aplicacion para usar Winget.
)
if exist "%winget_file%" del "%winget_file%"
goto :eof

:clean_sqldeveloper
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo   LIMPIEZA DE CARPETAS TEMPORALES SQL DEVELOPER
echo ===============================================
echo.

:: Obtener lista de usuarios
echo Usuarios disponibles en el sistema:
echo -----------------------------------
set "user_count=0"
set "user_list="

for /d %%u in ("C:\Users\*") do (
    set "username=%%~nu"
    :: Excluir carpetas del sistema
    if /i not "!username!"=="Public" (
        if /i not "!username!"=="Default" (
            if /i not "!username!"=="All Users" (
                if /i not "!username!"=="Default User" (
                    set /a user_count+=1
                    set "user_!user_count!=!username!"
                    set "user_list=!user_list! !user_count!"
                    echo  !user_count!. !username!
                )
            )
        )
    )
)

if %user_count% equ 0 (
    echo No se encontraron usuarios en el sistema.
    goto :eof
)

echo.
set /p "user_selection=Seleccione el numero del usuario (1-%user_count%): "

:: Validar selección
set "selected_user="
for %%i in (%user_list%) do (
    if "%user_selection%"=="%%i" (
        call set "selected_user=%%user_%%i%%"
    )
)

if not defined selected_user (
    echo ERROR: Seleccion invalida.
    goto :eof
)

echo.
echo Usuario seleccionado: %selected_user%
echo.

:: Verificar y eliminar carpetas de SQL Developer
set "user_profile=C:\Users\%selected_user%"
set "folders_found=0"
set "folders_deleted=0"

echo Buscando carpetas de SQL Developer para el usuario: %selected_user%
echo.

:: Carpeta 1: SQL Developer (con espacio)
set "folder1=%user_profile%\AppData\Roaming\SQL Developer"
if exist "!folder1!" (
    set /a folders_found+=1
    echo [ENCONTRADA] "!folder1!"
    echo Eliminando carpeta "SQL Developer"...
    rmdir /s /q "!folder1!" 2>nul
    if not exist "!folder1!" (
        echo [EXITOSO] Carpeta "SQL Developer" eliminada correctamente
        set /a folders_deleted+=1
    ) else (
        echo [ERROR] No se pudo eliminar la carpeta "SQL Developer"
    )
    echo.
) else (
    echo [NO ENCONTRADA] "!folder1!"
)

:: Carpeta 2: sqldeveloper (sin espacio)
set "folder2=%user_profile%\AppData\Roaming\sqldeveloper"
if exist "!folder2!" (
    set /a folders_found+=1
    echo [ENCONTRADA] "!folder2!"
    echo Eliminando carpeta "sqldeveloper"...
    rmdir /s /q "!folder2!" 2>nul
    if not exist "!folder2!" (
        echo [EXITOSO] Carpeta "sqldeveloper" eliminada correctamente
        set /a folders_deleted+=1
    ) else (
        echo [ERROR] No se pudo eliminar la carpeta "sqldeveloper"
    )
    echo.
) else (
    echo [NO ENCONTRADA] "!folder2!"
)

:: Resumen final
echo ===============================================
echo                   RESUMEN
echo ===============================================
echo Usuario procesado: %selected_user%
echo Carpetas encontradas: %folders_found%
echo Carpetas eliminadas: %folders_deleted%
echo Fecha y hora: %DATE% %TIME%
echo Equipo: %COMPUTERNAME%
echo Ejecutado por: %USERNAME%
echo ===============================================

if %folders_found% equ 0 (
    echo.
    echo No se encontraron carpetas de SQL Developer para este usuario.
) else if %folders_deleted% equ %folders_found% (
    echo.
    echo LIMPIEZA COMPLETADA: Todas las carpetas fueron eliminadas exitosamente.
) else (
    echo.
    echo ATENCION: Algunas carpetas no pudieron ser eliminadas.
    echo Verifique que SQL Developer este cerrado e intente nuevamente.
)

endlocal
goto :eof

:install_npm_appium
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo   INSTALACION DE NPM APPIUM
echo ===============================================
echo.

:: Verificar que Node.js esté instalado
where node >nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: Node.js no esta instalado en el sistema.
    echo Por favor, instale Node.js primero ^(aplicacion 6: OpenJS.NodeJS^).
    set /a error_count+=1
    endlocal
    goto :eof
)

:: Verificar que npm esté disponible
where npm >nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: NPM no esta disponible en el sistema.
    echo Verifique que Node.js este correctamente instalado.
    set /a error_count+=1
    endlocal
    goto :eof
)

:: Obtener lista de usuarios
echo Usuarios disponibles en el sistema:
echo -----------------------------------
set "user_count=0"

for /d %%u in ("C:\Users\*") do (
    set "username=%%~nu"
    if /i not "!username!"=="Public" (
        if /i not "!username!"=="Default" (
            if /i not "!username!"=="All Users" (
                if /i not "!username!"=="Default User" (
                    set /a user_count+=1
                    set "user_!user_count!=!username!"
                    echo  !user_count!. !username!
                )
            )
        )
    )
)

if !user_count! equ 0 (
    echo No se encontraron usuarios en el sistema.
    set /a error_count+=1
    endlocal
    goto :eof
)

echo.
set /p "user_selection=Seleccione el numero del usuario (1-!user_count!): "

:: Validar selección usando método directo
set "selected_user="
if "!user_selection!"=="1" set "selected_user=!user_1!"
if "!user_selection!"=="2" set "selected_user=!user_2!"
if "!user_selection!"=="3" set "selected_user=!user_3!"
if "!user_selection!"=="4" set "selected_user=!user_4!"
if "!user_selection!"=="5" set "selected_user=!user_5!"

if not defined selected_user (
    echo ERROR: Seleccion invalida.
    set /a error_count+=1
    endlocal
    goto :eof
)

echo.
echo Usuario seleccionado: !selected_user!
echo.

:: Definir rutas
set "user_profile=C:\Users\!selected_user!"
set "npm_folder=!user_profile!\AppData\Roaming\npm"

:: Crear carpeta npm si no existe
if not exist "!npm_folder!" (
    echo Creando carpeta npm en: !npm_folder!
    mkdir "!npm_folder!" 2>nul
    if not exist "!npm_folder!" (
        echo ERROR: No se pudo crear la carpeta npm
        set /a error_count+=1
        endlocal
        goto :eof
    )
    echo [EXITOSO] Carpeta npm creada correctamente
) else (
    echo [INFO] La carpeta npm ya existe en: !npm_folder!
)

:: Preguntar sobre ExecutionPolicy
echo.
echo ===============================================
echo   CONFIGURACION DE EXECUTION POLICY
echo ===============================================
echo.
echo Para evitar problemas con la instalacion de Appium,
echo se recomienda configurar la ExecutionPolicy a RemoteSigned.
echo.
choice /C SN /N /M "Desea ejecutar Set-ExecutionPolicy RemoteSigned? [S]i [N]o: "
if !errorlevel! equ 1 (
    echo.
    echo Configurando ExecutionPolicy a RemoteSigned...
    powershell -Command "try { Set-ExecutionPolicy RemoteSigned -Force -Scope LocalMachine; Write-Host 'ExecutionPolicy configurada' } catch { Write-host 'Error al cambiar ExecutionPolicy' }" 2>nul
    echo [INFO] ExecutionPolicy procesada
) else (
    echo [INFO] ExecutionPolicy no modificada. Continuando...
)

echo.
echo ===============================================
echo   INSTALANDO APPIUM GLOBALMENTE
echo ===============================================
echo.
echo Instalando Appium en: !npm_folder!
echo Esto puede tomar varios minutos...
echo.

:: Cambiar al directorio npm
echo Cambiando al directorio: !npm_folder!
if exist "!npm_folder!" (
    pushd "!npm_folder!"
) else (
    echo ERROR: La carpeta !npm_folder! no existe.
    set /a error_count+=1
    endlocal
    goto :eof
)

:: Configurar npm para usar el directorio actual
echo Configurando npm prefix...
call npm config set prefix "!npm_folder!"
call npm config set cache "!npm_folder!\npm-cache"

:: Mostrar configuración actual
echo Configuracion npm actual:
call npm config get prefix
call npm config get cache

:: Instalar Appium
echo.
echo ========== INICIANDO INSTALACION DE APPIUM ==========
echo Ejecutando: npm install -g appium
call npm install -g appium
set "install_result=!errorlevel!"

echo Codigo de salida de npm: !install_result!

if !install_result! neq 0 (
    echo.
    echo ERROR: Fallo la instalacion de Appium (codigo: !install_result!)
    echo Intentando instalacion alternativa...
    
    echo Ejecutando: npm install -g appium --force --verbose
    call npm install -g appium --force --verbose
    set "install_result=!errorlevel!"
    
    if !install_result! neq 0 (
        echo ERROR: La instalacion de Appium fallo con todos los metodos
        echo Codigo de salida final: !install_result!
        set /a error_count+=1
        popd
        endlocal
        goto :eof
    )
)

popd

:: Verificar instalación
echo.
echo Verificando instalacion...
if exist "!npm_folder!\appium.cmd" (
    echo [VERIFICADO] Executable de Appium encontrado: !npm_folder!\appium.cmd
) else if exist "!npm_folder!\node_modules\.bin\appium.cmd" (
    echo [VERIFICADO] Executable de Appium encontrado: !npm_folder!\node_modules\.bin\appium.cmd
) else if exist "!npm_folder!\appium" (
    echo [VERIFICADO] Script de Appium encontrado: !npm_folder!\appium
) else (
    echo [ADVERTENCIA] No se encontro el executable de Appium en las ubicaciones esperadas
    echo Contenido de !npm_folder!:
    dir "!npm_folder!" | findstr appium
)

:: Agregar npm folder al PATH del sistema
echo.
echo ===============================================
echo   CONFIGURANDO VARIABLES DE ENTORNO
echo ===============================================
echo.
echo Agregando !npm_folder! al PATH del sistema...

:: Obtener PATH actual
for /f "skip=2 tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "current_path=%%b"

:: Verificar si la ruta ya está en PATH
echo !current_path! | findstr /i "!npm_folder!" >nul
if !errorlevel! equ 0 (
    echo [INFO] La ruta !npm_folder! ya esta en el PATH del sistema
) else (
    echo Agregando al PATH: !npm_folder!
    powershell -Command "try { [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!npm_folder!', 'Machine'); Write-Host 'PATH actualizado correctamente' } catch { Write-Host 'Error al actualizar PATH' }"
    echo [INFO] Ruta agregada al PATH del sistema
)

:: También agregar la carpeta de binarios si existe
set "npm_bin_folder=!npm_folder!\node_modules\.bin"
if exist "!npm_bin_folder!" (
    echo !current_path! | findstr /i "!npm_bin_folder!" >nul
    if !errorlevel! neq 0 (
        echo Agregando al PATH: !npm_bin_folder!
        powershell -Command "try { [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';!npm_bin_folder!', 'Machine'); Write-Host 'PATH de binarios actualizado' } catch { Write-Host 'Error al actualizar PATH de binarios' }"
        echo [INFO] Ruta de binarios agregada al PATH del sistema
    )
)

:: Resumen final
echo.
echo ===============================================
echo                   RESUMEN
echo ===============================================
echo Usuario seleccionado: !selected_user!
echo Carpeta npm: !npm_folder!
echo Fecha y hora: %DATE% %TIME%
echo Equipo: %COMPUTERNAME%
echo Ejecutado por: %USERNAME%
echo ===============================================
echo.
echo [INFO] Para usar Appium desde cualquier ubicacion:
echo [INFO] 1. Reinicie la consola/terminal
echo [INFO] 2. Ejecute: appium --version
echo [INFO] 3. Para iniciar Appium: appium
echo [INFO] 4. Si no funciona, agregue manualmente al PATH: !npm_folder!
echo ===============================================

endlocal
goto :eof

:search_applications
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo          BUSQUEDA DE APLICACIONES
echo ===============================================
echo.
echo Ingrese una palabra clave para buscar aplicaciones:
echo (Ejemplos: java, microsoft, git, gradle, etc.)
echo.
set /p "search_term=Palabra clave: "

if "!search_term!"=="" (
    echo ERROR: Debe ingresar una palabra clave.
    endlocal
    goto :eof
)

echo.
echo Buscando aplicaciones que contengan: "!search_term!"
echo ===============================================

:: Buscar aplicaciones que contengan el término
set "found_count=0"
set "found_apps="
set "found_numbers="

for /l %%i in (1,1,75) do (
    if defined apps[%%i] (
        set "app_name=!apps[%%i]!"
        echo !app_name! | findstr /i "!search_term!" >nul
        if !errorlevel! equ 0 (
            set /a found_count+=1
            set "found_apps=!found_apps! %%i"
            echo  %%i. !app_name!
        )
    )
)

if !found_count! equ 0 (
    echo.
    echo No se encontraron aplicaciones que contengan "!search_term!".
    echo.
    echo Sugerencias:
    echo - Verifique la ortografia
    echo - Use terminos mas generales (ej: "java" en lugar de "openjdk")
    echo - Use palabras clave en ingles
    endlocal
    goto :eof
)

echo.
echo ===============================================
echo Se encontraron !found_count! aplicacion(es)
echo ===============================================
echo.
echo Opciones:
echo [1] Seleccionar todas las aplicaciones encontradas
echo [2] Seleccionar aplicaciones especificas
echo [3] Volver al menu principal
echo.
set /p "search_action=Seleccione una opcion (1-3): "

if "!search_action!"=="1" (
    :: Seleccionar todas las encontradas
    call :install_found_apps "!found_apps!"
) else if "!search_action!"=="2" (
    :: Selección específica
    call :select_specific_apps "!found_apps!"
) else if "!search_action!"=="3" (
    endlocal
    goto :eof
) else (
    echo Opcion invalida.
    endlocal
    goto :eof
)

endlocal
goto :eof

:install_found_apps
setlocal enabledelayedexpansion
set "selected_apps=%~1"

echo.
echo Aplicaciones seleccionadas para instalacion:
echo -------------------------------------------
set "applications="
for %%i in (!selected_apps!) do (
    echo  %%i. !apps[%%i]!
    set "applications=!applications! !apps[%%i]!"
)

echo.
echo ¿Instalar estas aplicaciones?
choice /C SN /N /M "[S]i  [N]o: "
if !errorlevel! equ 2 (
    endlocal
    goto :eof
)

:: Proceso de instalación (usar el mismo código del proceso principal)
call :process_installation "!applications!"

endlocal
goto :eof

:select_specific_apps
setlocal enabledelayedexpansion
set "available_apps=%~1"

echo.
echo Aplicaciones disponibles:
echo ------------------------
for %%i in (!available_apps!) do (
    echo  %%i. !apps[%%i]!
)

echo.
echo Ingrese los numeros de las aplicaciones que desea instalar
echo (separados por comas, ej: 2,5,7 o rangos como 2-5):
set /p "specific_selection=Seleccion: "

if "!specific_selection!"=="" (
    echo No se selecciono ninguna aplicacion.
    endlocal
    goto :eof
)

:: Validar que los números seleccionados estén en la lista de encontrados
set "valid_selection="
set "applications="

:: Expandir rangos y comas
for %%a in ("!specific_selection:,=" "%") do (
    set "range=%%~a"
    if "!range:-=!" neq "!range!" (
        :: Es un rango
        for /f "tokens=1,2 delims=-" %%b in ("!range!") do (
            for /l %%k in (%%b,1,%%c) do (
                :: Verificar que el número esté en la lista de encontrados
                for %%j in (!available_apps!) do (
                    if %%k equ %%j (
                        set "valid_selection=!valid_selection! %%k"
                        set "applications=!applications! !apps[%%k]!"
                    )
                )
            )
        )
    ) else (
        :: Es un número individual
        for %%j in (!available_apps!) do (
            if !range! equ %%j (
                set "valid_selection=!valid_selection! !range!"
                set "applications=!applications! !apps[%%j]!"
            )
        )
    )
)

if "!applications!"=="" (
    echo ERROR: No se seleccionaron aplicaciones validas.
    endlocal
    goto :eof
)

echo.
echo Aplicaciones seleccionadas:
echo --------------------------
for %%a in (!applications!) do echo  - %%a

echo.
echo ¿Instalar estas aplicaciones?
choice /C SN /N /M "[S]i  [N]o: "
if !errorlevel! equ 2 (
    endlocal
    goto :eof
)

:: Proceso de instalación
call :process_installation "!applications!"

endlocal
goto :eof

:process_installation
setlocal enabledelayedexpansion
set "applications=%~1"

:: Proceso de instalación (copiar desde el código principal)
set error_count=0
set application_count=0

echo.
echo Iniciando instalaciones desde busqueda...
for %%a in (!applications!) do (
    set /a application_count+=1
    echo.
    echo [%time%] Instalando %%a...
    
    :: Usar la misma lógica de instalación del código principal
    if "%%a"=="IBMiAccess_v1r1.zip" (
        call :install_zip "https://www.nicklitten.com/wp-content/uploads/IBMiAccess_v1r1.zip" "C:\IBMiAccess_v1r1"
    ) else if "%%a"=="apache-maven-3.9.11-bin.zip" (
        call :install_zip "https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.zip" "C:\Program Files\apache-maven-3.9.11-bin"
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
    ) else if "%%a"=="npm_appium" (
        call :install_npm_appium
    ) else if "%%a"=="Gestion_Hosts" (
        echo Descargando herramienta de gestion de hosts...
        curl -o "%temp%\configuraciones.bat" "https://raw.githubusercontent.com/GAMEZ1125/InstaladorApps-Bat/main/configuraciones.bat" 2>nul
        if exist "%temp%\configuraciones.bat" (
            echo Ejecutando gestion de hosts...
            call "%temp%\configuraciones.bat"
            if exist "%temp%\configuraciones.bat" del "%temp%\configuraciones.bat"
        ) else (
            echo ERROR: No se pudo descargar la herramienta de configuracion
            set /a error_count+=1
        )
    ) else if "%%a"=="apache-jmeter-5.6.3.zip" (
        call :install_zip "https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.zip" "C:\Program Files\apache-jmeter-5.6.3"
    ) else if "%%a"=="mysql-connector-odbc-9.4.0-winx64.msi" (
        call :install_msi "https://dev.mysql.com/get/mysql-connector-odbc-9.4.0-winx64.msi"
    ) else if "%%a"=="mysql-connector-net-9.4.0.msi" (
        call :install_msi "https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-9.4.0.msi"
    ) else if "%%a"=="OfimaBot" (
        call :install_ofimabot
    ) else if "%%a"=="UIPath" (
        call :install_uipath
    ) else if "%%a"=="Office365_32bits" (
        call :install_office365_32bits
    ) else if "%%a"=="Gradle_v9.0.0" (
        call :install_gradle_v9
    ) else if "%%a"=="HelpDesk_Xelerica" (
        call :install_helpdesk_xelerica
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
echo ===============================================
echo      RESUMEN DE INSTALACION POR BUSQUEDA
echo ===============================================
echo Aplicaciones procesadas: !application_count!
echo Errores: !error_count!
if !error_count! gtr 0 echo Verifique los errores e intente instalar manualmente.
echo ===============================================

endlocal
goto :eof

:install_ofimabot
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo           INSTALACION DE OFIMABOT
echo ===============================================
echo.

set "ofimabot_url=https://www.ofima.com/wp-content/uploads/2024/03/Ofimabot.zip"
set "ofimabot_zip=%temp%\Ofimabot.zip"
set "extract_dir=%temp%\ofimabot_extract"

echo Descargando OfimaBot desde: %ofimabot_url%
powershell -Command "try { Invoke-WebRequest -Uri '%ofimabot_url%' -OutFile '%ofimabot_zip%' -UseBasicParsing } catch { Write-Host 'Error en descarga' }"

if not exist "%ofimabot_zip%" (
    echo ERROR: Fallo en la descarga de OfimaBot
    echo Verifique la conexion a internet e intente nuevamente.
    set /a error_count+=1
    endlocal
    goto :eof
)

echo Verificando archivo descargado...
for %%F in ("%ofimabot_zip%") do set file_size=%%~zF
if %file_size% LSS 10000 (
    echo ERROR: Archivo descargado incompleto ^(tamaño: %file_size% bytes^)
    echo El archivo puede estar corrupto o la URL no es valida.
    set /a error_count+=1
    if exist "%ofimabot_zip%" del "%ofimabot_zip%"
    endlocal
    goto :eof
)

echo [INFO] Archivo descargado correctamente ^(tamaño: %file_size% bytes^)

echo.
echo Extrayendo OfimaBot...
if not exist "%extract_dir%" mkdir "%extract_dir%"

:: Intentar extracción con PowerShell primero
powershell -Command "try { Expand-Archive -Path '%ofimabot_zip%' -DestinationPath '%extract_dir%' -Force; Write-Host 'Extraccion PowerShell exitosa' } catch { Write-Host 'Error en extraccion PowerShell' }"

:: Verificar si la extracción fue exitosa
set "exe_found="
for /r "%extract_dir%" %%f in (*.exe) do (
    if /i "%%~nf"=="Ofimabot" (
        set "exe_found=%%f"
        echo [ENCONTRADO] Ejecutable: %%f
    )
)

:: Si no se encontró con PowerShell, intentar con tar
if not defined exe_found (
    echo Intentando extraccion alternativa con tar...
    tar -xf "%ofimabot_zip%" -C "%extract_dir%" 2>nul
    
    :: Buscar nuevamente el ejecutable
    for /r "%extract_dir%" %%f in (*.exe) do (
        if /i "%%~nf"=="Ofimabot" (
            set "exe_found=%%f"
            echo [ENCONTRADO] Ejecutable: %%f
        )
    )
)

:: Si aún no se encuentra, intentar con VBScript
if not defined exe_found (
    echo Intentando extraccion con VBScript...
    echo Set objShell = CreateObject^("Shell.Application"^) > "%temp%\extract_ofimabot.vbs"
    echo Set objFolder = objShell.NameSpace^("%ofimabot_zip%"^) >> "%temp%\extract_ofimabot.vbs"
    echo Set objFolderItem = objShell.NameSpace^("%extract_dir%"^) >> "%temp%\extract_ofimabot.vbs"
    echo If Not objFolder Is Nothing Then objFolderItem.CopyHere objFolder.Items, 256 >> "%temp%\extract_ofimabot.vbs"
    cscript //nologo "%temp%\extract_ofimabot.vbs" 2>nul
    del "%temp%\extract_ofimabot.vbs"
    
    :: Buscar una vez más el ejecutable
    for /r "%extract_dir%" %%f in (*.exe) do (
        if /i "%%~nf"=="Ofimabot" (
            set "exe_found=%%f"
            echo [ENCONTRADO] Ejecutable: %%f
        )
    )
)

if not defined exe_found (
    echo ERROR: No se pudo encontrar Ofimabot.exe en el archivo extraido
    echo Contenido del directorio extraido:
    dir "%extract_dir%" /s /b 2>nul | findstr /i "\.exe"
    set /a error_count+=1
    goto :cleanup_ofimabot
)

echo.
echo Instalando OfimaBot silenciosamente...
echo Ejecutable encontrado en: !exe_found!

:: Intentar instalación silenciosa con diferentes parámetros
echo Probando instalacion con parametros silenciosos /S...
start /wait "" "!exe_found!" /S
set install_result=!errorlevel!

if !install_result! neq 0 (
    echo Primer intento fallo ^(codigo: !install_result!^), probando con /SILENT...
    start /wait "" "!exe_found!" /SILENT /NORESTART
    set install_result=!errorlevel!
)

if !install_result! neq 0 (
    echo Segundo intento fallo ^(codigo: !install_result!^), probando con /VERYSILENT...
    start /wait "" "!exe_found!" /VERYSILENT /NORESTART
    set install_result=!errorlevel!
)

if !install_result! neq 0 (
    echo Tercer intento fallo ^(codigo: !install_result!^), probando con /q...
    start /wait "" "!exe_found!" /q
    set install_result=!errorlevel!
)

if !install_result! neq 0 (
    echo ERROR: La instalacion de OfimaBot fallo con todos los parametros intentados
    echo Codigo de salida final: !install_result!
    echo.
    echo SOLUCION MANUAL:
    echo 1. El ejecutable se encuentra en: !exe_found!
    echo 2. Ejecute manualmente la instalacion
    echo 3. O intente con otros parametros silenciosos
    set /a error_count+=1
) else (
    echo.
    echo ===============================================
    echo    OFIMABOT INSTALADO CORRECTAMENTE
    echo ===============================================
    echo [EXITOSO] OfimaBot se ha instalado silenciosamente
    echo [INFO] Verifique el menu de inicio o escritorio para acceder a OfimaBot
    echo [INFO] La aplicacion deberia estar disponible en Programs Files
)

:cleanup_ofimabot
echo.
echo Limpiando archivos temporales...
if exist "%ofimabot_zip%" del "%ofimabot_zip%"
if exist "%extract_dir%" (
    rmdir /s /q "%extract_dir%" 2>nul
)

echo [INFO] Limpieza completada

endlocal
goto :eof

:install_uipath
setlocal enabledelayedexpansion
echo.
echo ===============================================
echo           INSTALACION DE UIPATH
echo ===============================================
echo.

set "uipath_url=https://download.uipath.com/UiPathStudioCommunity.msi"
set "uipath_msi=%temp%\UiPathStudioCommunity.msi"

echo Descargando UIPath Studio Community desde: %uipath_url%
powershell -Command "try { Invoke-WebRequest -Uri '%uipath_url%' -OutFile '%uipath_msi%' -UseBasicParsing } catch { Write-Host 'Error en descarga' }"

if not exist "%uipath_msi%" (
    echo ERROR: Fallo en la descarga de UIPath Studio Community
    echo SOLUCION: Verifique su conexion a internet e intente nuevamente
    echo URL: %uipath_url%
    set /a error_count+=1
    goto :cleanup_uipath
)

:: Verificar tamaño del archivo (debe ser mayor a 1MB)
for %%F in ("%uipath_msi%") do set file_size=%%~zF
if %file_size% lss 1048576 (
    echo ERROR: El archivo descargado parece estar incompleto o corrupto
    echo Tamaño del archivo: %file_size% bytes
    if exist "%uipath_msi%" del "%uipath_msi%"
    set /a error_count+=1
    goto :cleanup_uipath
)

echo Archivo descargado correctamente. Tamaño: %file_size% bytes
echo.
echo Ejecutando instalacion silenciosa de UIPath Studio Community...
echo [INFO] Esto puede tomar varios minutos, por favor espere...

:: Instalar UIPath de manera silenciosa
start /wait msiexec.exe /i "%uipath_msi%" /qn /norestart ADDLOCAL=ALL

if !errorlevel! neq 0 (
    echo ERROR: Fallo en la instalacion de UIPath Studio Community
    echo Codigo de error: !errorlevel!
    echo.
    echo POSIBLES SOLUCIONES:
    echo 1. Ejecute el script como administrador
    echo 2. Verifique que tenga suficiente espacio en disco
    echo 3. Cierre otras aplicaciones que puedan interferir
    echo 4. Intente instalar manualmente desde: %uipath_msi%
    set /a error_count+=1
) else (
    echo [EXITOSO] UIPath Studio Community se ha instalado correctamente
    echo [INFO] Verifique el menu de inicio o escritorio para acceder a UIPath
    echo [INFO] La aplicacion deberia estar disponible en Programs Files
)

:cleanup_uipath
echo.
echo Limpiando archivos temporales...
if exist "%uipath_msi%" del "%uipath_msi%"

echo [INFO] Limpieza completada

endlocal
goto :eof

:install_office365_32bits
setlocal enabledelayedexpansion
echo.
echo ===============================================
echo       INSTALACION DE OFFICE 365 32-BITS
echo ===============================================
echo.

set "office365_url=https://descargas-xelerica.netlify.app/assets/downloads/OfficeSetup32.exe"
set "office365_exe=%temp%\OfficeSetup32.exe"

echo Descargando Office 365 32-bits desde: %office365_url%
powershell -Command "try { Invoke-WebRequest -Uri '%office365_url%' -OutFile '%office365_exe%' -UseBasicParsing } catch { Write-Host 'Error en descarga' }"

if not exist "%office365_exe%" (
    echo ERROR: Fallo en la descarga de Office 365 32-bits
    echo SOLUCION: Verifique su conexion a internet e intente nuevamente
    echo URL: %office365_url%
    set /a error_count+=1
    goto :cleanup_office365
)

:: Verificar tamaño del archivo (debe ser mayor a 5MB)
for %%F in ("%office365_exe%") do set file_size=%%~zF
if %file_size% lss 5242880 (
    echo ERROR: El archivo descargado parece estar incompleto o corrupto
    echo Tamaño del archivo: %file_size% bytes
    if exist "%office365_exe%" del "%office365_exe%"
    set /a error_count+=1
    goto :cleanup_office365
)

echo Archivo descargado correctamente. Tamaño: %file_size% bytes
echo.
echo Ejecutando instalacion silenciosa de Office 365 32-bits...
echo [INFO] Esto puede tomar varios minutos, por favor espere...

:: Office Click-to-Run usa parametros especificos
echo Intentando instalacion con parametros de Office Click-to-Run...

:: Metodo 1: Sin parametros (instalacion automatica)
echo Probando instalacion automatica sin parametros...
start /wait "%office365_exe%"
set install_result=!errorlevel!

if !install_result! neq 0 (
    echo Primer intento fallo ^(codigo: !install_result!^), probando con /configure...
    
    :: Crear archivo de configuracion temporal para instalacion silenciosa
    echo ^<?xml version="1.0" encoding="UTF-8"?^> > "%temp%\office_config.xml"
    echo ^<Configuration^> >> "%temp%\office_config.xml"
    echo   ^<Add OfficeClientEdition="32" Channel="Current"^> >> "%temp%\office_config.xml"
    echo     ^<Product ID="O365ProPlusRetail"^> >> "%temp%\office_config.xml"
    echo       ^<Language ID="es-es" /^> >> "%temp%\office_config.xml"
    echo     ^</Product^> >> "%temp%\office_config.xml"
    echo   ^</Add^> >> "%temp%\office_config.xml"
    echo   ^<Display Level="None" AcceptEULA="TRUE" /^> >> "%temp%\office_config.xml"
    echo ^</Configuration^> >> "%temp%\office_config.xml"
    
    start /wait "%office365_exe%" /configure "%temp%\office_config.xml"
    set install_result=!errorlevel!
    
    if exist "%temp%\office_config.xml" del "%temp%\office_config.xml"
)

if !install_result! neq 0 (
    echo ERROR: Fallo en la instalacion de Office 365 32-bits con todos los metodos
    echo Codigo de error final: !install_result!
    echo.
    echo NOTA: Este instalador de Office Click-to-Run no acepta parametros tradicionales como "/quiet" o "/silent"
    echo.
    echo METODOS INTENTADOS:
    echo 1. Instalacion automatica sin parametros
    echo 2. Instalacion con archivo de configuracion XML
    echo.
    echo POSIBLES SOLUCIONES:
    echo 1. Ejecute el script como administrador
    echo 2. Verifique que tenga suficiente espacio en disco (minimo 4GB)
    echo 3. Cierre otras aplicaciones de Office que puedan interferir
    echo 4. Desinstale versiones previas de Office antes de continuar
    echo 5. Verifique conexion a internet (Office se descarga durante instalacion)
    echo 6. Intente instalar manualmente desde: %office365_exe%
    set /a error_count+=1
 else (
    echo [EXITOSO] Office 365 32-bits se ha iniciado correctamente
    echo [INFO] Office Click-to-Run continuara la instalacion en segundo plano
    echo [INFO] Las aplicaciones estaran disponibles cuando termine la descarga e instalacion
    echo [INFO] Verifique el menu de inicio en unos minutos para acceder a las aplicaciones
    echo [INFO] El proceso puede tomar entre 10-30 minutos dependiendo de su conexion
)

:cleanup_office365
echo.
echo Limpiando archivos temporales...
if exist "%office365_exe%" del "%office365_exe%"

echo [INFO] Limpieza completada

endlocal
goto :eof

:install_gradle_v9
setlocal enabledelayedexpansion
echo.
echo ===============================================
echo         INSTALACION DE GRADLE v9.0.0
echo ===============================================
echo.

set "gradle_url=https://services.gradle.org/distributions/gradle-9.0.0-all.zip"
set "gradle_zip=%temp%\gradle-9.0.0-all.zip"
set "gradle_extract=%temp%\gradle_extract"
set "gradle_install=C:\Program Files\gradle-9.0.0"

echo Descargando Gradle 9.0.0 desde: %gradle_url%
powershell -Command "try { Invoke-WebRequest -Uri '%gradle_url%' -OutFile '%gradle_zip%' -UseBasicParsing } catch { Write-Host 'Error en descarga' }"

if not exist "%gradle_zip%" (
    echo ERROR: Fallo en la descarga de Gradle 9.0.0
    echo SOLUCION: Verifique su conexion a internet e intente nuevamente
    echo URL: %gradle_url%
    set /a error_count+=1
    goto :cleanup_gradle
)

:: Verificar tamaño del archivo (debe ser mayor a 100MB)
for %%F in ("%gradle_zip%") do set file_size=%%~zF
if %file_size% lss 104857600 (
    echo ERROR: El archivo descargado parece estar incompleto o corrupto
    echo Tamaño del archivo: %file_size% bytes
    if exist "%gradle_zip%" del "%gradle_zip%"
    set /a error_count+=1
    goto :cleanup_gradle
)

echo Archivo descargado correctamente. Tamaño: %file_size% bytes
echo.

:: Crear directorio de extracción temporal
if exist "%gradle_extract%" rmdir /s /q "%gradle_extract%" 2>nul
mkdir "%gradle_extract%" 2>nul

echo Extrayendo Gradle 9.0.0...
powershell -Command "Expand-Archive -Path '%gradle_zip%' -DestinationPath '%gradle_extract%' -Force"

if not exist "%gradle_extract%\gradle-9.0.0" (
    echo ERROR: Fallo en la extraccion de Gradle
    set /a error_count+=1
    goto :cleanup_gradle
)

echo Instalando Gradle en: %gradle_install%

:: Crear directorio de instalacion si no existe
if not exist "C:\Program Files" mkdir "C:\Program Files" 2>nul
if exist "%gradle_install%" rmdir /s /q "%gradle_install%" 2>nul

:: Mover archivos extraidos al directorio de instalacion
move "%gradle_extract%\gradle-9.0.0" "%gradle_install%" >nul 2>&1

if not exist "%gradle_install%\bin\gradle.bat" (
    echo ERROR: Fallo en la instalacion de Gradle
    echo No se encontro el archivo gradle.bat en el directorio de instalacion
    set /a error_count+=1
    goto :cleanup_gradle
)

echo Configurando variables de entorno...

:: Configurar GRADLE_HOME
setx GRADLE_HOME "%gradle_install%" /M >nul 2>&1
if !errorlevel! neq 0 (
    echo ADVERTENCIA: No se pudo configurar GRADLE_HOME como variable de sistema
    echo Intentando configurar para el usuario actual...
    setx GRADLE_HOME "%gradle_install%" >nul 2>&1
)

:: Obtener PATH actual del sistema
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "system_path=%%b"

:: Verificar si Gradle ya esta en el PATH
echo !system_path! | find /i "gradle" >nul
if !errorlevel! neq 0 (
    echo Agregando Gradle al PATH del sistema...
    setx PATH "!system_path!;%gradle_install%\bin" /M >nul 2>&1
    if !errorlevel! neq 0 (
        echo ADVERTENCIA: No se pudo agregar Gradle al PATH del sistema
        echo Agregando al PATH del usuario actual...
        setx PATH "%PATH%;%gradle_install%\bin" >nul 2>&1
    )
) else (
    echo Gradle ya esta configurado en el PATH del sistema
)

:: Actualizar PATH para la sesion actual
set "PATH=%PATH%;%gradle_install%\bin"
set "GRADLE_HOME=%gradle_install%"

echo.
echo Verificando la instalacion...
"%gradle_install%\bin\gradle.bat" --version >nul 2>&1
if !errorlevel! equ 0 (
    echo [EXITOSO] Gradle 9.0.0 se ha instalado correctamente
    echo [INFO] GRADLE_HOME configurado en: %gradle_install%
    echo [INFO] Gradle agregado al PATH del sistema
    echo [INFO] Reinicie su terminal para usar los comandos de Gradle
    echo [INFO] Puede verificar la instalacion con: gradle --version
) else (
    echo ERROR: La instalacion de Gradle parece haber fallado
    echo El comando 'gradle --version' no funciona correctamente
    set /a error_count+=1
)

:cleanup_gradle
echo.
echo Limpiando archivos temporales...
if exist "%gradle_zip%" del "%gradle_zip%" >nul 2>&1
if exist "%gradle_extract%" rmdir /s /q "%gradle_extract%" >nul 2>&1

echo [INFO] Limpieza completada

endlocal
goto :eof

:install_helpdesk_xelerica
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo       INSTALACION DE HELPDESK XELERICA
echo ===============================================
echo.

:: URL del icono y enlace
set "icon_url=https://www.xelerica.com/assets/images/icono.ico"
set "shortcut_url=https://helpdesksupport1743707502741.servicedesk.atera.com/login?redirectTo=tickets%%2Fadd&agentId=bfd8ec9f-cb38-4cc1-9d7b-f144e08f9ad4"
set "shortcut_name=HelpDesk Xelerica"
set "icon_file=%temp%\xelerica_icon.ico"

:: Obtener lista de usuarios
echo Usuarios disponibles en el sistema:
echo -----------------------------------
set "user_count=0"

for /d %%u in ("C:\Users\*") do (
    set "username=%%~nu"
    
    :: Lista simple de exclusiones
    if not "!username!"=="Public" (
        if not "!username!"=="Default" (
            if not "!username!"=="All Users" (
                if not "!username!"=="Default User" (
                    if not "!username!"=="DefaultAppPool" (
                        if not "!username!"=="Administrator" (
                            :: Verificar que no sea muy corto
                            if not "!username:~2,1!"=="" (
                                set /a user_count+=1
                                set "user_!user_count!=!username!"
                                echo  !user_count!. !username!
                            )
                        )
                    )
                )
            )
        )
    )
)

if !user_count! equ 0 (
    echo ADVERTENCIA: No se encontraron usuarios regulares en el sistema.
    echo.
    echo Mostrando todos los usuarios disponibles (incluyendo sistema):
    echo -----------------------------------------------------------
    set "user_count=0"
    
    for /d %%u in ("C:\Users\*") do (
        set "username=%%~nu"
        if /i not "!username!"=="Public" (
            if /i not "!username!"=="Default" (
                if /i not "!username!"=="All Users" (
                    if /i not "!username!"=="Default User" (
                        set /a user_count+=1
                        set "user_!user_count!=!username!"
                        echo  !user_count!. !username!
                    )
                )
            )
        )
    )
    
    if !user_count! equ 0 (
        echo ERROR: No se encontraron usuarios en el sistema.
        set /a error_count+=1
        endlocal
        goto :eof
    )
)

echo.
set /p "user_selection=Seleccione el numero del usuario (1-!user_count!): "

:: Validar selección
set "selected_user="
if "!user_selection!"=="1" set "selected_user=!user_1!"
if "!user_selection!"=="2" set "selected_user=!user_2!"
if "!user_selection!"=="3" set "selected_user=!user_3!"
if "!user_selection!"=="4" set "selected_user=!user_4!"
if "!user_selection!"=="5" set "selected_user=!user_5!"
if "!user_selection!"=="6" set "selected_user=!user_6!"
if "!user_selection!"=="7" set "selected_user=!user_7!"
if "!user_selection!"=="8" set "selected_user=!user_8!"
if "!user_selection!"=="9" set "selected_user=!user_9!"
if "!user_selection!"=="10" set "selected_user=!user_10!"

:: Verificar que la seleccion sea valida
if not defined selected_user (
    if !user_selection! gtr 0 if !user_selection! leq !user_count! (
        call set "selected_user=%%user_!user_selection!%%"
    )
)

if not defined selected_user (
    echo ERROR: Seleccion invalida.
    set /a error_count+=1
    endlocal
    goto :eof
)

echo.
echo Usuario seleccionado: !selected_user!
echo.

:: Determinar ruta del escritorio
set "user_profile=C:\Users\!selected_user!"
set "desktop_path="

:: Verificar si existe OneDrive y si el escritorio esta ahi
set "onedrive_desktop=!user_profile!\OneDrive\Desktop"
set "local_desktop=!user_profile!\Desktop"

if exist "!onedrive_desktop!" (
    echo [INFO] Escritorio de OneDrive encontrado: !onedrive_desktop!
    set "desktop_path=!onedrive_desktop!"
) else if exist "!local_desktop!" (
    echo [INFO] Escritorio local encontrado: !local_desktop!
    set "desktop_path=!local_desktop!"
) else (
    echo ADVERTENCIA: No se encontro carpeta de escritorio para el usuario !selected_user!
    echo Rutas verificadas:
    echo - !onedrive_desktop!
    echo - !local_desktop!
    echo.
    echo Intentando crear carpeta Desktop local...
    mkdir "!local_desktop!" 2>nul
    if exist "!local_desktop!" (
        echo [EXITOSO] Carpeta Desktop creada: !local_desktop!
        set "desktop_path=!local_desktop!"
    ) else (
        echo ERROR: No se pudo crear la carpeta del escritorio
        echo SOLUCION: Verifique que el usuario !selected_user! exista y tenga permisos
        set /a error_count+=1
        endlocal
        goto :eof
    )
)

echo Ruta del escritorio: !desktop_path!
echo.

:: Descargar icono
echo Descargando icono de Xelerica...
powershell -Command "try { Invoke-WebRequest -Uri '%icon_url%' -OutFile '%icon_file%' -UseBasicParsing } catch { Write-Host 'Error en descarga del icono' }"

if not exist "%icon_file%" (
    echo ADVERTENCIA: No se pudo descargar el icono. Se creara el acceso directo sin icono.
    set "icon_file="
) else (
    echo [EXITOSO] Icono descargado correctamente
)

:: Crear acceso directo usando PowerShell
echo Creando acceso directo en el escritorio...

set "shortcut_file=!desktop_path!\%shortcut_name%.lnk"

:: Script de PowerShell para crear el acceso directo
echo $WshShell = New-Object -comObject WScript.Shell > "%temp%\create_shortcut.ps1"
echo $Shortcut = $WshShell.CreateShortcut^("!shortcut_file!"^) >> "%temp%\create_shortcut.ps1"
echo $Shortcut.TargetPath = "cmd.exe" >> "%temp%\create_shortcut.ps1"
echo $Shortcut.Arguments = "/c start `"`" `"%shortcut_url%`"" >> "%temp%\create_shortcut.ps1"
echo $Shortcut.Description = "Acceso directo a HelpDesk Xelerica" >> "%temp%\create_shortcut.ps1"
echo $Shortcut.WindowStyle = 7 >> "%temp%\create_shortcut.ps1"
if defined icon_file (
    echo $Shortcut.IconLocation = "%icon_file%" >> "%temp%\create_shortcut.ps1"
)
echo $Shortcut.Save^(^) >> "%temp%\create_shortcut.ps1"

:: Ejecutar el script de PowerShell
powershell -ExecutionPolicy Bypass -File "%temp%\create_shortcut.ps1"
set "shortcut_result=!errorlevel!"

:: Limpiar archivo temporal
if exist "%temp%\create_shortcut.ps1" del "%temp%\create_shortcut.ps1"

if !shortcut_result! neq 0 (
    echo ERROR: No se pudo crear el acceso directo
    set /a error_count+=1
) else (
    echo [EXITOSO] Acceso directo creado correctamente
    echo Ubicacion: !shortcut_file!
)

:: Copiar icono al perfil del usuario para mantenerlo permanente
if defined icon_file (
    set "user_icon_path=!user_profile!\AppData\Local\xelerica_icon.ico"
    copy "%icon_file%" "!user_icon_path!" >nul 2>&1
    if exist "!user_icon_path!" (
        echo [INFO] Icono copiado al perfil del usuario para mantenerlo permanente
        
        :: Actualizar el acceso directo para usar el icono permanente
        echo $WshShell = New-Object -comObject WScript.Shell > "%temp%\update_shortcut.ps1"
        echo $Shortcut = $WshShell.CreateShortcut^("!shortcut_file!"^) >> "%temp%\update_shortcut.ps1"
        echo $Shortcut.IconLocation = "!user_icon_path!" >> "%temp%\update_shortcut.ps1"
        echo $Shortcut.Save^(^) >> "%temp%\update_shortcut.ps1"
        
        powershell -ExecutionPolicy Bypass -File "%temp%\update_shortcut.ps1"
        if exist "%temp%\update_shortcut.ps1" del "%temp%\update_shortcut.ps1"
        
        echo [INFO] Acceso directo actualizado con icono permanente
    )
)

echo.
echo ===============================================
echo                   RESUMEN
echo ===============================================
echo Usuario seleccionado: !selected_user!
echo Escritorio utilizado: !desktop_path!
echo Acceso directo: !shortcut_file!
if defined icon_file (
    echo Icono utilizado: Si
) else (
    echo Icono utilizado: No
)
echo URL de destino: %shortcut_url%
echo Fecha y hora: %DATE% %TIME%
echo Equipo: %COMPUTERNAME%
echo Ejecutado por: %USERNAME%
echo ===============================================
echo.
echo [INFO] El acceso directo "HelpDesk Xelerica" ha sido creado
echo [INFO] Al hacer clic abrira el navegador con el sistema de tickets
echo [INFO] Puede mover o eliminar el acceso directo si lo desea

:: Limpiar archivos temporales
if exist "%icon_file%" del "%icon_file%"

endlocal
goto :eof
