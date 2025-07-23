#!/bin/bash
set -e

# ---
# Nexus Kali: Instalador Definitivo para Termux
#            Creado por Dazka001
# ---

# --- Variables Globales y Colores ---
CHROOT_DIR="kali-fs"
START_SCRIPT_NAME="start-kali.sh"
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[1;34m'; MAGENTA='\033[1;35m'; CYAN='\033[1;36m'; NC='\033[0m'

# --- Funciones de Ayuda ---
log_info() { echo -e "${GREEN}[✔]${NC} $1"; }
log_error() { echo -e "${RED}[✘]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }

ask() {
    while true; do
        read -p "$(echo -e "${YELLOW}[?]${NC} $1 [Y/n] ")" REPLY
        case "$REPLY" in
            Y*|y*|"") return 0 ;; # Acepta 'Y', 'y', o solo Enter
            N*|n*) return 1 ;; # Acepta 'N' o 'n'
        esac
    done
}

print_banner() {
    clear
    echo -e "${BLUE} __   __  _______  __   __    __   __  ___      _______  ___ ${NC}"
    echo -e "${BLUE}|  | |  ||   _   ||  | |  |  |  | |  ||   |    |       ||   |${NC}"
    echo -e "${MAGENTA}|  |_|  ||  |_|  ||  |_|  |  |  |_|  ||   |    |    ___||   |${NC}"
    echo -e "${MAGENTA}|       ||       ||       |  |       ||   |    |   |___ |   |${NC}"
    echo -e "${CYAN}|       ||       ||    _  |  |       ||   |___ |    ___||   |___ ${NC}"
    echo -e "${CYAN}|   _   ||   _   ||   |_| |  |   _   ||       ||   |___ |       |${NC}"
    echo -e "${YELLOW}|__| |__||__| |__||__| |__|  |__| |__||_______||_______||_______|${NC}"
    echo -e "${YELLOW}                                     Creado por: Dazka001${NC}"
    echo ""
}

# --- Comienzo del Script ---
print_banner
log_info "--- Iniciando Instalador Definitivo de Nexus Kali ---"

# 1. Limpieza
log_info "[1/8] Limpiando instalaciones anteriores..."
rm -rf "$CHROOT_DIR" "kali-nethunter-rootfs"* "$START_SCRIPT_NAME"
log_info "   -> Limpieza completa."

# 2. Dependencias
log_info "[2/8] Asegurando dependencias..."
pkg update -y && pkg install proot tar wget ncurses-utils -y
log_info "   -> Dependencias listas."

# 3. Detección de Arquitectura
log_info "[3/8] Detectando arquitectura..."
case $(getprop ro.product.cpu.abi) in
    arm64-v8a) SYS_ARCH="arm64" ;;
    *) log_error "Arquitectura no soportada. Solo soporta arm64."; exit 1 ;;
esac
log_info "   -> Arquitectura detectada: $SYS_ARCH"

# 4. Selección de Tamaño de Imagen
log_info "[4/8] Selecciona el tamaño de la imagen a instalar:"
echo "   1) Full (~8GB)  2) Minimal (~2GB)  3) Nano (~600MB)"
read -p "Introduce tu elección [1]: " image_choice
case "$image_choice" in
    2) wimg="minimal" ;;
    3) wimg="nano" ;;
    *) wimg="full" ;;
esac
log_info "   -> Has seleccionado la versión: $wimg"
IMAGE_NAME="kali-nethunter-rootfs-${wimg}-${SYS_ARCH}.tar.xz"
BASE_URL="https://kali.download/nethunter-images/current/rootfs"
ROOTFS_URL="${BASE_URL}/${IMAGE_NAME}"
SHA_URL="${ROOTFS_URL}.sha512sum"

# 5. Descarga
log_info "[5/8] Descargando RootFS de Kali: $IMAGE_NAME..."
wget -q --show-progress -O "$IMAGE_NAME" "$ROOTFS_URL"

# 6. Verificación de Integridad
log_info "[6/8] Verificando la integridad del archivo..."
wget -q -O "${IMAGE_NAME}.sha512sum" "$SHA_URL"
read remote_hash remote_filename < "${IMAGE_NAME}.sha512sum"
local_hash=$(sha512sum "$IMAGE_NAME" | awk '{print $1}')
if [ "$local_hash" == "$remote_hash" ]; then
    log_info "-> Verificación de SHA512 exitosa."
else
    log_error "¡La verificación de SHA512 falló! El archivo puede estar corrupto."
    exit 1
fi

# 7. Extracción
log_info "[7/8] Extrayendo RootFS. Esto puede tardar..."
mkdir -p "$CHROOT_DIR"
proot --link2symlink tar -xJf "$IMAGE_NAME" -C "$CHROOT_DIR"
log_info "-> Extracción completada."

# 8. Creación del Lanzador, Correcciones y Personalización Opcional
log_info "[8/8] Finalizando instalación..."
ROOTFS_PATH="$PWD/$CHROOT_DIR"

# Crear el lanzador
cat > "$START_SCRIPT_NAME" <<- EOF
#!/bin/bash
unset LD_PRELOAD
exec proot \\
    --link2symlink -0 -r "$ROOTFS_PATH" \\
    -b /dev -b /proc -b /sys -w /root \\
    /usr/bin/env -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \\
    LANG=C.UTF-8 TERM=\$TERM /bin/bash --login
EOF
chmod +x "$START_SCRIPT_NAME"

# Aplicar correcciones
echo "nameserver 1.1.1.1" > "$ROOTFS_PATH/etc/resolv.conf"
if [ -f "$ROOTFS_PATH/usr/bin/sudo" ]; then chmod +s "$ROOTFS_PATH/usr/bin/sudo"; fi

# Mover script de personalización opcional
if [ -f "reset_xfce_panel.sh" ]; then
    echo ""
    echo -e "${YELLOW}Este repositorio incluye un script ('reset_xfce_panel.sh') para personalizar el escritorio de Kali.${NC}"
    echo -e "Permite agregar lanzadores para herramientas de hacking con un menú interactivo."
    if ask "   ¿Deseas incluir este script en tu instalación de Kali?"; then
        mv "reset_xfce_panel.sh" "$ROOTFS_PATH/root/"
        log_info "      -> 'reset_xfce_panel.sh' copiado. Podrás ejecutarlo dentro de Kali."
    else
        log_info "      -> Se omitió el script de personalización."
    fi
    echo ""
fi
log_info "-> Lanzador '$START_SCRIPT_NAME' creado y correcciones aplicadas."

# Limpieza Final
log_info "Limpiando archivos de instalación..."
rm "$IMAGE_NAME" "${IMAGE_NAME}.sha512sum"

# Fin
echo ""
print_banner
log_info "🎉 ¡Instalación Definitiva de Nexus Kali completada!"
log_info "Para iniciar Kali, ejecuta: ./$START_SCRIPT_NAME"
if [ -f "$ROOTFS_PATH/root/reset_xfce_panel.sh" ]; then
    log_info "Una vez dentro del escritorio, ejecuta 'bash reset_xfce_panel.sh' para personalizarlo."
fi
echo ""
