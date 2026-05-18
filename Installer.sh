#!/bin/bash
# ==============================================================
# Gamez Code Solutions - Instalador Maestro para Linux (Ubuntu/Debian)
# ==============================================================
# Version: 1.0
# Descripcion: Instalador interactivo de aplicaciones para Linux
#              equivalente al Installer.bat de Windows.
# Soporta: apt, snap, flatpak, y descargas directas.
# ==============================================================

set -euo pipefail

# ===================== COLORES ANSI =====================
ESC="\e"
RESET="${ESC}[0m"
BOLD="${ESC}[1m"
CYAN="${ESC}[36m"
GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"
RED="${ESC}[31m"
MAGENTA="${ESC}[35m"
BLUE="${ESC}[34m"
WHITE="${ESC}[37m"
GRAY="${ESC}[90m"
BRIGHT_CYAN="${ESC}[96m"
BRIGHT_GREEN="${ESC}[92m"
BRIGHT_WHITE="${ESC}[97m"
BG_WHITE="${ESC}[47m"
BLACK="${ESC}[30m"

# ===================== VARIABLES GLOBALES =====================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/instalador_linux.log"
ERROR_COUNT=0
APP_COUNT=0
SELECTED_APPS=""
HAS_SUDO=false
HAS_SNAP=false
HAS_FLATPAK=false
DETECTED_DISTRO=""

# ===================== DETECTAR ENTORNO =====================
detect_environment() {
    # Verificar si somos root
    if [[ $EUID -eq 0 ]]; then
        HAS_SUDO=true
    elif command -v sudo &>/dev/null; then
        HAS_SUDO=true
    fi

    # Detectar distribucion
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DETECTED_DISTRO="$ID"
    elif command -v lsb_release &>/dev/null; then
        DETECTED_DISTRO=$(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]')
    else
        DETECTED_DISTRO="linux"
    fi

    # Verificar gestores de paquetes
    command -v snap &>/dev/null && HAS_SNAP=true || HAS_SNAP=false
    command -v flatpak &>/dev/null && HAS_FLATPAK=true || HAS_FLATPAK=false
}

# ===================== FUNCION DE AYUDA: SUDO =====================
ensure_sudo() {
    if [[ $EUID -ne 0 ]]; then
        if command -v sudo &>/dev/null; then
            exec sudo bash "$0" "$@"
        else
            echo -e "${RED}[ERROR] Este script debe ejecutarse como root.${RESET}"
            echo "Ejecute: sudo bash $0"
            exit 1
        fi
    fi
}

# ===================== LISTA DE APLICACIONES =====================
declare -A APPS
APPS[1]="Appium|npm|npm install -g appium"
APPS[2]="Google.Chrome|apt|wget -qO- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb | sudo dpkg -i -"
APPS[3]="DBeaver|flatpak|flatpak install flathub io.dbeaver.DBeaver -y"
APPS[4]="Firefox|apt|apt install -y firefox"
APPS[5]="Git|apt|apt install -y git"
APPS[6]="NodeJS|apt|apt install -y nodejs npm"
APPS[7]="VisualStudioCode|snap|snap install code --classic"
APPS[8]="Postman|snap|snap install postman"
APPS[9]="SoapUI|snap|snap install soapui"
APPS[10]="Vysor|manual|(herramienta Android - instalar manualmente desde vysor.io)"
APPS[11]="FileZilla|apt|apt install -y filezilla"
APPS[12]="Notepad++(Geany/VSCode)|apt|apt install -y geany"
APPS[13]="OpenJDK.21|apt|apt install -y openjdk-21-jdk"
APPS[14]="IntelliJIDEA|snap|snap install intellij-idea-community --classic"
APPS[15]="DBeaver(SSMS alt)|flatpak|flatpak install flathub io.dbeaver.DBeaver -y"
APPS[16]="AmazonCorretto.11|manual|(instalar manual desde aws.amazon.com/corretto)"
APPS[17]="AmazonCorretto.8|manual|(instalar manual desde aws.amazon.com/corretto)"
APPS[18]="AmazonCorretto.17|manual|(instalar manual desde aws.amazon.com/corretto)"
APPS[19]="Python.3|apt|apt install -y python3 python3-pip"
APPS[20]="AWSCLI|apt|apt install -y awscli"
APPS[21]="AndroidStudio|snap|snap install android-studio --classic"
APPS[22]="Flameshot(ShareX alt)|apt|apt install -y flameshot"
APPS[23]="DotnetSDK|apt|apt install -y dotnet-sdk-8.0"
APPS[24]="MongoDBCompass|manual|(descargar .deb desde mongodb.com/products/tools/compass)"
APPS[25]="Docker(no SQL Express)|manual|curl -fsSL https://get.docker.com | sudo bash"
APPS[26]="VLC|apt|apt install -y vlc"
APPS[27]="LibreOffice|apt|apt install -y libreoffice"
APPS[28]="Mono(.NET alt)|apt|apt install -y mono-complete"
APPS[29]="shred(borrado seguro)|apt|apt install -y coreutils"
APPS[30]="OpenFortiVPN|apt|apt install -y openfortivpn"
APPS[31]="IBMiAccess|manual|(no disponible en Linux - usar TN5250 o web)"
APPS[32]="ApacheMaven|apt|apt install -y maven"
APPS[33]="Gradle|apt|apt install -y gradle"
APPS[34]="FusionInventory|apt|apt install -y fusioninventory-agent"
APPS[35]="AmazonWorkspaces|manual|(cliente no oficial - instalar manual)"
APPS[36]="Okular(Adobe Reader alt)|apt|apt install -y okular"
APPS[37]="VSCode(no VS2022)|snap|snap install code --classic"
APPS[38]="ApacheJMeter|apt|apt install -y jmeter"
APPS[39]="Jenkins|manual|(instalar desde pkg.jenkins.io o via Docker)"
APPS[40]="MongoDBServer|manual|(instalar desde mongodb.com/docs/manual/administration/install-on-linux/)"
APPS[41]="mongosh|apt|apt install -y mongodb-mongosh"
APPS[42]="MongoDBTools|apt|apt install -y mongodb-database-tools"
APPS[43]="NoSQLBooster|manual|(AppImage desde nosqlbooster.com)"
APPS[44]="Gradle-8.5|manual|sdk install gradle 8.5"
APPS[45]="Elixir|apt|apt install -y elixir"
APPS[46]="Gradle-8.10|manual|sdk install gradle 8.10.2"
APPS[47]="kubectl|snap|snap install kubectl --classic"
APPS[48]="tesseract-ocr|apt|apt install -y tesseract-ocr"
APPS[49]="SDKMAN|manual|curl -s 'https://get.sdkman.io' | bash"
APPS[50]="FVM(skip en Linux)|manual|(no necesario en Linux - usar dart/flutter nativo)"
APPS[51]="TigerVNC(UltraVNC alt)|apt|apt install -y tigervnc-viewer"
APPS[52]="shred(sdelete alt)|apt|apt install -y coreutils"
APPS[53]="(no aplica en Linux)|manual|(Winget no existe en Linux)"
APPS[54]="(no aplica en Linux)|manual|(Winget no existe en Linux)"
APPS[55]="(Atera web)|manual|(Atera es web - crear acceso directo)"
APPS[56]="(Atera web)|manual|(Atera es web - crear acceso directo)"
APPS[57]="(Atera web)|manual|(Atera es web - crear acceso directo)"
APPS[58]="(Atera web)|manual|(Atera es web - crear acceso directo)"
APPS[59]="DBeaver(PL/SQL alt)|flatpak|flatpak install flathub io.dbeaver.DBeaver -y"
APPS[60]="openconnect|apt|apt install -y openconnect"
APPS[61]="Gradle-8.14.3|manual|sdk install gradle 8.14.3"
APPS[62]="MongoDBCompass|manual|(descargar .deb desde mongodb.com)"
APPS[63]="npm_appium|npm|npm install -g appium"
APPS[64]="Gestion_Hosts|script|call :manage_hosts"
APPS[65]="ApacheJMeter|apt|apt install -y jmeter"
APPS[66]="mysql-connector-odbc|apt|apt install -y mysql-connector-odbc"
APPS[67]="mysql-connector-net|manual|(no aplica en Linux - usar mysql-connector-net via mono)"
APPS[68]="Docker|manual|curl -fsSL https://get.docker.com | sudo bash"
APPS[69]="Certbot|apt|apt install -y certbot"
APPS[70]="NetworkManager|apt|apt install -y network-manager"
APPS[71]="(no disponible en Linux)|manual|(OfimaBot solo en Windows)"
APPS[72]="(no disponible en Linux)|manual|(UiPath solo en Windows)"
APPS[73]="LibreOffice(Office alt)|apt|apt install -y libreoffice"
APPS[74]="Gradle-9.0|manual|sdk install gradle 9.0"
APPS[75]="HelpDesk_Xelerica|script|call :create_helpdesk_shortcut"
APPS[76]="(OneDrive no en Linux)|manual|(usar rclone o onedriver para Linux)"
APPS[77]="FileZilla|apt|apt install -y filezilla"
APPS[78]="MongoDBCompass|manual|(Studio3T no disponible - usar Compass)"
APPS[79]="DBeaver|flatpak|flatpak install flathub io.dbeaver.DBeaver -y"
APPS[80]="putty|apt|apt install -y putty"
APPS[81]="Remmina(VNC alt)|apt|apt install -y remmina"
APPS[82]="(no aplica en Linux)|manual|(usar Remmina o TigerVNC)"
APPS[83]="Add/Del_UserGroup|script|call :manage_user_group"
APPS[84]="(reservado)|manual|(slot reservado)"
APPS[85]="Buscar_e_Instalar|script|call :install_with_package_manager"
APPS[86]="GlobalProtect|manual|(openconnect como alternativa)"
APPS[87]="Desinstalar_apps|script|call :uninstall_applications"
APPS[88]="ManageEngine|manual|(instalar agente manualmente)"
APPS[89]="Gradle-8.11|manual|sdk install gradle 8.11"
APPS[90]="USB_Policy|script|call :manage_usb_policy"

# ===================== APPS LISTA (solo nombres para mostrar) =====================
declare -a APP_NAMES
for i in $(seq 1 90); do
    IFS='|' read -r name _ _ <<< "${APPS[$i]}"
    APP_NAMES[$i]="$name"
done

# ===================== LOGO =====================
print_logo() {
    echo -e "${BRIGHT_CYAN}      _ _       ${BRIGHT_WHITE}  _   _   ___  ___ _  __${RESET}"
    echo -e "${BRIGHT_CYAN}    / . \\      ${BRIGHT_WHITE} /_\\ | \\ | \\ \\ / /_ _| |/ /${RESET}"
    echo -e "${BRIGHT_CYAN}   / / \\ \\    ${BRIGHT_WHITE}/ _ \\|  \\| |\\ V / | || ' < ${RESET}"
    echo -e "${BRIGHT_CYAN}  / /${BLACK}${BG_WHITE}CODE${RESET}${BRIGHT_CYAN}\\ \\    ${BRIGHT_WHITE}/_/ \\_\\\\_\\\\_| \\_/ |___|_|\\_\\${RESET}"
    echo -e "${BRIGHT_CYAN}  \\ \\   / /   ${RESET}"
    echo -e "${BRIGHT_CYAN}   \\ \\_/ /    ${WHITE}       S O L U T I O N S${RESET}"
    echo -e "${BRIGHT_CYAN}    \\ _ /${RESET}"
    echo
}

# ===================== SPINNER =====================
spinner_wait() {
    local msg="$1"
    local spin=('|' '/' '-' '\\')
    for i in $(seq 0 12); do
        echo -ne "\r${CYAN}${spin[$((i % 4))]}${RESET} $msg"
        sleep 0.15
    done
    echo -ne "\r"
}

# ===================== INSTALACION CON APT =====================
apt_install() {
    local package="$1"
    echo -e "${BRIGHT_WHITE}[apt]${RESET} Instalando: ${BRIGHT_CYAN}$package${RESET}"
    if [[ $EUID -eq 0 ]]; then
        apt install -y "$package" 2>&1 | tee -a "$LOG_FILE" || return 1
    else
        sudo apt install -y "$package" 2>&1 | tee -a "$LOG_FILE" || return 1
    fi
    return 0
}

# ===================== INSTALACION CON SNAP =====================
snap_install() {
    local package="$1"
    local classic="${2:-}"
    echo -e "${BRIGHT_WHITE}[snap]${RESET} Instalando: ${BRIGHT_CYAN}$package${RESET}"
    if [[ -n "$classic" ]]; then
        snap install "$package" --classic 2>&1 | tee -a "$LOG_FILE" || return 1
    else
        snap install "$package" 2>&1 | tee -a "$LOG_FILE" || return 1
    fi
    return 0
}

# ===================== INSTALACION CON FLATPAK =====================
flatpak_install() {
    local package="$1"
    echo -e "${BRIGHT_WHITE}[flatpak]${RESET} Instalando: ${BRIGHT_CYAN}$package${RESET}"
    flatpak install flathub "$package" -y 2>&1 | tee -a "$LOG_FILE" || return 1
    return 0
}

# ===================== DESCARGA DE ARCHIVOS =====================
download_file() {
    local url="$1"
    local dest="$2"
    echo -e "${BRIGHT_WHITE}[download]${RESET} Descargando: ${BRIGHT_CYAN}$url${RESET}"
    if command -v wget &>/dev/null; then
        wget -q --show-progress -O "$dest" "$url" 2>&1 || return 1
    elif command -v curl &>/dev/null; then
        curl -fsSL -o "$dest" "$url" 2>&1 || return 1
    else
        echo -e "${RED}[ERROR] wget o curl no estan instalados${RESET}"
        return 1
    fi
    return 0
}

# ===================== INSTALACION DE .DEB =====================
install_deb() {
    local url="$1"
    local tmp_deb="/tmp/$(basename "$url")"

    download_file "$url" "$tmp_deb" || return 1

    if [[ -f "$tmp_deb" ]]; then
        echo -e "${BRIGHT_WHITE}[deb]${RESET} Instalando paquete..."
        if [[ $EUID -eq 0 ]]; then
            apt install -y "$tmp_deb" 2>&1 | tee -a "$LOG_FILE" || return 1
        else
            sudo apt install -y "$tmp_deb" 2>&1 | tee -a "$LOG_FILE" || return 1
        fi
        rm -f "$tmp_deb"
        return 0
    fi
    return 1
}

# ===================== INSTALACION DE ZIP/TAR =====================
install_archive() {
    local url="$1"
    local dest="$2"

    local filename=$(basename "$url")
    local tmp_file="/tmp/$filename"

    download_file "$url" "$tmp_file" || return 1

    echo -e "${BRIGHT_WHITE}[archive]${RESET} Extrayendo en: ${BRIGHT_CYAN}$dest${RESET}"
    if [[ ! -d "$dest" ]]; then
        mkdir -p "$dest"
    fi

    case "$filename" in
        *.zip)
            if command -v unzip &>/dev/null; then
                unzip -o "$tmp_file" -d "$dest" 2>&1 || return 1
            else
                apt install -y unzip 2>/dev/null || sudo apt install -y unzip 2>/dev/null
                unzip -o "$tmp_file" -d "$dest" 2>&1 || return 1
            fi
            ;;
        *.tar.gz|*.tgz)
            tar -xzf "$tmp_file" -C "$dest" 2>&1 || return 1
            ;;
        *.tar.bz2)
            tar -xjf "$tmp_file" -C "$dest" 2>&1 || return 1
            ;;
        *.tar.xz)
            tar -xJf "$tmp_file" -C "$dest" 2>&1 || return 1
            ;;
        *)
            echo -e "${YELLOW}[!] Formato no reconocido, copiando archivo a $dest${RESET}"
            cp "$tmp_file" "$dest/"
            ;;
    esac

    rm -f "$tmp_file"
    echo -e "${GREEN}[OK] Extraccion completada en $dest${RESET}"
    return 0
}

# ===================== INSTALACION NPM GLOBAL =====================
npm_install_global() {
    local package="$1"
    echo -e "${BRIGHT_WHITE}[npm]${RESET} Instalando: ${BRIGHT_CYAN}$package${RESET}"
    if command -v npm &>/dev/null; then
        npm install -g "$package" 2>&1 | tee -a "$LOG_FILE" || return 1
        return 0
    else
        echo -e "${YELLOW}[!] npm no esta instalado. Instalando NodeJS...${RESET}"
        install_with_method "NodeJS" "apt" "apt install -y nodejs npm" || return 1
        npm install -g "$package" 2>&1 | tee -a "$LOG_FILE" || return 1
        return 0
    fi
}

# ===================== INSTALACION CON SDKMAN =====================
sdkman_install() {
    local candidate="$1"
    local version="$2"

    if ! command -v sdk &>/dev/null; then
        echo -e "${YELLOW}[!] SDKMAN no esta instalado. Instalando SDKMAN...${RESET}"
        curl -s "https://get.sdkman.io" | bash 2>&1 | tee -a "$LOG_FILE"
        # shellcheck disable=SC1090
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi

    echo -e "${BRIGHT_WHITE}[sdkman]${RESET} Instalando: ${BRIGHT_CYAN}$candidate $version${RESET}"
    sdk install "$candidate" "$version" 2>&1 | tee -a "$LOG_FILE" || return 1
    return 0
}

# ===================== INSTALAR POR METODO =====================
install_with_method() {
    local app_name="$1"
    local method="$2"
    local command="$3"

    echo -e "${BRIGHT_WHITE}[$method]${RESET} Instalando: ${BRIGHT_CYAN}$app_name${RESET}"
    spinner_wait "Preparando $app_name..."

    case "$method" in
        apt)
            # Extraer nombre del paquete del comando (ultimo argumento)
            local pkg=$(echo "$command" | awk '{print $NF}')
            apt_install "$pkg" || return 1
            ;;
        snap)
            local snap_name=""
            local classic=""
            if echo "$command" | grep -q "\-\-classic"; then
                snap_name=$(echo "$command" | awk '{print $3}')
                classic="--classic"
            else
                snap_name=$(echo "$command" | awk '{print $3}')
            fi
            snap_install "$snap_name" "$classic" || return 1
            ;;
        flatpak)
            local flatpak_id=$(echo "$command" | awk '{print $NF}')
            flatpak_install "$flatpak_id" || return 1
            ;;
        npm)
            local npm_pkg=$(echo "$command" | awk '{print $NF}')
            npm_install_global "$npm_pkg" || return 1
            ;;
        manual)
            echo -e "${YELLOW}[manual]${RESET} $command"
            echo -e "${YELLOW}[!] Esta aplicacion requiere instalacion manual.${RESET}"
            return 2
            ;;
        script)
            # Los comandos script se manejan por separado
            return 0
            ;;
        *)
            echo -e "${RED}[ERROR] Metodo de instalacion desconocido: $method${RESET}"
            return 1
            ;;
    esac
    return 0
}

# ===================== PROCESAR INSTALACION =====================
process_installation() {
    local apps_list="$1"
    ERROR_COUNT=0
    APP_COUNT=0

    echo -e "${BOLD}${CYAN}Iniciando instalaciones...${RESET}"
    for app_key in $apps_list; do
        IFS='|' read -r name method cmd <<< "${APPS[$app_key]}"
        ((APP_COUNT+=1))
        echo
        echo -e "${BRIGHT_WHITE}[$(date +%H:%M:%S)]${RESET} Instalando: ${BRIGHT_CYAN}$name${RESET}"

        case "$method" in
            script)
                case "$name" in
                    Gestion_Hosts)
                        manage_hosts || ((ERROR_COUNT+=1))
                        ;;
                    HelpDesk_Xelerica)
                        create_helpdesk_shortcut || ((ERROR_COUNT+=1))
                        ;;
                    Add/Del_UserGroup)
                        manage_user_group || ((ERROR_COUNT+=1))
                        ;;
                    Buscar_e_Instalar)
                        install_with_package_manager || ((ERROR_COUNT+=1))
                        ;;
                    Desinstalar_apps)
                        uninstall_applications || ((ERROR_COUNT+=1))
                        ;;
                    USB_Policy)
                        manage_usb_policy || ((ERROR_COUNT+=1))
                        ;;
                    *)
                        echo -e "${RED}[ERROR] Script desconocido: $name${RESET}"
                        ((ERROR_COUNT+=1))
                        ;;
                esac
                ;;
            apt)
                local pkg=$(echo "$cmd" | awk '{print $NF}')
                apt_install "$pkg" || ((ERROR_COUNT+=1))
                ;;
            snap)
                snap_install_app_from_cmd "$cmd" || ((ERROR_COUNT+=1))
                ;;
            flatpak)
                local fpid=$(echo "$cmd" | awk '{print $NF}')
                flatpak_install "$fpid" || ((ERROR_COUNT+=1))
                ;;
            npm)
                npm_install_global "$name" || ((ERROR_COUNT+=1))
                ;;
            manual)
                echo -e "${YELLOW}[!] $cmd${RESET}"
                echo -e "${YELLOW}[!] Debe instalar manualmente. Presione Enter para continuar...${RESET}"
                read -r
                ;;
            *)
                echo -e "${RED}[ERROR] Metodo no soportado: $method${RESET}"
                ((ERROR_COUNT+=1))
                ;;
        esac
    done

    # Resumen
    echo
    echo -e "${BOLD}${CYAN}================================================${RESET}"
    echo -e "${BOLD}${CYAN}              RESUMEN DE PROCESO                ${RESET}"
    echo -e "${BOLD}${CYAN}================================================${RESET}"
    echo -e " ${BRIGHT_WHITE}Finalizado en:${RESET} $(date +%H:%M:%S)"
    echo -e " ${BRIGHT_GREEN}Procesadas:${RESET}   $APP_COUNT"
    echo -e " ${RED}Errores:${RESET}     $ERROR_COUNT"
    echo -e "${BOLD}${CYAN}================================================${RESET}"
    if [[ $ERROR_COUNT -gt 0 ]]; then
        echo -e "${YELLOW}[!] Verifique los errores e intente instalar manualmente.${RESET}"
    fi
    echo
    echo -e "${GRAY}Presione Enter para volver al menu...${RESET}"
    read -r
}

# ===================== FUNCION AUXILIAR SNAP =====================
snap_install_app_from_cmd() {
    local cmd="$1"
    local snap_name
    local classic=""

    if echo "$cmd" | grep -q "\-\-classic"; then
        snap_name=$(echo "$cmd" | awk '{print $3}')
        classic="--classic"
    else
        snap_name=$(echo "$cmd" | awk '{print $3}')
    fi
    snap_install "$snap_name" "$classic" || return 1
    return 0
}

# ===================== MENU PRINCIPAL =====================
menu() {
    while true; do
        clear
        print_logo
        echo -e " ${CYAN}Seleccione aplicaciones a instalar:${RESET}"
        echo

        # Mostrar menu en 3 columnas (1-30, 31-60, 61-90)
        echo -e " ${BOLD}COLUMNA 1                        COLUMNA 2                        COLUMNA 3${RESET}"
        echo -e " ${GRAY}--------------------------    --------------------------    --------------------------${RESET}"
        for i in $(seq 1 30); do
            local col2=$((i + 30))
            local col3=$((i + 60))

            local id1=$(printf "%02d" "$i")
            local name1="${APP_NAMES[$i]:0:26}"
            printf " ${BRIGHT_CYAN}%s.${RESET} %-26s" "$id1" "$name1"

            local name2="${APP_NAMES[$col2]:0:26}"
            printf " ${BRIGHT_CYAN}%s.${RESET} %-26s" "$col2" "$name2"

            local name3="${APP_NAMES[$col3]:0:26}"
            printf " ${BRIGHT_CYAN}%s.${RESET} %s" "$col3" "$name3"

            echo
        done

        echo
        echo -e " ${BRIGHT_CYAN}99.${RESET} Borrado seguro de usuario    ${BRIGHT_CYAN}98.${RESET} Limpiar SQL Developer"
        echo -e " ${BRIGHT_CYAN}97.${RESET} Buscar aplicaciones          ${BRIGHT_CYAN}S.${RESET}  Salir"
        echo
        echo -e "${BRIGHT_WHITE}Ingrese numeros separados por comas (ej: 2,5,7-10)${RESET}"
        echo -e " ${BRIGHT_CYAN}[A]${RESET} Todo  ${BRIGHT_CYAN}[C]${RESET} Confirmar  ${BRIGHT_CYAN}[S]${RESET} Salir  ${BRIGHT_CYAN}[B]${RESET} Buscar"
        echo
        echo -ne "${BRIGHT_GREEN} Seleccion: ${RESET}"
        read -r selection

        case "$selection" in
            99)
                secure_delete
                echo -e "${GRAY}Presione Enter para continuar...${RESET}"
                read -r
                ;;
            98)
                clean_sqldeveloper
                echo -e "${GRAY}Presione Enter para continuar...${RESET}"
                read -r
                ;;
            97|B|b)
                save_and_search
                echo -e "${GRAY}Presione Enter para continuar...${RESET}"
                read -r
                ;;
            S|s)
                exit 0
                ;;
            A|a)
                SELECTED_APPS=$(seq 1 90 | tr '\n' ' ')
                confirm_and_install
                ;;
            C|c)
                confirm_and_install
                ;;
            *)
                # Expandir seleccion
                SELECTED_APPS=""
                IFS=',' read -ra parts <<< "$selection"
                for part in "${parts[@]}"; do
                    part=$(echo "$part" | xargs)
                    if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                        for j in $(seq "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"); do
                            SELECTED_APPS="$SELECTED_APPS $j"
                        done
                    elif [[ "$part" =~ ^[0-9]+$ ]]; then
                        SELECTED_APPS="$SELECTED_APPS $part"
                    fi
                done
                confirm_and_install
                ;;
        esac
    done
}

# ===================== CONFIRMAR E INSTALAR =====================
confirm_and_install() {
    clear
    print_logo
    echo -e "${BOLD}${CYAN}Aplicaciones seleccionadas:${RESET}"
    echo -e "${GRAY}---------------------------------${RESET}"

    local display_apps=""
    for app_key in $SELECTED_APPS; do
        IFS='|' read -r name method cmd <<< "${APPS[$app_key]}"
        echo -e " ${BRIGHT_WHITE} *${RESET} $name"
        display_apps="$display_apps $app_key"
    done

    # Si no hay apps seleccionadas, verificar si hay global
    if [[ -z "$display_apps" ]] && [[ -n "$SELECTED_APPS" ]]; then
        display_apps="$SELECTED_APPS"
    fi

    if [[ -z "$display_apps" ]]; then
        echo -e "${YELLOW}[!] No hay aplicaciones seleccionadas.${RESET}"
        echo -e "${GRAY}Presione Enter para volver...${RESET}"
        read -r
        return
    fi

    echo
    echo -e "${YELLOW}Desea proceder con la instalacion? [S] Si  [N] No (Volver):${RESET} "
    read -r confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        process_installation "$display_apps"
    fi
}

# ===================== GESTION DE HOSTS =====================
manage_hosts() {
    echo
    echo "==============================================="
    echo "    GESTION DE ARCHIVO HOSTS (/etc/hosts)"
    echo "==============================================="
    echo
    echo "Entradas actuales en /etc/hosts:"
    echo "--------------------------------"
    cat /etc/hosts | grep -v "^#" | grep -v "^$"
    echo
    echo "Acciones disponibles:"
    echo "[1] Agregar entrada"
    echo "[2] Eliminar entrada"
    echo "[3] Ver hosts completo"
    echo "[4] Volver"
    echo
    echo -n "Seleccione: "
    read -r hosts_action

    case "$hosts_action" in
        1)
            echo -n "IP: "
            read -r ip
            echo -n "Hostname: "
            read -r hostname
            if [[ -n "$ip" && -n "$hostname" ]]; then
                echo "$ip $hostname" | sudo tee -a /etc/hosts >/dev/null
                echo -e "${GREEN}[OK] Entrada agregada${RESET}"
            fi
            ;;
        2)
            echo -n "Hostname a eliminar: "
            read -r hostname
            if [[ -n "$hostname" ]]; then
                sudo sed -i "/$hostname/d" /etc/hosts
                echo -e "${GREEN}[OK] Entrada eliminada${RESET}"
            fi
            ;;
        3)
            echo "--- /etc/hosts ---"
            cat /etc/hosts
            ;;
        4)
            return
            ;;
    esac
}

# ===================== ACCESO DIRECTO HELPDESK =====================
create_helpdesk_shortcut() {
    echo
    echo "==============================================="
    echo "  CREAR ACCESO DIRECTO HELPDESK XELERICA"
    echo "==============================================="
    echo
    echo "URL: https://xelerica.servicedesk.atera.com/login"
    echo

    local desktop_dir="$HOME/Escritorio"
    [[ ! -d "$desktop_dir" ]] && desktop_dir="$HOME/Desktop"
    [[ ! -d "$desktop_dir" ]] && desktop_dir="$HOME"

    local shortcut_file="$desktop_dir/HelpDesk_Xelerica.desktop"
    cat > /tmp/helpdesk_xelerica.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=HelpDesk Xelerica
Comment=HelpDesk Xelerica
Exec=xdg-open https://xelerica.servicedesk.atera.com/login
Icon=web-browser
Terminal=false
Categories=Network;
EOF

    cp /tmp/helpdesk_xelerica.desktop "$shortcut_file"
    chmod +x "$shortcut_file"
    echo -e "${GREEN}[OK] Acceso directo creado en: $shortcut_file${RESET}"
}

# ===================== GESTION DE USUARIOS Y GRUPOS =====================
manage_user_group() {
    echo
    echo "==============================================="
    echo "    AGREGAR/ELIMINAR USUARIO DE GRUPO"
    echo "==============================================="
    echo

    echo -n "Nombre de usuario: "
    read -r username
    echo -n "Nombre del grupo (ej: sudo, docker): "
    read -r groupname
    echo
    echo "[1] Agregar usuario al grupo"
    echo "[2] Eliminar usuario del grupo"
    echo "[3] Cancelar"
    echo
    echo -n "Seleccione (1/2/3): "
    read -r action

    case "$action" in
        1)
            sudo usermod -aG "$groupname" "$username" && \
            echo -e "${GREEN}[OK] Usuario $username agregado a $groupname${RESET}" || \
            echo -e "${RED}[ERROR] Fallo al agregar usuario${RESET}"
            ;;
        2)
            sudo gpasswd -d "$username" "$groupname" && \
            echo -e "${GREEN}[OK] Usuario $username eliminado de $groupname${RESET}" || \
            echo -e "${RED}[ERROR] Fallo al eliminar usuario${RESET}"
            ;;
        3)
            return
            ;;
    esac
}

# ===================== DESINSTALAR APLICACIONES =====================
uninstall_applications() {
    while true; do
        clear
        echo
        echo "==============================================="
        echo "      DESINSTALADOR DE APLICACIONES"
        echo "==============================================="
        echo
        echo "[1] Ver aplicaciones instaladas (apt)"
        echo "[2] Ver aplicaciones instaladas (snap)"
        echo "[3] Ver aplicaciones instaladas (flatpak)"
        echo "[4] Desinstalar via apt"
        echo "[5] Desinstalar via snap"
        echo "[6] Desinstalar via flatpak"
        echo "[7] Volver al menu principal"
        echo
        echo -n "Seleccione (1-7): "
        read -r uninstall_choice

        case "$uninstall_choice" in
            1) apt list --installed 2>/dev/null | less ;;
            2) snap list | less ;;
            3) flatpak list 2>/dev/null | less ;;
            4)
                echo -n "Nombre del paquete apt a desinstalar: "
                read -r pkg
                sudo apt remove -y "$pkg" && echo -e "${GREEN}[OK] Desinstalado${RESET}" || echo -e "${RED}[ERROR] Fallo${RESET}"
                echo -n "Presione Enter..."; read -r
                ;;
            5)
                echo -n "Nombre del snap a desinstalar: "
                read -r snap_pkg
                sudo snap remove "$snap_pkg" && echo -e "${GREEN}[OK] Desinstalado${RESET}" || echo -e "${RED}[ERROR] Fallo${RESET}"
                echo -n "Presione Enter..."; read -r
                ;;
            6)
                echo -n "ID de flatpak a desinstalar: "
                read -r flatpak_id
                flatpak uninstall -y "$flatpak_id" && echo -e "${GREEN}[OK] Desinstalado${RESET}" || echo -e "${RED}[ERROR] Fallo${RESET}"
                echo -n "Presione Enter..."; read -r
                ;;
            7) return ;;
        esac
    done
}

# ===================== BUSCAR E INSTALAR CON GESTOR =====================
install_with_package_manager() {
    echo
    echo "==============================================="
    echo "    BUSCAR E INSTALAR CON APT/FLATPAK/SNAP"
    echo "==============================================="
    echo

    echo "[1] Buscar e instalar con apt"
    echo "[2] Buscar e instalar con snap"
    echo "[3] Buscar e instalar con flatpak"
    echo "[4] Cancelar"
    echo
    echo -n "Seleccione (1/2/3/4): "
    read -r pm_choice

    case "$pm_choice" in
        1)
            echo -n "Termino de busqueda (apt): "
            read -r search_term
            [[ -z "$search_term" ]] && return
            apt search "$search_term" 2>/dev/null | less
            echo -n "Nombre exacto del paquete a instalar: "
            read -r pkg_name
            if [[ -n "$pkg_name" ]]; then
                sudo apt install -y "$pkg_name"
            fi
            ;;
        2)
            echo -n "Termino de busqueda (snap): "
            read -r search_term
            [[ -z "$search_term" ]] && return
            snap find "$search_term" | less
            echo -n "Nombre del snap a instalar: "
            read -r snap_name
            if [[ -n "$snap_name" ]]; then
                sudo snap install "$snap_name"
            fi
            ;;
        3)
            echo -n "Termino de busqueda (flatpak): "
            read -r search_term
            [[ -z "$search_term" ]] && return
            flatpak search "$search_term" 2>/dev/null | less
            echo -n "ID de flatpak a instalar: "
            read -r fp_id
            if [[ -n "$fp_id" ]]; then
                flatpak install flathub "$fp_id" -y
            fi
            ;;
    esac
}

# ===================== POLITICA USB =====================
manage_usb_policy() {
    echo
    echo "==============================================="
    echo "    GESTION DE POLITICA USB"
    echo "==============================================="
    echo
    echo "[1] Listar dispositivos USB"
    echo "[2] Deshabilitar almacenamiento USB (crear regla)"
    echo "[3] Habilitar almacenamiento USB (eliminar regla)"
    echo "[4] Volver"
    echo
    echo -n "Seleccione: "
    read -r usb_action

    case "$usb_action" in
        1)
            lsusb
            ;;
        2)
            local rule_file="/etc/modprobe.d/usb-storage-blacklist.conf"
            echo "blacklist usb-storage" | sudo tee "$rule_file" >/dev/null
            echo -e "${GREEN}[OK] Almacenamiento USB deshabilitado${RESET}"
            echo -e "${YELLOW}[!] Reinicie para aplicar cambios${RESET}"
            ;;
        3)
            local rule_file="/etc/modprobe.d/usb-storage-blacklist.conf"
            if [[ -f "$rule_file" ]]; then
                sudo rm -f "$rule_file"
                echo -e "${GREEN}[OK] Almacenamiento USB habilitado${RESET}"
            else
                echo -e "${YELLOW}[!] No hay reglas activas${RESET}"
            fi
            ;;
        4)
            return
            ;;
    esac
}

# ===================== BORRADO SEGURO =====================
secure_delete() {
    echo
    echo "==============================================="
    echo "    BORRADO SEGURO DE CARPETAS DE USUARIO"
    echo "==============================================="
    echo

    echo -n "Ingrese el nombre de usuario para borrado seguro: "
    read -r usuario

    if [[ ! -d "/home/$usuario" ]]; then
        echo -e "${RED}[ERROR] El usuario '$usuario' no existe en el sistema.${RESET}"
        return
    fi

    local carpetas=("Desktop" "Documents" "Downloads" "Pictures" "Music" "Videos")

    echo
    echo -e "${RED}ADVERTENCIA: Esto eliminara IRRECUPERABLEMENTE el contenido de:${RESET}"
    for carpeta in "${carpetas[@]}"; do
        if [[ -d "/home/$usuario/$carpeta" ]]; then
            echo "  /home/$usuario/$carpeta"
        fi
    done

    echo
    echo -n "Esta seguro? (escriba 'BORRAR' para confirmar): "
    read -r confirm
    if [[ "$confirm" != "BORRAR" ]]; then
        echo "Operacion cancelada."
        return
    fi

    echo "Iniciando borrado seguro..."
    for carpeta in "${carpetas[@]}"; do
        local ruta="/home/$usuario/$carpeta"
        if [[ -d "$ruta" ]]; then
            echo "Procesando: $ruta..."
            # Sobrescribir con shred y luego eliminar
            find "$ruta" -type f -exec shred -n 35 -z -u {} \; 2>/dev/null
            rm -rf "$ruta" 2>/dev/null
            echo -e "${GREEN}[OK] Eliminado: $ruta${RESET}"
        fi
    done

    echo
    echo "-------------- REGISTRO DE BORRADO --------------"
    echo "Nombre del equipo: $(hostname)"
    echo "Usuario ejecutor: $USER"
    echo "Fecha y hora: $(date)"
    echo
    echo "Los datos han sido sobrescritos 35 veces (shred)."
    echo "-------------------------------------------------"
}

# ===================== LIMPIAR SQL DEVELOPER =====================
clean_sqldeveloper() {
    echo
    echo "==============================================="
    echo "   LIMPIEZA DE CARPETAS SQL DEVELOPER"
    echo "==============================================="
    echo

    echo "Usuarios disponibles:"
    local i=0
    declare -A user_map

    while IFS= read -r dir; do
        local u=$(basename "$dir")
        if [[ "$u" != "root" && "$u" != "lost+found" ]]; then
            ((i+=1))
            user_map[$i]="$u"
            echo "  $i. $u"
        fi
    done < <(find /home -maxdepth 1 -mindepth 1 -type d 2>/dev/null)

    if [[ $i -eq 0 ]]; then
        echo "No se encontraron usuarios."
        return
    fi

    echo
    echo -n "Seleccione el numero del usuario: "
    read -r user_sel
    local selected_user="${user_map[$user_sel]}"

    if [[ -z "$selected_user" ]]; then
        echo -e "${RED}[ERROR] Seleccion invalida${RESET}"
        return
    fi

    local folders_to_clean=(
        "/home/$selected_user/.sqldeveloper"
        "/home/$selected_user/.config/sqldeveloper"
    )

    for folder in "${folders_to_clean[@]}"; do
        if [[ -d "$folder" ]]; then
            echo "Eliminando: $folder"
            rm -rf "$folder" 2>/dev/null && echo -e "${GREEN}[OK] Eliminado${RESET}" || \
            echo -e "${RED}[ERROR] No se pudo eliminar${RESET}"
        else
            echo "[NO ENCONTRADA] $folder"
        fi
    done

    echo
    echo "Limpieza completada."
}

# ===================== BUSQUEDA DE APLICACIONES =====================
search_applications() {
    echo
    echo "==============================================="
    echo "          BUSQUEDA DE APLICACIONES"
    echo "==============================================="
    echo
    echo -n "Palabra clave: "
    read -r search_term

    if [[ -z "$search_term" ]]; then
        echo "Debe ingresar una palabra clave."
        return
    fi

    echo
    echo "Buscando aplicaciones que contengan: $search_term"
    echo "==============================================="

    local found_apps=""
    local found_count=0
    for i in $(seq 1 90); do
        local name="${APP_NAMES[$i]}"
        if echo "$name" | grep -qi "$search_term"; then
            echo "  $i. $name"
            found_apps="$found_apps $i"
            ((found_count+=1))
        fi
    done

    if [[ $found_count -eq 0 ]]; then
        echo "No se encontraron aplicaciones."
        return
    fi

    echo
    echo "Se encontraron $found_count aplicacion(es)"
    echo
    echo "[1] Instalar todas ahora"
    echo "[2] Seleccionar especificas e instalar"
    echo "[3] Agregar todas a la seleccion actual"
    echo "[4] Volver al menu"
    echo
    echo -n "Seleccione: "
    read -r search_action

    case "$search_action" in
        1)
            process_installation "$found_apps"
            ;;
        2)
            echo -n "Ingrese numeros separados por comas (ej: 2,5,7): "
            read -r specific
            local filtered=""
            IFS=',' read -ra parts <<< "$specific"
            for part in "${parts[@]}"; do
                part=$(echo "$part" | xargs)
                for fa in $found_apps; do
                    if [[ "$fa" -eq "$part" ]]; then
                        filtered="$filtered $fa"
                    fi
                done
            done
            if [[ -n "$filtered" ]]; then
                process_installation "$filtered"
            fi
            ;;
        3)
            SAVE_APPS="$SELECTED_APPS $found_apps"
            echo -e "${GREEN}[OK] Agregadas a la seleccion.${RESET}"
            ;;
        4)
            return
            ;;
    esac
}

# ===================== GUARDAR Y BUSCAR =====================
save_and_search() {
    local saved_apps="$SELECTED_APPS"
    search_applications
    if [[ -z "$SELECTED_APPS" ]] && [[ -n "$saved_apps" ]]; then
        SELECTED_APPS="$saved_apps"
    fi
}

# ===================== ACTUALIZAR SISTEMA =====================
update_system() {
    echo "Actualizando lista de paquetes..."
    if [[ $EUID -eq 0 ]]; then
        apt update 2>&1 | tee -a "$LOG_FILE"
    else
        sudo apt update 2>&1 | tee -a "$LOG_FILE"
    fi

    # Asegurar flatpak remoto
    if $HAS_FLATPAK; then
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
    fi
}

# ===================== VERIFICAR REQUISITOS =====================
check_requirements() {
    local missing=()
    command -v wget &>/dev/null || command -v curl &>/dev/null || missing+=("wget o curl")
    command -v apt &>/dev/null || missing+=("apt")

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${YELLOW}[!] Herramientas faltantes: ${missing[*]}${RESET}"
        echo -e "${YELLOW}[!] Instale los paquetes necesarios para continuar.${RESET}"
    fi
}

# ===================== PUNTO DE ENTRADA =====================
main() {
    clear
    detect_environment

    # Verificar que sea Ubuntu/Debian
    if [[ "$DETECTED_DISTRO" != "ubuntu" && "$DETECTED_DISTRO" != "debian" && "$DETECTED_DISTRO" != "linuxmint" && "$DETECTED_DISTRO" != "pop" && "$DETECTED_DISTRO" != "elementary" && "$DETECTED_DISTRO" != "zorin" ]]; then
        echo -e "${YELLOW}[!] Este script esta disenado para Ubuntu/Debian.${RESET}"
        echo -e "${YELLOW}[!] Detectado: $DETECTED_DISTRO${RESET}"
        echo -e "${YELLOW}[!] Algunos comandos pueden no funcionar correctamente.${RESET}"
        sleep 2
    fi

    # Actualizar sistema antes de empezar
    echo -e "${CYAN}[*] Actualizando lista de paquetes...${RESET}"
    update_system
    check_requirements

    echo -e "${GREEN}[OK] Entorno listo. Iniciando instalador...${RESET}"
    sleep 1

    # Ir al menu
    menu
}

# ===================== INICIO =====================
main "$@"
