#!/bin/bash
# 🛡️ Script profesional aplicación de actualizaciones
# 🕵️ Creado por Esteban Nuñez
set -euo pipefail

DIR_LOG="/var/log/mis_actualizaciones"
mkdir -p "$DIR_LOG"
FECHA=$(date +'%d-%b-%y' | tr '[:upper:]' '[:lower:]')
ARCHIVO_LOG="$DIR_LOG/actualizaciones_${FECHA}.txt"
touch "$ARCHIVO_LOG"

log() {
    echo "[$(date +'%H:%M:%S')] $*" | tee -a "$ARCHIVO_LOG"
}

detectar_distro() {
    DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
    log "Distribución detectada: $DISTRO"

    case "$DISTRO" in
        ubuntu|debian)
            ACTUALIZAR="apt-get update"
            DISPONIBLES="apt list --upgradable"
            APLICAR="apt-get upgrade -y"
            LISTAR_INSTALADAS="apt-mark showmanual"
            ;;
        centos|rhel)
            if command -v yum >/dev/null; then
                ACTUALIZAR="yum check-update || true"
                DISPONIBLES="yum list updates || true"
                APLICAR="yum update -y"
                LISTAR_INSTALADAS="yum list installed"
            else
                ACTUALIZAR="dnf check-update || true"
                DISPONIBLES="dnf list updates || true"
                APLICAR="dnf upgrade -y"
                LISTAR_INSTALADAS="dnf list installed"
            fi
            ;;
        fedora)
            ACTUALIZAR="dnf check-update || true"
            DISPONIBLES="dnf list updates || true"
            APLICAR="dnf upgrade -y"
            LISTAR_INSTALADAS="dnf list installed"
            ;;
        arch)
            ACTUALIZAR="pacman -Sy"
            DISPONIBLES="pacman -Qu || true"
            APLICAR="pacman -Su --noconfirm"
            LISTAR_INSTALADAS="pacman -Qe"
            ;;
        *)
            log "❌ Distribución no soportada: $DISTRO"
            exit 1
            ;;
    esac
}

actualizar_sistema() {
    log "🔄 Ejecutando: actualización de índices"
    eval "$ACTUALIZAR" >> "$ARCHIVO_LOG" 2>&1 || log "⚠️ Error al actualizar índices"

    log "📦 Verificando actualizaciones disponibles"
    eval "$DISPONIBLES" >> "$ARCHIVO_LOG" 2>&1 || log "⚠️ Error al listar actualizaciones"

    log "⬆️ Aplicando actualizaciones del sistema"
    eval "$APLICAR" >> "$ARCHIVO_LOG" 2>&1 || log "⚠️ Error al aplicar actualizaciones"

    log "📋 Paquetes instalados tras actualización"
    eval "$LISTAR_INSTALADAS" >> "$ARCHIVO_LOG" 2>&1 || log "⚠️ Error al listar paquetes instalados"
}

auditar_etc() {
    log "🧾 Archivos modificados en /etc en las últimas 24h:"
    find /etc -type f -mtime -1 >> "$ARCHIVO_LOG" 2>/dev/null || log "⚠️ No se encontraron cambios recientes en /etc"
}

rotar_logs() {
    log "♻️ Rotando logs. Conservando los últimos 10 informes..."
    cd "$DIR_LOG"
    ls -1tr actualizaciones_*.txt | head -n -10 | xargs -r rm -f
}

log "==============================="
log "🛡️ Inicio del proceso de actualización - $FECHA"
log "==============================="

detectar_distro
actualizar_sistema
auditar_etc
rotar_logs

log "✅ Proceso completado correctamente"