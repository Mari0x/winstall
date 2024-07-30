# Función para leer la lista de programas desde un archivo JSON
function Get-ProgramsFromJSON {
    $jsonFile = "programas.json" # Cambia el nombre del archivo si es necesario
    $jsonData = Get-Content $jsonFile | ConvertFrom-Json
    return $jsonData.Programas
}

# Función para mostrar el menú principal
function Show-Menu {
    param(
        [Parameter(Mandatory=$true)]
        [array]$programList,
        [int]$currentPage = 1,
        [int]$itemsPerPage = 10
    )

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                   Winstall - Instalador                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""

    # Calcular el índice inicial y final para la página actual
    $startIndex = ($currentPage - 1) * $itemsPerPage
    $endIndex = $startIndex + $itemsPerPage - 1

    # Mostrar los programas de la página actual
    for ($i = $startIndex; $i -le $endIndex -and $i -lt $programList.Count; $i++) {
        Write-Host "  $($i + 1). $($programList[$i].Nombre) - $($programList[$i].Descripcion)" -ForegroundColor Cyan
    }

    # Agregar las opciones de navegación
    Write-Host ""
    if ($currentPage -gt 1) {
        Write-Host "  Anterior"
    }
    if ($endIndex -lt $programList.Count - 1) {
        Write-Host "  Siguiente"
    }
    Write-Host "  0. Salir" -ForegroundColor Red
    Write-Host ""
}

# Función para instalar un programa (implementa tu lógica de instalación aquí)
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

# Obtener la lista de programas desde el archivo JSON
$programList = Get-ProgramsFromJSON

# Bucle principal
$currentPage = 1
do {
    Show-Menu -programList $programList -currentPage $currentPage
    $selectedOption = Read-Host "Ingrese el número de opción"

    # Validar la opción ingresada
    if ($selectedOption -eq "0") {
        break
    } elseif ($selectedOption -gt $programList.Count -or $selectedOption -lt 1) {
        Write-Host "Opción inválida. Intenta nuevamente."
        continue
    } elseif ($selectedOption -eq "Anterior") {
        $currentPage--
    } elseif ($selectedOption -eq "Siguiente") {
        $currentPage++
    } else {
        $program = $programList[$selectedOption - 1]
        Install-Program -programName $program.Nombre
    }

} while ($true)
