#!/bin/bash
set -e

# ---
# Nexus Kali: Instalador Definitivo para Termux
# Creado por Dazka001
# ---

# --- Variables Globales y Colores ---
BASE_URL="https://kali.download/nethunter-images/current/rootfs"
CHROOT_DIR="kali-fs"
START_SCRIPT_NAME="start-kali.sh"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Funciones de Ayuda ---
log_info() { echo -e "${GREEN}[✔]${NC} $1"; }
log_error() { echo -e "${RED}[✘]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }

# --- Comienzo del Script ---
log_info "--- Iniciando Instalador Definitivo de Nexus Kali ---"

# 1. Limpieza
log_info "[1/8] Limpiando instalaciones anteriores..."
rm -rf "$CHROOT_DIR"
rm -f "kali-nethunter-rootfs"*
rm -f "$START_SCRIPT_NAME"
log_info "   -> Limpieza completa."

# 2. Dependencias
log_info "[2/8] Asegurando dependencias (proot, tar, wget)..."
pkg update -y && pkg install proot tar wget -y
log_info "   -> Dependencias listas."

# 3. Detección de Arquitectura
log_info "[3/8] Detectando arquitectura del dispositivo..."
case $(getprop ro.product.cpu.abi) in
    arm64-v8a) SYS_ARCH="arm64" ;;
    *)
        log_error "Arquitectura no soportada. Este script solo soporta arm64."
        exit 1
        ;;
esac
log_info "   -> Arquitectura detectada: $SYS_ARCH"

# 4. Selección de Tamaño de Imagen (NUEVO)
log_info "[4/8] Selecciona el tamaño de la imagen a instalar:"
echo "   1) Full (~8GB, todas las herramientas)"
echo "   2) Minimal (~2GB, herramientas básicas)"
echo "   3) Nano (~600MB, solo el núcleo del sistema)"
read -p "Introduce el número de tu elección [1]: " image_choice

case "$image_choice" in
    2) wimg="minimal" ;;
    3) wimg="nano" ;;
    *) wimg="full" ;;
esac

log_info "   -> Has seleccionado la versión: $wimg"
IMAGE_NAME="kali-nethunter-rootfs-${wimg}-${SYS_ARCH}.tar.xz"

# 5. Descarga y Verificación
ROOTFS_URL="${BASE_URL}/${IMAGE_NAME}"
SHA_URL="${ROOTFS_URL}.sha512sum"

if [ ! -f "$IMAGE_NAME" ]; then
    log_info "[5/8] Descargando RootFS de Kali ($IMAGE_NAME)..."
    wget -q --show-progress -O "$IMAGE_NAME" "$ROOTFS_URL"
else
    log_warning "[5/8] El archivo RootFS ya existe. Saltando descarga."
fi

log_info "[6/8] Verificando la integridad del archivo..."
wget -q -O "${IMAGE_NAME}.sha512sum" "$SHA_URL"
if sha512sum -c "${IMAGE_NAME}.sha512sum"; then
    log_info "   -> Verificación de SHA512 exitosa."
else
    log_error "La verificación de SHA512 falló. El archivo puede estar corrupto."
    exit 1
fi

# 6. Extracción
log_info "[7/8] Extrayendo RootFS. Esto puede tardar varios minutos..."
mkdir -p "$CHROOT_DIR"
proot --link2symlink tar -xJf "$IMAGE_NAME" -C "$CHROOT_DIR"
log_info "   -> Extracción completada."

# 7. Creación del Lanzador y Correcciones
log_info "[8/8] Creando lanzador y aplicando correcciones..."
ROOTFS_PATH="$PWD/$CHROOT_DIR"

# Crear el lanzador
cat > "$START_SCRIPT_NAME" <<- EOF
#!/bin/bash
# Script para iniciar el entorno de Nexus Kali
unset LD_PRELOAD
exec proot \\
    --link2symlink \\
    -0 \\
    -r "$ROOTFS_PATH" \\
    -b /dev \\
    -b /proc \\
    -b /sys \\
    -b /data/data/com.termux/files/home \\
    -w /root \\
    /usr/bin/env -i \\
    HOME=/root \\
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \\
    LANG=C.UTF-8 \\
    TERM=\$TERM \\
    /bin/bash --login
EOF
chmod +x "$START_SCRIPT_NAME"

# Aplicar correcciones
log_info "   -> Configurando DNS en Kali..."
echo "nameserver 1.1.1.1" > "$ROOTFS_PATH/etc/resolv.conf"
echo "nameserver 1.0.0.1" >> "$ROOTFS_PATH/etc/resolv.conf"

log_info "   -> Arreglando permisos de sudo..."
if [ -f "$ROOTFS_PATH/usr/bin/sudo" ]; then
    chmod +s "$ROOTFS_PATH/usr/bin/sudo"
fi

log_info "   -> Lanzador '$START_SCRIPT_NAME' creado y correcciones aplicadas."

# Limpieza Final
log_info "Limpiando archivos de instalación..."
rm "$IMAGE_NAME"
rm "${IMAGE_NAME}.sha512sum"
log_info "   -> Limpieza finalizada."

# Fin
echo ""
log_info "🎉 ¡Instalación Definitiva de Nexus Kali completada!"
log_info "Para iniciar Kali, ejecuta: ./$START_SCRIPT_NAME"
echo ""
