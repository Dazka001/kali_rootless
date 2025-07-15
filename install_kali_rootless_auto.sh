#!/data/data/com.termux/files/usr/bin/bash
# ------------------------------------------------------------
# install_kali_rootless_auto.sh
# Instalación 100 % automática de Kali NetHunter Rootless FULL
# con parche 404, checksum, escritorio XFCE y KeX listo.
# ------------------------------------------------------------
set -e

# 0) Dependencias básicas
pkg update -y
pkg install -y wget curl git proot tar sed coreutils

# 1) Variables
ROOTFS_VER="kali-2024.3"
ROOTFS_FILE="kali-nethunter-rootfs-full-arm64.tar.xz"
BASE_URL="https://old.kali.org/nethunter-images/${ROOTFS_VER}/rootfs"
SCRIPT_OFFICIAL="install-nethunter-termux"
INSTALL_DIR="$HOME/.nethunter"
POST_SCRIPT="$HOME/kali_postinstall.sh"

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# 2) Descarga rootfs y checksum
echo -e "\n📦 Descargando rootfs (${ROOTFS_FILE})…"
wget -q --show-progress "${BASE_URL}/${ROOTFS_FILE}"
wget -q "${BASE_URL}/${ROOTFS_FILE}.sha512sum"

echo "🧮 Verificando checksum…"
sha512sum -c "${ROOTFS_FILE}.sha512sum"

# 3) Script oficial + parche URL
echo "⬇️  Descargando instalador oficial y aplicando parche 404…"
wget -q -O "$SCRIPT_OFFICIAL" https://offs.ec/2MceZWr
chmod +x "$SCRIPT_OFFICIAL"
sed -i 's|kali\.download/nethunter-images/current|old.kali.org/nethunter-images/kali-2024.3|' "$SCRIPT_OFFICIAL"

# 4) Instalación sin menú (pasa rootfs local)
echo "🚀 Instalando NetHunter Rootless (FULL)…"
bash "$SCRIPT_OFFICIAL" -f "$ROOTFS_FILE" -d

# 5) Asegurar que el comando nh existe
if ! command -v nh &>/dev/null; then
  echo -e '#!/data/data/com.termux/files/usr/bin/bash\nchroot $HOME/kali-arm64 /bin/bash "$@"' > $PREFIX/bin/nh
  chmod +x $PREFIX/bin/nh
  echo "✅ Comando nh creado en $PREFIX/bin/nh"
fi

# 6) Crear postinstall dentro de Kali
cat <<'EOKALI' > "$POST_SCRIPT"
#!/usr/bin/env bash
echo "🔐 Configurando contraseña KeX (por defecto: toor)…"
echo -e "toor\ntoor" | nethunter kex passwd
echo "🌐 Actualizando e instalando XFCE + VNC…"
sudo apt update -y
sudo apt install -y xfce4 dbus-x11 tigervnc-standalone-server
echo -e "\n✅ Post-instalación terminada. Ejecuta:\n   nethunter kex &\n…y conéctate desde la app KeX (localhost:5901, pass toor)."
EOKALI
chmod +x "$POST_SCRIPT"

echo -e "\n🎉  Todo listo:"
echo "➊ Escribe   nh   para entrar en Kali."
echo "➋ Dentro de Kali ejecuta   ~/kali_postinstall.sh"
echo "➌ Luego   nethunter kex &   y conecta con KeX (pass toor)."
