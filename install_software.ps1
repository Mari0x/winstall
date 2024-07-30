param(
    [Parameter(Mandatory=$true)]
    [string]$program,

    [Parameter(Mandatory=$false)]
    [string]$version,

    [Parameter(Mandatory=$false)]
    [switch]$interactive
)

function Install-Program {
    param(
        [Parameter(Mandatory=$true)]
        [string]$programName,

        [Parameter(Mandatory=$false)]
        [string]$programVersion
    )
    # Lógica de instalación utilizando Winget o otros gestores de paquetes
    Write-Host "Instalando $programName..."
    if ($programVersion) {
        winget install "$programName" --version "$programVersion"
    } else {
        winget install "$programName"
    }
    # Agregar registro de instalación
    Add-Content -Path "install_log.txt" -Value "[$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))] $programName $programVersion instalado."
}

switch ($program) {
    "WinRAR" {
        Install-Program -programName "WinRAR" -programVersion $version
    }
    "7-Zip" {
        Install-Program -programName "7-Zip" -programVersion $version
    }
    # Agrega más casos aquí
    default {
        Write-Warning "Programa no válido: $program"
    }
}

if ($interactive) {
    Write-Host "Instalación completada."
    Read-Host "Presiona una tecla para continuar..."
}
