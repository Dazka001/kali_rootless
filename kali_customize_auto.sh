#!/usr/bin/env bash
set -e
echo "🔧 Personalizando entorno Kali…"

#######################
# 1. Alias & shell tweaks
#######################
echo "✅ Configurando alias y bashrc…"
cat <<'EOF' >> ~/.bashrc

# ==== Alias útiles ====
alias cls='clear'
alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias resetpanel='~/reset_xfce_panel.sh'
alias postkali='~/kali_postinstall.sh'
alias kexstart='nethunter kex &'
EOF
echo "neofetch" >> ~/.bashrc

#######################
# 2. Herramientas básicas
#######################
echo "📦 Instalando utilidades esenciales…"
sudo apt update
sudo apt install -y \
  neofetch htop micro curl net-tools unzip tree git traceroute dnsutils \
  x11-utils xfce4-goodies fonts-firacode

#######################
# 3. Paquete ofensivo de pentesting
#######################
echo "🎯 Instalando herramientas de hacking… esto tomará un rato."
sudo apt install -y \
  nmap wpscan sqlmap metasploit-framework john hashcat hydra \
  nikto gobuster dirb dirbuster feroxbuster \
  aircrack-ng bettercap bully reaver pixiewps \
  wireshark tshark tcpdump mitmproxy \
  setoolkit beef-xss responder impacket-scripts

#######################
# 4. Hardening / utilidades de seguridad defensiva
#######################
echo "🛡️  Instalando utilidades de hardening…"
sudo apt install -y ufw fail2ban lynis rkhunter clamav

# Activar UFW con política básica
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

#######################
# 5. Pequeños ajustes en XFCE
#######################
XFCE_BG="/usr/share/backgrounds/xfce/xfce-blue.jpg"
if [ -f "$XFCE_BG" ]; then
  echo "🎨 Estableciendo fondo de pantalla XFCE…"
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$XFCE_BG" || true
fi

#######################
# 6. Limpieza
#######################
echo "🧹 Limpiando sistema…"
sudo apt autoremove -y
sudo apt clean

#######################
# 7. Personalizar panel automáticamente
#######################
if [ -f ~/reset_xfce_panel.sh ]; then
  echo "✨ Ejecutando script de personalización del panel XFCE…"
  bash ~/reset_xfce_panel.sh <<< "2
6
9"
else
  echo "ℹ️  No se encontró ~/reset_xfce_panel.sh, omitiendo personalización del panel."
fi

echo -e "\n✅ Personalización COMPLETA. Reinicia la terminal o ejecuta: source ~/.bashrc"
