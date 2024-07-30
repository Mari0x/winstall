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

# Lista de programas disponibles
$programList = @("WinRAR", "7-Zip", "Visual Studio Code", "Chrome", "Steam", "Discord", "VLC")

# Array para almacenar las selecciones del usuario
$selectedPrograms = @()

# Bucle principal para permitir múltiples selecciones
do {
    # Mostrar el menú de opciones
    Write-Host "Selecciona un programa a instalar:"
    for ($i = 0; $i -lt $programList.Count; $i++) {
        Write-Host "$($i+1). $($programList[$i])"
    }

    # Leer la opción seleccionada por el usuario
    $selectedOption = Read-Host "Ingrese el número de opción (o 'q' para salir):"

    # Validar la opción seleccionada
    if ($selectedOption -eq 'q') {
        break
    } elseif ($selectedOption -gt $programList.Count -or $selectedOption -lt 1) {
        Write-Host "Opción inválida."
        continue
    }

    # Agregar el programa seleccionado al array
    [array]$selectedPrograms += $selectedOption
} while ($true)

# Instalar los programas seleccionados
foreach ($index in $selectedPrograms) {
    $program = $programList[$index - 1]
    Install-Program -programName $program
}

Write-Host "Instalación completa."
