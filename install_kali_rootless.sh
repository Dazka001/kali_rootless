#!/data/data/com.termux/files/usr/bin/bash
#
# install_kali_rootless.sh
# Instala Kali NetHunter Rootless + XFCE + KeX (parche 404 incluido)

set -e

### 0. REQUISITOS BÁSICOS
pkg update -y
pkg install -y wget curl git proot tar sed

### 1. DESCARGAR SCRIPT OFICIAL Y PARCHEAR URL 404
SCRIPT=install-nethunter-termux
wget -q -O $SCRIPT https://offs.ec/2MceZWr
chmod +x $SCRIPT
# Reemplazamos 'current' por la carpeta estable 2024.3 del mirror antiguo
sed -i 's|kali\.download/nethunter-images/current|old.kali.org/nethunter-images/kali-2024.3|' $SCRIPT

### 2. EJECUTAR INSTALADOR CON ROOTFS LOCAL AUTOMÁTICO
bash $SCRIPT <<EOF
1
EOF
# (El '1' elige la opción Full en el menú interactivo)

### 3. ENTRAR A KALI Y CONFIGURAR KEX
cat <<'EOKALI' > ~/kali_postinstall.sh
#!/usr/bin/env bash
# dentro de Kali
nethunter kex passwd <<END
toor
toor
END
sudo apt update && sudo apt install -y xfce4 dbus-x11 tigervnc-standalone-server
echo -e "\n❗ Todo listo. Ejecuta: nethunter kex &  y conecta con KeX (localhost:5901, pass 'toor').\n"
EOKALI
chmod +x ~/kali_postinstall.sh

echo -e "\n✅ Instalación de base terminada."
echo "➡️  Ingresa con: nh  (y luego ejecuta ~/kali_postinstall.sh dentro de Kali)."