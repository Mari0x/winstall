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

# Mostrar el menú de opciones y obtener la selección del usuario
do {
    Write-Host "Selecciona un programa a instalar:"
    for ($i = 0; $i -lt $programList.Count; $i++) {
        Write-Host "$($i+1). $($programList[$i])"
    }

    $selectedOption = Read-Host "Ingrese el número de opción:"

    # Validar la opción seleccionada
    if ($selectedOption -gt $programList.Count -or $selectedOption -lt 1) {
        Write-Host "Opción inválida."
        continue
    }

    # Obtener el programa seleccionado
    $program = $programList[$selectedOption - 1]

    # Preguntar si desea instalar el programa seleccionado
    $confirm = Read-Host "¿Desea instalar $program? (s/n)" -eq "s"
    if ($confirm) {
        Install-Program -programName $program
        Write-Host "Instalación completa."
    }

    # Preguntar si desea instalar otro programa y cerrar el script si la respuesta es "n"
    $continue = Read-Host "¿Desea instalar otro programa? (s/n)" -eq "s"
} while ($continue)

Write-Host "¡Hasta luego!"
