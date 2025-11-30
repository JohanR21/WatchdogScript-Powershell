# Limpiamos pantalla
Clear-Host
Write-Host "--- MONITOR DE INTEGRIDAD DE ARCHIVOS (FIM) ---" -ForegroundColor Cyan

# 1. Definir qué archivo vamos a vigilar
# (Cambia esta ruta por la de tu archivo real si es necesario)
$ArchivoObjetivo = "$HOME\Desktop\secreto.txt"

# Verificamos si existe antes de empezar
if (-not (Test-Path $ArchivoObjetivo)) {
    Write-Host "[ERROR] No encuentro el archivo: $ArchivoObjetivo" -ForegroundColor Red
    Break
}

# 2. Calcular la Huella Digital Original (HASH)
# SHA256 es el algoritmo criptográfico estándar.
$HashOriginal = (Get-FileHash -Path $ArchivoObjetivo -Algorithm SHA256).Hash

Write-Host "Vigilando: $ArchivoObjetivo" -ForegroundColor Gray
Write-Host "Hash Inicial: $HashOriginal" -ForegroundColor Green
Write-Host "------------------------------------------------"

# 3. El Bucle de Vigilancia
while ($true) {
    
    # Calculamos el Hash ACTUAL en este momento
    $HashActual = (Get-FileHash -Path $ArchivoObjetivo -Algorithm SHA256).Hash

    # 4. La Comparacion (Si son diferentes, hubo un ataque)
    # -ne significa "Not Equal" (No es igual)
    if ($HashOriginal -ne $HashActual) {
        
        # ALERTA ROJA SONORA (Beep del sistema)
        [console]::Beep(1000, 500) 
        
        Write-Host "[ALERTA] ¡EL ARCHIVO HA SIDO MODIFICADO!" -ForegroundColor Red -BackgroundColor Yellow
        Write-Host "Nuevo Hash: $HashActual" -ForegroundColor Red
        
        # Actualizamos el hash original para no seguir gritando por el mismo cambio
        $HashOriginal = $HashActual
        Write-Host "--- Referencia actualizada, siguiendo vigilancia... ---" -ForegroundColor Gray
    }
    else {
        # Todo tranquilo (opcional: escribir un punto para saber que esta vivo)
        Write-Host "." -NoNewline -ForegroundColor DarkGray
    }

    # Dormir 2 segundos
    Start-Sleep -Seconds 2
}