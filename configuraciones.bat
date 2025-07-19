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

:main_menu
cls
echo.
echo ===============================================
echo        GESTION DE ARCHIVO HOSTS DE WINDOWS
echo ===============================================
echo.
echo 1. Ver contenido actual del archivo hosts
echo 2. Agregar nueva entrada
echo 3. Editar/Eliminar entradas existentes
echo 4. Salir
echo.
set /p "menu_option=Seleccione una opcion (1-4): "

if "!menu_option!"=="1" goto show_hosts
if "!menu_option!"=="2" goto add_entry
if "!menu_option!"=="3" goto edit_entries
if "!menu_option!"=="4" goto end_program

echo Opcion invalida. Presione cualquier tecla para continuar...
pause >nul
goto main_menu

:show_hosts
echo.
echo [INFO] Contenido actual del archivo hosts:
echo --------------------------------------------------------
type "%WINDIR%\System32\Drivers\Etc\hosts"
echo --------------------------------------------------------
echo.
pause
goto main_menu

:add_entry
echo.
echo ===============================================
echo           AGREGAR NUEVA ENTRADA
echo ===============================================
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
    ) else (
        echo [ERROR] No se pudo agregar la entrada al archivo hosts.
    )
) else (
    echo [INFO] Operacion cancelada por el usuario.
)
echo.
pause
goto main_menu

:edit_entries
echo.
echo ===============================================
echo        EDITAR/ELIMINAR ENTRADAS EXISTENTES
echo ===============================================
echo.

:: Crear archivo temporal para procesar entradas
set "temp_hosts=%temp%\hosts_temp.txt"
set "hosts_file=%WINDIR%\System32\Drivers\Etc\hosts"

:: Extraer solo las líneas que parecen entradas válidas (IP dominio)
echo Analizando entradas del archivo hosts...
set "entry_count=0"

for /f "usebackq tokens=* delims=" %%a in ("%hosts_file%") do (
    set "line=%%a"
    :: Omitir líneas vacías y comentarios
    if "!line:~0,1!" neq "#" (
        if "!line!" neq "" (
            :: Verificar si la línea contiene IP y dominio
            for /f "tokens=1,2" %%b in ("!line!") do (
                set "ip_part=%%b"
                set "domain_part=%%c"
                if defined domain_part (
                    set /a entry_count+=1
                    set "entry_!entry_count!=!line!"
                    echo  !entry_count!. !line!
                )
            )
        )
    )
)

if !entry_count! equ 0 (
    echo No se encontraron entradas personalizadas en el archivo hosts.
    pause
    goto main_menu
)

echo.
echo 0. Volver al menu principal
echo.
set /p "edit_selection=Seleccione el numero de la entrada a editar/eliminar (0-!entry_count!): "

if "!edit_selection!"=="0" goto main_menu

:: Validar selección
if !edit_selection! lss 1 goto invalid_selection
if !edit_selection! gtr !entry_count! goto invalid_selection

:: Mostrar entrada seleccionada
call set "selected_entry=%%entry_!edit_selection!%%"
echo.
echo Entrada seleccionada: !selected_entry!
echo.
echo 1. Editar esta entrada
echo 2. Eliminar esta entrada
echo 3. Cancelar
echo.
set /p "action=Seleccione una accion (1-3): "

if "!action!"=="1" goto edit_selected_entry
if "!action!"=="2" goto delete_selected_entry
if "!action!"=="3" goto edit_entries

echo Opcion invalida.
pause
goto edit_entries

:edit_selected_entry
echo.
echo ===============================================
echo              EDITAR ENTRADA
echo ===============================================
echo.
echo Entrada actual: !selected_entry!
echo.

:: Extraer IP y dominio actuales
for /f "tokens=1,2*" %%a in ("!selected_entry!") do (
    set "current_ip=%%a"
    set "current_domain=%%b %%c"
)

echo IP actual: !current_ip!
echo Dominio actual: !current_domain!
echo.
set /p "new_ip=Ingrese la nueva IP (Enter para mantener actual): "
set /p "new_domain=Ingrese el nuevo dominio (Enter para mantener actual): "

if "!new_ip!"=="" set "new_ip=!current_ip!"
if "!new_domain!"=="" set "new_domain=!current_domain!"

echo.
echo Nueva entrada: !new_ip! !new_domain!
set /p "confirm_edit=¿Confirmar cambios? [S/N]: "

if /i "!confirm_edit!"=="S" (
    call :replace_entry "!selected_entry!" "!new_ip! !new_domain!"
    if !errorlevel! equ 0 (
        echo [EXITOSO] Entrada editada correctamente.
    ) else (
        echo [ERROR] No se pudo editar la entrada.
    )
) else (
    echo [INFO] Edicion cancelada por el usuario.
)

pause
goto edit_entries

:delete_selected_entry
echo.
echo ===============================================
echo             ELIMINAR ENTRADA
echo ===============================================
echo.
echo Entrada a eliminar: !selected_entry!
echo.
set /p "confirm_delete=¿Confirmar eliminacion? [S/N]: "

if /i "!confirm_delete!"=="S" (
    call :remove_entry "!selected_entry!"
    if !errorlevel! equ 0 (
        echo [EXITOSO] Entrada eliminada correctamente.
    ) else (
        echo [ERROR] No se pudo eliminar la entrada.
    )
) else (
    echo [INFO] Eliminacion cancelada por el usuario.
)

pause
goto edit_entries

:invalid_selection
echo Seleccion invalida.
pause
goto edit_entries

:replace_entry
setlocal
set "old_entry=%~1"
set "new_entry=%~2"
set "temp_file=%temp%\hosts_replace.txt"

:: Crear archivo temporal con la entrada reemplazada
(
    for /f "usebackq tokens=* delims=" %%a in ("%hosts_file%") do (
        if "%%a"=="!old_entry!" (
            echo !new_entry!
        ) else (
            echo %%a
        )
    )
) > "!temp_file!"

:: Reemplazar archivo original
copy "!temp_file!" "%hosts_file%" >nul
set "result=!errorlevel!"
del "!temp_file!" >nul 2>&1

endlocal & exit /b %result%

:remove_entry
setlocal
set "entry_to_remove=%~1"
set "temp_file=%temp%\hosts_remove.txt"

:: Crear archivo temporal sin la entrada a eliminar
(
    for /f "usebackq tokens=* delims=" %%a in ("%hosts_file%") do (
        if "%%a" neq "!entry_to_remove!" (
            echo %%a
        )
    )
) > "!temp_file!"

:: Reemplazar archivo original
copy "!temp_file!" "%hosts_file%" >nul
set "result=!errorlevel!"
del "!temp_file!" >nul 2>&1

endlocal & exit /b %result%

:end_program
echo.
echo ===============================================
echo         FIN DE GESTION DE ARCHIVO HOSTS
echo ===============================================

endlocal
pause
exit /b 0