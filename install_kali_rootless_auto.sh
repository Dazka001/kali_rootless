#!/bin/bash
set -e

# --- Variables ---
INSTALL_DIR="kali-fs"
ROOTFS_URL="https://old.kali.org/nethunter-images/kali-2024.3/rootfs/kali-nethunter-rootfs-full-arm64.tar.xz"
FILENAME="kali-nethunter-rootfs-full-arm64.tar.xz"
START_SCRIPT_NAME="start-kali.sh"
SHA_URL="${ROOTFS_URL}.sha512sum"
POST_SCRIPT="$HOME/kali_postinstall.sh"


# --- Inicio ---
echo "--- Iniciando Instalador Robusto de Nexus Kali ---"

# 1. Limpieza Automática
echo "[1/7] Limpiando instalaciones anteriores..."
rm -rf "$INSTALL_DIR"
rm -f "$FILENAME"*
echo "   -> Limpieza completa."

# 2. Dependencias
echo "[2/7] Verificando dependencias..."
pkg install proot axel tar wget -y
echo "   -> Dependencias listas."

# 3. Descarga
echo "[3/7] Descargando RootFS de Kali (puede tardar)..."
axel -n 10 -o "$FILENAME" "$ROOTFS_URL"
echo "   -> Descarga finalizada."

# 4. Verificación de integridad
echo "[4/7] Verificando la integridad del archivo..."
wget -q "$SHA_URL"
if sha512sum -c "${FILENAME}.sha512sum"; then
    echo "   -> Verificación de SHA512 exitosa."
else
    echo "   -> ERROR: La verificación de SHA512 falló. El archivo puede estar corrupto."
    exit 1
fi


# 5. Extracción Robusta
echo "[5/7] Extrayendo RootFS (este es el paso más largo)..."
mkdir -p "$INSTALL_DIR"
proot --link2symlink tar --exclude='dev' -xJf "$FILENAME" -C "$INSTALL_DIR" || true
echo "   -> Extracción completada."

# 6. Creación del Script de Inicio
echo "[6/7] Creando script de inicio '$START_SCRIPT_NAME'..."
cat > "$INSTALL_DIR/$START_SCRIPT_NAME" <<- EOM
#!/bin/bash
unset LD_PRELOAD
# Obtener la ruta absoluta del script y luego el directorio que lo contiene
SCRIPT_PATH=\$(readlink -f "\$0")
SCRIPT_DIR=\$(dirname "\$SCRIPT_PATH")
# El RootFS es el directorio donde se encuentra este script
ROOTFS_DIR=\$SCRIPT_DIR

proot \\
    --link2symlink \\
    -0 \\
    -r \$ROOTFS_DIR \\
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
chmod +x "$INSTALL_DIR/$START_SCRIPT_NAME"
echo "   -> Script de inicio creado en $INSTALL_DIR/$START_SCRIPT_NAME."

# Descargar postinstall personalizado si no existe
if [ ! -f "$POST_SCRIPT" ]; then
  echo "⬇️  Descargando postinstalación personalizada..."
  curl -sSL https://raw.githubusercontent.com/Dazka001/kali_rootless/main/kali_postinstall.sh -o "$POST_SCRIPT"
  chmod +x "$POST_SCRIPT"
fi

# 7. Limpieza Final
echo "[7/7] Limpiando archivo de instalación..."
rm "$FILENAME"
rm "${FILENAME}.sha512sum"
echo "   -> Limpieza finalizada."

# --- Fin ---
echo ""
echo "🎉 ¡Instalación de Nexus Kali completada con éxito!"
echo "Para iniciar, ejecuta: ./$INSTALL_DIR/$START_SCRIPT_NAME"
echo "➋ Dentro de Kali ejecuta   ~/kali_postinstall.sh"
echo "➌ Luego inicia con   nethunter kex &   y conéctate desde KeX"
echo ""
