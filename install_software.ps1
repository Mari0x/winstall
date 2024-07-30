function Install-Program {
    param(
        [Parameter(Mandatory=$true)]
        [string]$programName
    )

    Write-Host "Instalando $programName..."
    # Lógica de instalación utilizando Winget o otros gestores de paquetes
    winget install "$programName"

    Write-Host "Instalación de $programName completada."
}

# Lista de programas disponibles
$programList = @("WinRAR", "7-Zip", "Visual Studio Code", "Chrome", "Steam", "Discord", "VLC")

# Función para mostrar el menú de opciones de forma más clara
function Show-Menu {
    Write-Host "Selecciona un programa a instalar:"
    for ($i = 0; $i -lt $programList.Count; $i++) {
        Write-Host "$($i+1). $($programList[$i])"
    }
}

# Bucle principal
do {
    Show-Menu

    $selectedOption = Read-Host "Ingrese el número de opción (o 'q' para salir)"

    if ($selectedOption -eq 'q') {
        break
    }

    if ($selectedOption -gt $programList.Count -or $selectedOption -lt 1) {
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

    # Preguntar si desea instalar otro programa
    $continue = Read-Host "¿Deseas instalar otro programa? (s/n)" -eq "s"
} while ($continue)

Write-Host "¡Hasta luego!"
