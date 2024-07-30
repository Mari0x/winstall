# Función para mostrar el menú principal
function Show-Menu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                   Winstall - Instalador                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""

    # Obtener la lista de programas instalados
    $installedPrograms = Get-Package -Provider Winget

    # Crear un contador para numerar las opciones
    $counter = 1

    # Iterar sobre los programas instalados y agregarlos al menú
    foreach ($program in $installedPrograms) {
        Write-Host "  $($counter++). $($program.Name) - $($program.Description)" -ForegroundColor Cyan
    }

    # Agregar la opción de salir
    Write-Host ""
    Write-Host "  0. Salir" -ForegroundColor Red
    Write-Host ""
}

# Función para instalar un programa
function Install-Program {
    param(
        [Parameter(Mandatory=$true)]
        [string]$programName
    )

    Write-Host "Instalando $programName..."
    # Lógica de instalación (ej: usando Winget)
    winget install "$programName"
    Write-Host "Instalación de $programName completada."
}

# Lista de programas disponibles
$programList = @("WinRAR", "7-Zip", "Visual Studio Code", "Chrome", "Steam", "Discord", "VLC")

# Bucle principal
do {
    Show-Menu
    $selectedOption = Read-Host "Ingrese el número de opción:"

    # Validar la opción ingresada
    if ($selectedOption -eq "0") {
        break
    } elseif ($selectedOption -gt $programList.Count -or $selectedOption -lt 1) {
        Write-Host "Opción inválida. Intenta nuevamente."
        continue
    }

    $program = $programList[$selectedOption - 1]

    # Confirmar la instalación
    $confirm = Read-Host "¿Estás seguro de que deseas instalar $program? (s/n)" -eq "s"
    if ($confirm) {
        Install-Program -programName $program
    } else {
        Write-Host "Instalación cancelada."
    }

} while ($true)
