# Instalador de Aplicaciones - Winget Installer

[![GitHub](https://img.shields.io/github/license/GAMEZ1125/InstaladorApps-Bat)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/GAMEZ1125/InstaladorApps-Bat)](../../releases)
[![GitHub issues](https://img.shields.io/github/issues/GAMEZ1125/InstaladorApps-Bat)](../../issues)

**Instalador automatizado de aplicaciones para Windows** utilizando Winget, Chocolatey y descargas directas. Este script batch permite instalar múltiples aplicaciones de forma silenciosa y automatizada, ideal para despliegues masivos en entornos corporativos.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Uso](#-uso)
- [Aplicaciones Disponibles](#-aplicaciones-disponibles)
- [Funciones Especiales](#-funciones-especiales)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Scripts Relacionados](#-scripts-relacionados)
- [Solución de Problemas](#-solución-de-problemas)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)

## ✨ Características

- **Instalación múltiple**: Selecciona e instala múltiples aplicaciones en una sola ejecución
- **Soporte dual**: Compatible con Winget y Chocolatey
- **Descargas automáticas**: Descarga e instala aplicaciones desde URLs oficiales
- **Configuración de variables de entorno**: Configura automáticamente PATH y otras variables
- **Búsqueda de aplicaciones**: Busca aplicaciones por palabra clave
- **Desinstalador**: Módulo para desinstalar aplicaciones
- **Herramientas de administración**:
  - Gestión de usuarios y grupos
  - Limpieza de carpetas temporales
  - Borrado seguro de datos
  - Gestión de certificados
  - Gestión de adaptadores de red
  - Política de USB
- **Interfaz interactiva**: Menú fácil de usar con opciones numeradas
- **Ejecución como administrador**: Elevación automática de permisos

## 🔧 Requisitos

### Sistema Operativo
- Windows 10/11 (64-bit recomendado)
- Windows Server 2016 o superior

### Dependencias
- **Winget**: Microsoft App Installer v1.25.340 o superior
- **PowerShell**: Versión 5.1 o superior
- **.NET Framework**: 4.7.2 o superior
- **Permisos de administrador**: Requeridos para la mayoría de las instalaciones

### Opcional
- **Chocolatey**: Para paquetes que lo requieren (ej: FVM, UltraVNC)

## 📦 Instalación

### Opción 1: Clonar el repositorio

```powershell
git clone https://github.com/GAMEZ1125/InstaladorApps-Bat.git
cd InstaladorApps-Bat
```

### Opción 2: Descargar directamente

1. Descarga el archivo [`Installer.bat`](Installer.bat)
2. Guárdalo en una carpeta de tu elección
3. Ejecuta como administrador

### Verificar Winget

Antes de usar el instalador, verifica que Winget esté disponible:

```powershell
winget --version
```

Si no está instalado, usa la opción **53** o **54** del menú para instalarlo.

## 🚀 Uso

### Ejecución básica

1. **Ejecuta el script como administrador**:
   ```cmd
   Installer.bat
   ```
   O haz clic derecho → "Ejecutar como administrador"

2. **Selecciona las aplicaciones**:
   - Ingresa números individuales separados por comas: `2,5,7`
   - Usa rangos: `1-10`
   - Combina ambos: `1-5,8,10-15`
   - **[A]**: Instala todas las aplicaciones (1-90)
   - **[B]**: Buscar aplicaciones por nombre
   - **[C]**: Confirmar selección
   - **[S]**: Salir

3. **Confirma la instalación**:
   - Revisa la lista de aplicaciones seleccionadas
   - Presiona **S** para confirmar o **N** para volver al menú

### Ejemplos de selección

```
Seleccion: 2,5,7-10        # Chrome, Git, VSCode, Postman, SoapUI, Vysor, WinSCP
Seleccion: 1-5             # Las primeras 5 aplicaciones
Seleccion: A               # Todas las aplicaciones
Seleccion: B               # Modo búsqueda
```

## 📱 Aplicaciones Disponibles

### Lista Completa (1-90)

| #  | Aplicación | ID / Descripción |
|----|------------|------------------|
| 1  | Appium | `JSFoundation.Appium` |
| 2  | Google Chrome | `Google.Chrome` |
| 3  | DBeaver | `DBeaver.DBeaver.Community` |
| 4  | Mozilla Firefox | `Mozilla.Firefox` |
| 5  | Git | `Git.Git` |
| 6  | Node.js | `OpenJS.NodeJS` |
| 7  | VS Code | `Microsoft.VisualStudioCode` |
| 8  | Postman | `Postman.Postman` |
| 9  | SoapUI | `SmartBear.SoapUI` |
| 10 | Vysor | `Vysor.Vysor` |
| 11 | WinSCP | `WinSCP.WinSCP` |
| 12 | Notepad++ | `Notepad++.Notepad++` |
| 13 | Oracle JDK 21 | `Oracle.JDK.21` |
| 14 | IntelliJ IDEA | `JetBrains.IntelliJIDEA.Community` |
| 15 | SQL Server Management Studio | `Microsoft.SqlServerManagementStudio` |
| 16 | Amazon Corretto 11 | `Amazon.Corretto.11.JDK` |
| 17 | Amazon Corretto 8 | `Amazon.Corretto.8.JDK` |
| 18 | Amazon Corretto 17 | `Amazon.Corretto.17.JDK` |
| 19 | Python 3.12 | `Python.Python.3.12` |
| 20 | AWS CLI | `Amazon.AWSCLI` |
| 21 | Android Studio | `Google.AndroidStudio` |
| 22 | ShareX | `ShareX.ShareX` |
| 23 | VS Build Tools 2022 | `Microsoft.VisualStudio.2022.BuildTools` |
| 24 | MongoDB Compass | `MongoDB.Compass.Full` |
| 25 | SQL Server 2022 Express | `Microsoft.SQLServer.2022.Express` |
| 26 | VLC | `VideoLAN.VLC` |
| 27 | Microsoft Office | `Microsoft.Office` |
| 28 | .NET Framework 4 | `Microsoft.DotNet.Framework.DeveloperPack_4` |
| 29 | Eraser | `Eraser.Eraser` |
| 30 | FortiClient VPN | `Fortinet.FortiClientVPN` |
| 31 | IBM i Access | `IBMiAccess_v1r1.zip` (Descarga directa) |
| 32 | Apache Maven | `apache-maven-3.9.11-bin.zip` |
| 33 | Gradle 8.13 | `Gradle-8.13.zip` |
| 34 | FusionInventory Agent | `FusionInventory-Agent.exe` |
| 35 | Amazon WorkSpaces | `Amazon.WorkspacesClient` |
| 36 | Adobe Acrobat Reader | `Adobe.Acrobat.Reader.64-bit` |
| 37 | VS Community 2022 | `Microsoft.VisualStudio.2022.Community` |
| 38 | JMeter | `DEVCOM.JMeter` |
| 39 | Jenkins | `jenkins.msi` |
| 40 | MongoDB Server | `MongoDB.Server` |
| 41 | MongoDB Shell | `MongoDB.Shell` |
| 42 | MongoDB Database Tools | `MongoDB.DatabaseTools` |
| 43 | NoSQLBooster | `NoSQLBooster.NoSQLBooster` |
| 44 | Gradle 8.5 | `Gradle-8.5.zip` |
| 45 | Elixir | `Elixir` (Descarga manual) |
| 46 | Gradle 8.10 | `Gradle-8.10.zip` |
| 47 | Kubernetes kubectl | `Kubernetes.kubectl` |
| 48 | Tesseract OCR | `tesseract-ocr.tesseract` |
| 49 | Chocolatey | `Chocolatey.Chocolatey` |
| 50 | FVM | `FVM` (vía Chocolatey) |
| 51 | UltraVNC 1436 | `UltraVNC_1436` |
| 52 | SDelete | `Microsoft.Sysinternals.SDelete` |
| 53 | App Installer | `Microsoft.DesktopAppInstaller` |
| 54 | Instalar Winget | `Instalar_Winget` |
| 55-58 | Atera Agent | Variantes por ubicación |
| 59 | PL/SQL Developer | `PL/SQL_Developer` |
| 60 | Cisco Secure Client | `Cisco_Secure_Client_v5.1.2.42` |
| 61 | Gradle 8.14.3 | `Gradle-8.14.3.zip` |
| 62 | MongoDB Compass (alt) | `MongoDB-Compass` |
| 63 | npm Appium | `npm_appium` |
| 64 | Gestión Hosts | `Gestion_Hosts` |
| 65 | Apache JMeter 5.6.3 | `apache-jmeter-5.6.3.zip` |
| 66 | MySQL Connector ODBC | `mysql-connector-odbc-9.4.0-winx64.msi` |
| 67 | MySQL Connector NET | `mysql-connector-net-9.4.0.msi` |
| 68 | Docker Desktop | `Docker.DockerDesktop` |
| 69 | Gestión Certificados | `Gestion_Certificados` |
| 70 | Gestión Adaptadores | `Gestion_Adaptadores_de_Red` |
| 71 | OfimaBot | `OfimaBot` |
| 72 | UIPath | `UIPath` |
| 73 | Office 365 32bits | `Office365_32bits` |
| 74 | Gradle v9.0.0 | `Gradle_v9.0.0` |
| 75 | HelpDesk Xelerica | `HelpDesk_Xelerica` |
| 76 | HelpDesk OneDrive | `Helpdesk_Xelerica_OneDrive` |
| 77 | Filezilla | `Filezilla` |
| 78 | Robo3T | `3TSoftwareLabs.Robo3T` |
| 79 | DbVisualizer | `DBVis.DbVisualizer` |
| 80 | PuTTY | `PuTTY.PuTTY` |
| 81 | UltraVNC | `uvncbvba.UltraVNC` |
| 82 | UltraVNC Choco | `UltraVNC_Choco` |
| 83 | Add/Delete UserGroup | `Add/Delete_UserGroup` |
| 84 | Reserved Slot | `Reserved_Slot_84` |
| 85 | Install with Package Manager | `InstallWith_Winget_Or_Choco` |
| 86 | GlobalProtect | `GlobalProtect` |
| 87 | Desinstalar Aplicaciones | `Desinstalar_aplicaciones` |
| 88 | Agente ManageEngine | `Agente_ManageEngine` |
| 89 | Gradle 8.11 | `Gradle-8.11.zip` |
| 90 | Política USB | `Politica_USB` |

### Opciones Especiales (97-99)

| #  | Función | Descripción |
|----|---------|-------------|
| 97 | Buscar aplicaciones | Búsqueda por palabra clave |
| 98 | Temp_SQLDeveloper | Limpieza de carpetas temporales |
| 99 | Borrado seguro | Eliminación segura de datos de usuario |

## 🛠️ Funciones Especiales

### 1. Búsqueda de Aplicaciones (Opción 97 / Tecla B)

Busca aplicaciones en la lista por palabra clave:

```
Palabra clave: java
```

Muestra todas las aplicaciones que contienen "java" y permite seleccionarlas.

### 2. Borrado Seguro de Usuario (Opción 99)

Elimina de forma segura las carpetas de usuario usando SDelete:

- **Carpetas afectadas**: Desktop, Documents, Downloads, Pictures, Music, Videos
- **Método**: Sobrescritura 35 veces (estándar DoD)
- **Registro**: Genera log con fecha, hora, usuario y equipo

### 3. Limpieza SQL Developer (Opción 98)

Limpia las carpetas temporales de SQL Developer:

- `AppData\Roaming\SQL Developer`
- `AppData\Roaming\sqldeveloper`

### 4. Desinstalador de Aplicaciones (Opción 87)

Menú interactivo para desinstalar aplicaciones:

```
[1] Ver aplicaciones instaladas con Winget
[2] Ver aplicaciones instaladas con Chocolatey
[3] Desinstalar aplicación vía Winget
[4] Desinstalar aplicación vía Chocolatey
[5] Volver al menú principal
```

### 5. Gestión de Usuarios y Grupos (Opción 83)

Agrega o elimina usuarios de dominio al grupo de Administradores local:

```
Ingrese el nombre del DOMINIO (ej: chcorp): chcorp
Ingrese el nombre del USUARIO (ej: acelish): acelish
[1] AGREGAR usuario al grupo Administradores
[2] ELIMINAR usuario del grupo Administradores
```

### 6. Instalación con Gestor de Paquetes (Opción 85)

Busca e instala paquetes usando Winget o Chocolatey de forma interactiva.

### 7. Herramientas de Gestión Remota

Estas herramientas descargan scripts adicionales del repositorio:

- **Opción 64**: Gestión de Hosts (`configuraciones.bat`)
- **Opción 69**: Gestión de Certificados (`certificados.bat`)
- **Opción 70**: Gestión de Adaptadores de Red (`adaptadores.bat`)
- **Opción 90**: Política USB (`usb_politica.ps1`)

## 📁 Estructura del Proyecto

```
InstaladorApps-Bat/
├── Installer.bat              # Script principal
├── README.md                  # Este archivo
├── configuraciones.bat        # Gestión de hosts
├── certificados.bat           # Gestión de certificados
├── adaptadores.bat            # Gestión de adaptadores de red
├── limpiar_config.bat         # Limpieza de configuraciones
├── limpiar_config_C4.bat      # Limpieza específica C4
├── usb_politica.ps1           # Script de política USB
└── SOLUCION_APP88.md          # Documentación de solución
```

## 🔗 Scripts Relacionados

### configuraciones.bat
Gestión de archivos hosts para configuración de red.

### certificados.bat
Administración de certificados digitales y SSL.

### adaptadores.bat
Configuración y gestión de adaptadores de red.

### usb_politica.ps1
Script PowerShell para habilitar/deshabilitar política de puertos USB.

## 🐛 Solución de Problemas

### Winget no encontrado

**Error**: `ERROR: No se pudo encontrar winget en el sistema`

**Solución**:
1. Ejecuta la opción **53** o **54** para instalar Winget
2. Reinicia la aplicación después de la instalación
3. Verifica la versión: `winget --version`

### Error de permisos

**Error**: `Elevando permisos de administrador...`

**Solución**:
- Ejecuta el script como administrador (clic derecho → Ejecutar como administrador)

### Falla en descarga de aplicaciones

**Error**: `ERROR: Fallo en la descarga`

**Solución**:
1. Verifica tu conexión a internet
2. Intenta nuevamente (algunos servidores tienen límites)
3. Descarga manualmente desde la URL proporcionada en el código

### Chocolatey no está disponible

**Error**: `Chocolatey no esta instalado en el sistema`

**Solución**:
1. Instala Chocolatey usando la opción **49**
2. O instálalo manualmente:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

### Error en instalación de MySQL Connector

**Solución**:
- Los servidores de MySQL pueden tener problemas temporales
- Intenta nuevamente en unos minutos
- O descarga manualmente desde:
  - [MySQL Connector ODBC](https://dev.mysql.com/downloads/connector/odbc/)
  - [MySQL Connector NET](https://dev.mysql.com/downloads/connector/net/)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Para contribuir:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Soporte

Para problemas, sugerencias o preguntas:

- **Issues**: [GitHub Issues](../../issues)
- **Repositorio**: [GAMEZ1125/InstaladorApps-Bat](https://github.com/GAMEZ1125/InstaladorApps-Bat)

## ⚠️ Descargo de Responsabilidad

Este script está diseñado para uso en entornos controlados. Asegúrate de:

- Tener permisos adecuados para instalar software
- Revisar las licencias de las aplicaciones que instalas
- Probar en un entorno de prueba antes de desplegar en producción
- Hacer backup de los datos importantes antes de usar funciones de borrado

---

**Desarrollado por** [@GAMEZ1125](https://github.com/GAMEZ1125)

**Última actualización**: 2026
