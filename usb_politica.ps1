[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet('Estado','Bloquear','Habilitar','Desbloquear','GpUpdate','Menu','Ayuda')]
    [string]$Accion = 'Menu'
)

$RegPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices'
$ValueName = 'Deny_All'

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-Admin {
    if (-not (Test-Admin)) {
        Write-Host ''
        Write-Host 'Este script debe ejecutarse como Administrador.' -ForegroundColor Yellow
        Write-Host 'Clic derecho > Ejecutar con PowerShell como administrador.' -ForegroundColor Yellow
        exit 1
    }
}

function Get-UsbPolicyState {
    if (-not (Test-Path $RegPath)) {
        return [pscustomobject]@{
            RawValue = $null
            Estado = 'NO CONFIGURADO'
            Gpedit  = 'No configurada'
        }
    }

    try {
        $item = Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction Stop
        $raw = $item.$ValueName
    }
    catch {
        return [pscustomobject]@{
            RawValue = $null
            Estado = 'NO CONFIGURADO'
            Gpedit  = 'No configurada'
        }
    }

    switch ($raw) {
        1 {
            [pscustomobject]@{
                RawValue = 1
                Estado = 'BLOQUEADO'
                Gpedit  = 'Habilitada'
            }
        }
        0 {
            [pscustomobject]@{
                RawValue = 0
                Estado = 'HABILITADO'
                Gpedit  = 'Deshabilitada'
            }
        }
        default {
            [pscustomobject]@{
                RawValue = $raw
                Estado = "VALOR NO RECONOCIDO ($raw)"
                Gpedit  = 'Indeterminado'
            }
        }
    }
}

function Show-Estado {
    $status = Get-UsbPolicyState
    Write-Host ''
    Write-Host "Estado actual: $($status.Estado)" -ForegroundColor Cyan
    Write-Host "gpedit normalmente mostrara: $($status.Gpedit)"
    if ($null -ne $status.RawValue) {
        Write-Host "Valor del registro: $ValueName = $($status.RawValue)"
    }
}

function Set-UsbPolicyBlocked {
    Assert-Admin
    New-Item -Path $RegPath -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name $ValueName -PropertyType DWord -Value 1 -Force | Out-Null
    Write-Host ''
    Write-Host 'Politica aplicada: BLOQUEADO.' -ForegroundColor Green
    Write-Host 'Todas las clases de almacenamiento extraible: denegar acceso a todo = Habilitada'
    Show-Estado
}

function Set-UsbPolicyEnabled {
    Assert-Admin
    New-Item -Path $RegPath -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name $ValueName -PropertyType DWord -Value 0 -Force | Out-Null
    Write-Host ''
    Write-Host 'Politica aplicada: HABILITADO.' -ForegroundColor Green
    Write-Host 'Todas las clases de almacenamiento extraible: denegar acceso a todo = Deshabilitada'
    Show-Estado
}

function Invoke-PolicyRefresh {
    Assert-Admin
    Write-Host ''
    Write-Host 'Ejecutando gpupdate /force ...' -ForegroundColor Cyan
    gpupdate /force
}

function Show-Help {
    Write-Host ''
    Write-Host 'Uso:'
    Write-Host '  .\usb_politica.ps1 Estado'
    Write-Host '  .\usb_politica.ps1 Bloquear'
    Write-Host '  .\usb_politica.ps1 Habilitar'
    Write-Host '  .\usb_politica.ps1 GpUpdate'
    Write-Host ''
    Write-Host 'Si no pasas parametros, se abrira un menu interactivo.'
}

function Show-Menu {
    do {
        Write-Host ''
        Write-Host '================================' -ForegroundColor DarkGray
        Write-Host ' Politica de USB / almacenamiento' -ForegroundColor White
        Write-Host '================================' -ForegroundColor DarkGray
        Write-Host '1. Ver estado'
        Write-Host '2. Bloquear'
        Write-Host '3. Habilitar'
        Write-Host '4. Ejecutar gpupdate /force'
        Write-Host '5. Ayuda'
        Write-Host '6. Salir'
        Write-Host ''
        $opt = Read-Host 'Seleccione una opcion [1-6]'

        switch ($opt) {
            '1' { Show-Estado }
            '2' { Set-UsbPolicyBlocked }
            '3' { Set-UsbPolicyEnabled }
            '4' { Invoke-PolicyRefresh }
            '5' { Show-Help }
            '6' { break }
            default { Write-Host 'Opcion no valida.' -ForegroundColor Yellow }
        }
    } while ($true)
}

switch ($Accion.ToLower()) {
    'estado' { Show-Estado }
    'bloquear' { Set-UsbPolicyBlocked }
    'habilitar' { Set-UsbPolicyEnabled }
    'desbloquear' { Set-UsbPolicyEnabled }
    'gpupdate' { Invoke-PolicyRefresh }
    'ayuda' { Show-Help }
    'menu' { Show-Menu }
    default { Show-Help }
}
