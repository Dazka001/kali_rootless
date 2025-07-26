#!/bin/bash
set -euo pipefail

# ---
# Nexus Kali: Instalador Profesional vFinal
# Creado por Dazka001.
# ---

# --- Variables Globales y Colores ---
PANEL_SCRIPT_NAME="panel_upgrade.sh"
GPG_KEY_URL="https://archive.kali.org/archive-keyring.gpg"
GREEN='\033${NC} $1"; }
log_error() { echo -e "${RED}[✘]${NC} $1"; exit 1; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
ask() {
    while true; do
        read -p "$(echo -e "${YELLOW}[?]${NC} $1 ")" REPLY
        case "$REPLY" in
            Y*|y*|"") return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}
print_banner() {
    /data/data/com.termux/files/usr/bin/clear
    echo -e "${CYAN} __   __  _______  __   __    __   __  ___      _______  ___ ${NC}"
    echo -e "${CYAN}| | | |

| _ |
| | | | | | | |
| | | |
| |${NC}"
    echo -e "${BLUE}| |_| |

| |_| |
| |_| | | |_| |
| | | ___|| |${NC}"
    echo -e "${BLUE}| |

| |
| | | |
| | | |___ | |${NC}"
    echo -e "${MAGENTA}| |

| |
| _ | | |
| |___ | ___|| |___ ${NC}"
    echo -e "${MAGENTA}| _ |

| _ |
| |_| | | _ |
| |
| |___ | |${NC}"
    echo -e "${YELLOW}|__| |__||__| |__||__| |__| |__| |__||_______||_______||_______|${NC}"
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
    if! command -v termux-setup-storage &>/dev/null; then
        log_error "Este script debe ejecutarse en Termux."
    fi
    local df_kb=$(df "$PWD" | tail -1 | awk '{print $4}')
    if (( df_kb < 2000000 )); then
        log_error "Espacio insuficiente en disco (~$(($df_kb/1024))MB disponibles)."
    fi
}

get_chroot_dir_name() {
    local arch=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/armv7l/armhf/')
    echo "kali-${arch}"
}

verify_rootfs_integrity() {
    local image_file="$1"
    local base_url="$2"
    log_info "Descargando archivos de verificación (keyring, sums, gpg)..."
    curl -fsSL "$GPG_KEY_URL" -o "kali-archive-keyring.gpg"
    curl -fsSL "${base_url}/SHA512SUMS" -o "SHA512SUMS"
    curl -fsSL "${base_url}/SHA512SUMS.gpg" -o "SHA512SUMS.gpg"

    log_info "Verificando la firma GPG de los checksums..."
    if! gpg --no-default-keyring --keyring./kali-archive-keyring.gpg --verify SHA512SUMS.gpg SHA512SUMS 2>/dev/null; then
        log_error "¡La firma GPG de los checksums es INVÁLIDA! Riesgo de seguridad."
    fi
    log_info "   -> Firma GPG verificada. Los checksums son auténticos."

    log_info "Verificando el checksum SHA512 del RootFS..."
    if! grep "$image_file" SHA512SUMS | sha512sum --check -; then
        log_error "¡El checksum del RootFS no coincide! El archivo está corrupto."
    fi
    log_info "   -> Checksum del RootFS verificado."
}

# --- Lógica de Argumentos (Ayuda y Desinstalación) ---
if [[ "${1:-}" == "-h" |

| "${1:-}" == "--help" ]]; then
    show_help
fi

if [[ "${1:-}" == "-u" |

| "${1:-}" == "--uninstall" ]]; then
    if ask "Estás a punto de eliminar por completo el entorno Nexus Kali. ¿Continuar?"; then
        log_info "Iniciando desinstalación..."
        CHROOT_DIR=$(get_chroot_dir_name)
        rm -rf "$HOME/$CHROOT_DIR"
        rm -f "$PREFIX/bin/nexus-kali" "$PREFIX/bin/nh"
        log_info "¡Desinstalación completada!"
    else
        echo "Desinstalación cancelada."
    fi
    exit 0
fi

# --- EJECUCIÓN PRINCIPAL DE INSTALACIÓN ---
main() {
    print_banner
    log_info "--- Iniciando Instalador Profesional de Nexus Kali ---"

    log_info "[1/7] Preparando entorno y dependencias..."
    pkg update -y && pkg install proot tar wget curl gnupg ncurses-utils -y
    check_termux
    
    ARCH=$(uname -m)
    case "$ARCH" in
        aarch64) SYS_ARCH="arm64" ;;
        armv7l|armhf) SYS_ARCH="armhf" ;;
        *) log_error "Arquitectura no soportada: $ARCH" ;;
    esac
    log_info "Arquitectura detectada: $SYS_ARCH"
    local CHROOT_DIR="kali-${SYS_ARCH}"
    rm -rf "$CHROOT_DIR" "kali-nethunter-rootfs"*

    log_info "[2/7] Selecciona la imagen a instalar:"
    echo -e "${CYAN}   1) Full (~8GB)  2) Minimal (~2GB)  3) Nano (~600MB)${NC}"
    read -p "Tu elección : " choice
    case $choice in 2) wimg="minimal" ;; 3) wimg="nano" ;; *) wimg="full" ;; esac
    log_info "   -> Imagen seleccionada: $wimg"

    IMAGE="kali-nethunter-rootfs-${wimg}-${SYS_ARCH}.tar.xz"
    BASE="https://kali.download/nethunter-images/current/rootfs"
    
    log_info "[3/7] Descargando RootFS..."
    curl -fL --progress-bar -o "$IMAGE" "${BASE}/${IMAGE}" |

| log_error "Fallo al descargar la imagen."
    
    log_info "[4/7] Verificando integridad y autenticidad (GPG)..."
    verify_rootfs_integrity "$IMAGE" "$BASE"

    log_info "[5/7] Extrayendo RootFS..."
    mkdir -p "$CHROOT_DIR"
    proot --link2symlink tar -xJf "$IMAGE" -C "$CHROOT_DIR"
    
    log_info "[6/7] Configurando entorno y creando lanzador global..."
    ROOTFS_PATH="$PWD/$CHROOT_DIR"
    LAUNCHER_PATH="$PREFIX/bin/nexus-kali"
    SHORTCUT_PATH="$PREFIX/bin/nh"
    cat > "$LAUNCHER_PATH" <<- EOF
#!/bin/bash
# --- Lanzador Global para Nexus Kali ---
# AVISO: Este entorno proot no es un sandbox de seguridad.
unset LD_PRELOAD
exec proot \\
  --link2symlink -0 -r "$ROOTFS_PATH" \\
  -b /dev -b /proc -b /sys -w /root \\
  /usr/bin/env -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \\
  LANG=C.UTF-8 TERM=\$TERM /bin/bash --login
EOF
    chmod +x "$LAUNCHER_PATH"
    ln -sf "$LAUNCHER_PATH" "$SHORTCUT_PATH"
    echo "nameserver 9.9.9.9" > "$ROOTFS_PATH/etc/resolv.conf"
    echo "nameserver 149.112.112.11" >> "$ROOTFS_PATH/etc/resolv.conf"
    if; then
        chmod +s "$ROOTFS_PATH/usr/bin/sudo"
    fi

    if; then
        if ask "¿Deseas incluir el script de personalización del panel en Kali?"; then
            cp "$PANEL_SCRIPT_NAME" "$ROOTFS_PATH/root/"
            chmod +x "$ROOTFS_PATH/root/$PANEL_SCRIPT_NAME"
        fi
    fi

    log_info "[7/7] Limpiando archivos temporales..."
    rm "$IMAGE" SHA512SUMS* kali-archive-keyring.gpg

    print_banner
    log_info "🎉 Instalación finalizada."
    log_info "➡ Ejecuta 'nexus-kali' (o 'nh') desde cualquier lugar para iniciar."
    log_warning "AVISO: El entorno Kali se ejecuta con proot y no es un sandbox de seguridad."
    if; then
        log_info "➡ Luego ejecuta 'bash $PANEL_SCRIPT_NAME' dentro de Kali para personalizar."
    fi

    # --- DEDICATORIA FINAL ---
    echo ""
    echo -e "${YELLOW}--------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}En memoria a mi perra Mimi, quien falleció en el proceso de Nexus Kali.${NC}"
    echo -e "${YELLOW}--------------------------------------------------------------------${NC}"
    echo ""
}

main
