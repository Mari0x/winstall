# Lista de programas
$programas = @(
    @{ Nombre = "WinRAR"; Descripcion = "Compresión y descompresión de archivos" },
    @{ Nombre = "7-Zip"; Descripcion = "Herramienta de compresión de archivos" },
    @{ Nombre = "Google Chrome"; Descripcion = "Navegador web" }
)

# Función para mostrar el menú
function Show-Menu {
    Clear-Host
    Write-Host "Selecciona un programa para instalar:"
    for ($i = 0; $i -lt $programas.Count; $i++) {
        Write-Host "$($i + 1). $($programas[$i].Nombre) - $($programas[$i].Descripcion)"
    }
}

# Función para instalar un programa
function Install-Program {
    param(
        [Parameter(Mandatory=$true)]
        [string]$programName
    )

    try {
        # Lógica de instalación (ajusta según tus necesidades)
        Write-Host "Instalando $programName..."
        winget install "$programName"
        Write-Host "Instalación completada."
    } catch {
        Write-Warning "Error al instalar $programName: $($_.Exception.Message)"
    }
}

# Mostrar el menú y obtener la selección del usuario
Show-Menu
$opcion = Read-Host "Ingrese el número del programa a instalar"

# Validar la opción y ejecutar la instalación
if ($opcion -gt 0 -and $opcion -le $programas.Count) {
    $programaSeleccionado = $programas[$opcion - 1]
    Install-Program -programName $programaSeleccionado.Nombre
} else {
    Write-Host "Opción inválida."
}
