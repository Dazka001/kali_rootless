#!/bin/bash
set -euo pipefail

# ---
# Nexus Kali: Instalador Profesional vFinal
# Creado por Dazka001.
# Incorpora verificación GPG, lanzador global y arquitectura modular.
# ---

# --- Variables Globales y Colores ---
PANEL_SCRIPT_NAME="panel_upgrade.sh"
GPG_KEY_URL="https://archive.kali.org/archive-keyring.gpg"

# Códigos de color
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # Sin color

# --- Funciones de Utilidad ---
log_info() { echo -e "${GREEN}[✔]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✘]${NC} $1"; exit 1; }

ask() {
    while true; do
        read -p "$(echo -e "${YELLOW}[?]${NC} $1 (Y/n) ")" REPLY
        case "$REPLY" in
            Y*|y*|"") return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

print_banner() {
    /data/data/com.termux/files/usr/bin/clear
    echo -e "${CYAN} __   __  _______  __   __    __   __  ___      _______  ___ ${NC}"
    echo -e "${CYAN}|  | |  ||   _   ||  | |  |  |  | |  ||   |    |       ||   |${NC}"
    echo -e "${BLUE}|  |_|  ||  |_|  ||  |_|  |  |  |_|  ||   |    |    ___||   |${NC}"
    echo -e "${BLUE}|       ||       ||       |  |       ||   |    |   |___ |   |${NC}"
    echo -e "${MAGENTA}|       ||       ||    _  |  |       ||   |___ |    ___||   |___ ${NC}"
    echo -e "${MAGENTA}|   _   ||   _   ||   |_| |  |   _   ||       ||   |___ |       |${NC}"
    echo -e "${YELLOW}|__| |__||__| |__||__| |__|  |__| |__||_______||_______||_______|${NC}"
    echo -e "${YELLOW}                                     Creado por: Dazka001${NC}\n"
}

show_help() {
    print_banner
    echo -e "Uso: bash $(basename "$0") [OPCIÓN]"
    echo -e "\nInstalador avanzado para el entorno Nexus Kali."
    echo -e "\nOPCIONES:"
    echo -e "  -u, --uninstall    ${YELLOW}Elimina por completo la instalación de Nexus Kali.${NC}"
    echo -e "  -h, --help         ${YELLOW}Muestra este mensaje de ayuda.${NC}"
    exit 0
}

# --- Funciones del Instalador ---
check_termux() {
    log_info "Verificando entorno Termux y espacio..."
    if ! command -v termux-setup-storage &>/dev/null; then
        log_error "Este script debe ejecutarse en Termux."
    fi
    local df_kb
    df_kb=$(df "$HOME" | tail -1 | awk '{print $4}')
    if (( df_kb < 4000000 )); then # ~4GB de espacio libre requerido
        log_error "Espacio insuficiente en disco (~$(($df_kb/1024))MB disponibles)."
    fi
}

check_arch() {
    log_info "Verificando arquitectura del sistema..."
    local arch
    arch=$(uname -m)
    case "$arch" in
        aarch64) SYS_ARCH="arm64" ;;
        armv7l|armhf) SYS_ARCH="armhf" ;;
        *) log_error "Arquitectura no soportada: $arch" ;;
    esac
    log_info "Arquitectura detectada: $SYS_ARCH"
}

verify_rootfs_integrity() {
    local image_file="$1"
    local base_url="$2"
    
    log_info "Descargando archivos de verificación (keyring, sums, gpg)..."
    curl -fsSL --progress-bar "$GPG_KEY_URL" -o "kali-archive-keyring.gpg" || log_error "Fallo al descargar GPG Keyring."
    curl -fsSL --progress-bar "${base_url}/SHA512SUMS" -o "SHA512SUMS" || log_error "Fallo al descargar SHA512SUMS."
    curl -fsSL --progress-bar "${base_url}/SHA512SUMS.gpg" -o "SHA512SUMS.gpg" || log_error "Fallo al descargar SHA512SUMS.gpg."

    log_info "Verificando la firma GPG de los checksums..."
    if ! gpg --no-default-keyring --keyring ./kali-archive-keyring.gpg --verify SHA512SUMS.gpg SHA512SUMS 2>/dev/null; then
        log_error "¡La firma GPG de los checksums es INVÁLIDA! Riesgo de seguridad."
    fi
    log_info "   -> Firma GPG verificada. Los checksums son auténticos."

    log_info "Verificando el checksum SHA512 del RootFS..."
    if ! grep "$image_file" SHA512SUMS | sha512sum --check -; then
        log_error "¡El checksum del RootFS no coincide! El archivo está corrupto o incompleto."
    fi
    log_info "   -> Checksum del RootFS verificado. El archivo es íntegro."
}

do_uninstall() {
    if ask "Estás a punto de eliminar por completo el entorno Nexus Kali. ¿Continuar?"; then
        log_info "Iniciando desinstalación..."
        check_arch
        local chroot_dir="kali-${SYS_ARCH}"
        rm -rf "$HOME/$chroot_dir"
        rm -f "$PREFIX/bin/nexus-kali" "$PREFIX/bin/nh"
        log_info "¡Desinstalación completada!"
    else
        echo "Desinstalación cancelada."
    fi
    exit 0
}

# --- Lógica de Argumentos (Ayuda y Desinstalación) ---
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
fi

if [[ "${1:-}" == "-u" || "${1:-}" == "--uninstall" ]]; then
    do_uninstall
fi

# --- EJECUCIÓN PRINCIPAL DE INSTALACIÓN ---
main() {
    print_banner
    log_info "--- Iniciando Instalador Profesional de Nexus Kali ---"

    log_info "[1/7] Preparando entorno y dependencias..."
    pkg update -y && pkg install proot tar wget curl gnupg ncurses-utils -y
    check_termux
    check_arch
    local CHROOT_DIR="kali-${SYS_ARCH}"
    rm -rf "$HOME/$CHROOT_DIR" "kali-nethunter-rootfs"*

    log_info "[2/7] Selecciona la imagen a instalar:"
    echo -e "${CYAN}   1) Full (Completa)  2) Minimal (Mínima)  3) Nano (Básica)${NC}"
    read -p "Tu elección [1]: " choice
    case "$choice" in
        2) wimg="minimal" ;;
        3) wimg="nano" ;;
        *) wimg="full" ;;
    esac
    log_info "   -> Imagen seleccionada: Kali NetHunter ${wimg}"

    local IMAGE="kali-nethunter-rootfs-${wimg}-${SYS_ARCH}.tar.xz"
    local BASE="https://kali.download/nethunter-images/current/rootfs"
    
    log_info "[3/7] Descargando RootFS (${IMAGE})..."
    curl -fL --progress-bar -o "$IMAGE" "${BASE}/${IMAGE}" || log_error "Fallo al descargar la imagen."
    
    log_info "[4/7] Verificando integridad y autenticidad (GPG)..."
    verify_rootfs_integrity "$IMAGE" "$BASE"

    log_info "[5/7] Extrayendo RootFS (puede tardar varios minutos)..."
    mkdir -p "$HOME/$CHROOT_DIR"
    proot --link2symlink tar -xJf "$IMAGE" -C "$HOME/$CHROOT_DIR" || log_error "Fallo al extraer el RootFS."
    
    log_info "[6/7] Configurando entorno y creando lanzador global..."
    local ROOTFS_PATH="$HOME/$CHROOT_DIR"
    local LAUNCHER_PATH="$PREFIX/bin/nexus-kali"
    local SHORTCUT_PATH="$PREFIX/bin/nh"
    
    cat > "$LAUNCHER_PATH" <<- EOF
#!/bin/bash
# --- Lanzador Global para Nexus Kali ---
# AVISO: Este entorno proot no es un sandbox de seguridad.
unset LD_PRELOAD
exec proot \\
  --link2symlink -0 -r "$ROOTFS_PATH" \\
  -b /dev -b /proc -b /sys \\
  -b "$ROOTFS_PATH/root:/dev/shm" \\
  -w /root \\
  /usr/bin/env -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \\
  LANG=C.UTF-8 TERM=\$TERM /bin/bash --login
EOF

    chmod +x "$LAUNCHER_PATH"
    ln -sf "$LAUNCHER_PATH" "$SHORTCUT_PATH"
    
    # Configurar DNS de Quad9 (privacidad)
    echo "nameserver 9.9.9.9" > "$ROOTFS_PATH/etc/resolv.conf"
    echo "nameserver 149.112.112.11" >> "$ROOTFS_PATH/etc/resolv.conf"
    
    if [[ -f "$ROOTFS_PATH/usr/bin/sudo" ]]; then
        chmod +s "$ROOTFS_PATH/usr/bin/sudo"
    fi

    if [[ -f "$PANEL_SCRIPT_NAME" ]]; then
        if ask "¿Deseas incluir el script de personalización del panel en Kali?"; then
            cp "$PANEL_SCRIPT_NAME" "$ROOTFS_PATH/root/"
            chmod +x "$ROOTFS_PATH/root/$PANEL_SCRIPT_NAME"
        fi
    fi

    log_info "[7/7] Limpiando archivos temporales..."
    rm -f "$IMAGE" SHA512SUMS* kali-archive-keyring.gpg

    print_banner
    log_info "🎉 ¡Instalación finalizada con éxito!"
    log_info "➡ Ejecuta 'nexus-kali' (o 'nh') desde cualquier lugar para iniciar."
    log_warning "AVISO: El entorno Kali se ejecuta con proot y no es un sandbox de seguridad."
    
    if [[ -f "$ROOTFS_PATH/root/$PANEL_SCRIPT_NAME" ]]; then
        log_info "➡ Una vez dentro, ejecuta 'bash $PANEL_SCRIPT_NAME' para personalizar."
    fi

    echo ""
    echo -e "${YELLOW}--------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}En memoria a mi perra Mimi, quien falleció en el proceso de Nexus Kali.${NC}"
    echo -e "${YELLOW}--------------------------------------------------------------------${NC}"
    echo ""
}

# --- Iniciar la ejecución del script ---
main
