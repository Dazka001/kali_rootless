#!/usr/bin/env bash
set -e

echo "📦 Instalando dependencias básicas..."
apt update && apt install -y xfce4 xfce4-goodies sudo dbus-x11 xterm

echo "📂 Configurando scripts personalizados..."
mkdir -p ~/.config/kali_panel

# Mover el script de panel
if [ -f ~/reset_xfce_panel.sh ]; then
    mv ~/reset_xfce_panel.sh ~/.config/kali_panel/
    chmod +x ~/.config/kali_panel/reset_xfce_panel.sh
    echo "✅ Script de panel movido a ~/.config/kali_panel/"
fi

# Crear acceso directo al escritorio XFCE
echo "🔗 Creando acceso directo en el menú..."
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/panel-xfce-kali.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Personalizar Panel XFCE
Comment=Restaurar o configurar lanzadores de hacking en XFCE
Exec=~/.config/kali_panel/reset_xfce_panel.sh
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Utility;
EOF

echo "✅ Acceso directo creado correctamente."

# Crear alias en ~/.bashrc
if ! grep -q "alias panel_kali=" ~/.bashrc; then
    echo "alias panel_kali='bash ~/.config/kali_panel/reset_xfce_panel.sh'" >> ~/.bashrc
    echo "✅ Alias agregado: panel_kali"
else
    echo "ℹ️ El alias 'panel_kali' ya existe en ~/.bashrc"
fi

# Sugerir ejecución inmediata
echo -e "\n¿Deseas ejecutar la personalización del panel ahora? (s/n): "
read -r respuesta
if [[ "$respuesta" =~ ^[sS]$ ]]; then
    bash ~/.config/kali_panel/reset_xfce_panel.sh
else
    echo "ℹ️ Puedes ejecutarlo más tarde con:"
    echo "   panel_kali"
fi
