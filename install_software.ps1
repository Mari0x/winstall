# Definir la variable del archivo JSON una sola vez
$jsonFile = "https://raw.githubusercontent.com/Mari0x/winstall/main/programas.json"

# Función para leer la lista de programas desde un archivo JSON
function Get-ProgramsFromJSON {
    param (
        [Parameter(Mandatory=$true)]
        [string]$jsonFile
    )

    try {
        $jsonData = Invoke-WebRequest -Uri $jsonFile
        $parsedData = ConvertFrom-Json $jsonData.Content

        # Verificar si la propiedad "Programas" existe y es un array
        if ($parsedData.Programas -is [array]) {
            return $parsedData.Programas
        } else {
            Write-Warning "La propiedad 'Programas' no existe o no es un array en el archivo JSON."
            return $null
        }
    } catch {
        Write-Warning "Error al obtener la lista de programas: $($_.Exception.Message)"
        return $null
    }
}

# Función para mostrar el menú principal
function Show-Menu {
    param (
        [Parameter(Mandatory=$true)]
        [array]$programList,
        [int]$currentPage = 1,
        [int]$itemsPerPage = 10
    )

    # Calcular el índice inicial y final para la página actual
    $startIndex = ($currentPage - 1) * $itemsPerPage
    $endIndex = [Math]::Min(($currentPage * $itemsPerPage) - 1, $programList.Count - 1)

    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════╗" 
    Write-Host "║           Winstall - Instalador                        ║" 
    Write-Host "╚════════════════════════════════════════════════════════╝" 
    Write-Host ""

    Write-Host "╔════════════════════════════════════════════════════════╗"
    Write-Host "║ No. ║ Nombre                   ║ Descripción           ║"
    Write-Host ""

    # Mostrar los programas en una tabla
    for ($i = $startIndex; $i -le $endIndex; $i++) {
        Write-Host ("║ {0} ║ {1,-25} ║ {2,-35} ║" -f ($i + 1), $programList[$i].Nombre, $programList[$i].Descripcion)
    }

    # Línea divisoria final
    Write-Host "╚════════════════════════════════════════════════════════╝"

    # Agregar las opciones de navegación
    Write-Host ""
    if ($currentPage -gt 1) {
        Write-Host " Anterior"
    }
    if ($endIndex -lt $programList.Count - 1) {
        Write-Host " Siguiente"
    }
    Write-Host " 0. Salir"
    Write-Host ""
}

# Función para instalar un programa
function Install-Program {
    param(
        [Parameter(Mandatory=$true)]
        [string]$programName
    )

    Write-Host "Instalando $programName..."
    # Verificar si winget está disponible
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install "$programName"
        Write-Host "Instalación de $programName completada."
    } else {
        Write-Warning "Winget no está instalado o no está disponible en el sistema."
    }
}

# Obtener la lista de programas
$programList = Get-ProgramsFromJSON -jsonFile $jsonFile

# Mostrar el menú y manejar la interacción del usuario
$currentPage = 1
do {
    Show-Menu -programList $programList -currentPage $currentPage

    # Obtener la opción seleccionada por el usuario
    $selectedOption = Read-Host "Ingrese el número de opción o el nombre del programa (para buscar)"

    # Validar la opción ingresada
    if ($selectedOption -eq "0") {
        break
    } elseif ($selectedOption -match '^\d+$') { # Si es un número
        $index = [int]$selectedOption - 1
        if ($index -ge 0 -and $index -lt $programList.Count) {
            $program = $programList[$index]
            Install-Program -programName $program.Nombre
        } else {
            Write-Host "Opción inválida."
        }
    } else {
        # Buscar el programa por nombre
        $foundProgram = $programList | Where-Object { $_.Nombre -match $selectedOption }
        if ($foundProgram) {
            Install-Program -programName $foundProgram.Nombre
        } else {
            Write-Host "Programa no encontrado."
        }
    }

    # Actualizar la página actual si se seleccionó "Anterior" o "Siguiente"
    if ($selectedOption -eq "Anterior" -and $currentPage -gt 1) {
        $currentPage--
    } elseif ($selectedOption -eq "Siguiente" -and $endIndex -lt $programList.Count - 1) {
        $currentPage++
    }
} while ($true)

