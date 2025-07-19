#!/bin/bash
set -e

# --- Variables ---
INSTALL_DIR="kali-fs"
ROOTFS_URL="https://old.kali.org/nethunter-images/kali-2024.3/rootfs/kali-nethunter-rootfs-full-arm64.tar.xz"
FILENAME="kali-nethunter-rootfs-full-arm64.tar.xz"
START_SCRIPT_NAME="start-kali.sh"

# --- Inicio ---
echo "--- Iniciando Instalador Definitivo (Método Directo) ---"

# 1. Limpieza Automática
echo "[1/5] Limpiando instalaciones anteriores..."
rm -rf "$INSTALL_DIR"
rm -f "$FILENAME"*
echo "   -> Limpieza completa."

# 2. Dependencias
echo "[2/5] Verificando dependencias..."
pkg install wget proot tar -y
echo "   -> Dependencias listas."

# 3. Descarga
echo "[3/5] Descargando RootFS de Kali..."
wget -O "$FILENAME" "$ROOTFS_URL"
echo "   -> Descarga finalizada."

# 4. Extracción Directa (sin proot)
echo "[4/5] Extrayendo RootFS con Tar (Método Directo)..."
mkdir -p "$INSTALL_DIR"
tar -xJf "$FILENAME" -C "$INSTALL_DIR" --warning=no-unknown-keyword --ignore-failed-read || true
echo "   -> Extracción completada."

# 5. Creación del Script de Inicio
echo "[5/5] Creando script de inicio '$START_SCRIPT_NAME'..."
cat > "$START_SCRIPT_NAME" <<- EOM
#!/bin/bash
unset LD_PRELOAD
proot \\
    --link2symlink \\
    -0 \\
    -r $PWD/$INSTALL_DIR \\
    -b /dev \\
    -b /proc \\
    -b /sys \\
    -w /root \\
    /usr/bin/env -i \\
    HOME=/root \\
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \\
    TERM=\$TERM \\
    /bin/bash --login
EOM
chmod +x "$START_SCRIPT_NAME"
echo "   -> Script de inicio creado."

# --- Fin ---
echo ""
echo "🎉 ¡Instalación completada!"
echo "Para iniciar, ejecuta: ./$START_SCRIPT_NAME"
echo ""

