#!/data/data/com.termux/files/usr/bin/bash
# ------------------------------------------------------------
# install_kali_rootless_auto_extendido.sh
# Instalación robusta y 100% automatizada de Kali NetHunter Rootless
# con verificación manual, sin menús, y con entorno XFCE + KeX
# ------------------------------------------------------------

set -e

echo "🔧 Preparando entorno para instalación..."

# Dependencias básicas
pkg update -y
pkg install -y wget curl git proot tar sed coreutils axel

# Variables
ROOTFS_VER="kali-2024.3"
ROOTFS_FILE="kali-nethunter-rootfs-full-arm64.tar.xz"
ROOTFS_URL="https://old.kali.org/nethunter-images/${ROOTFS_VER}/rootfs/${ROOTFS_FILE}"
SHA_URL="${ROOTFS_URL}.sha512sum"
INSTALL_DIR="$HOME/kali-arm64"
NH_BIN="$PREFIX/bin/nh"
POST_SCRIPT="$HOME/kali_postinstall.sh"

# Descargar RootFS y verificar integridad
echo "📥 Descargando rootfs..."
axel -n 8 -o "$ROOTFS_FILE" "$ROOTFS_URL"
wget -q "$SHA_URL"
echo "🔐 Verificando SHA512..."
sha512sum -c "${ROOTFS_FILE}.sha512sum"

# Extraer rootfs
echo "📦 Extrayendo rootfs en $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
proot --link2symlink tar -xJf "$ROOTFS_FILE" -C "$INSTALL_DIR"

# Crear script de entrada: nh
echo "🚀 Configurando comando nh..."
cat > "$NH_BIN" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
command="proot --link2symlink -0 -r \$HOME/kali-arm64 -b /dev -b /proc -b /sys -b \$HOME:/root -w /root /bin/bash"
exec \$command "\$@"
EOF

chmod +x "$NH_BIN"

# Descargar postinstall personalizado si no existe
if [ ! -f "$POST_SCRIPT" ]; then
  echo "⬇️  Descargando postinstalación personalizada..."
  curl -sSL https://raw.githubusercontent.com/Dazka001/kali_rootless/main/kali_postinstall.sh -o "$POST_SCRIPT"
  chmod +x "$POST_SCRIPT"
fi

# Alias en ~/.bashrc si no existe
if ! grep -q "alias nh=" "$HOME/.bashrc"; then
  echo "📌 Agregando alias al ~/.bashrc"
  echo "alias nh='$NH_BIN'" >> "$HOME/.bashrc"
fi

# Final
echo -e "\n✅ Instalación COMPLETA de Kali Rootless"
echo "➊ Ejecuta   nh   para ingresar a Kali"
echo "➋ Dentro de Kali ejecuta   ~/kali_postinstall.sh"
echo "➌ Luego inicia con   nethunter kex &   y conéctate desde KeX"
