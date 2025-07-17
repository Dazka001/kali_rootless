#!/usr/bin/env bash
set -e

# ===== INFO =====
echo "🔧 Instalador automático del entorno personalizado de XFCE en Kali"
echo "📅 Fecha: $(date)"
echo "📁 Directorio base: $HOME"

# ===== VARIABLES =====
REPO_URL="https://github.com/Dazka001/kali_rootless.git"
REPO_DIR="$HOME/kali_rootless"
DESKTOP_FILE="panel-xfce-kali.desktop"
LOCAL_APPS="$HOME/.local/share/applications"
PANEL_SCRIPT="reset_xfce_panel.sh"
CUSTOMIZER="kali_customize_auto.sh"

# ===== CLONAR REPO =====
echo "📥 Clonando repositorio personalizado..."
git clone "$REPO_URL" "$REPO_DIR" || {
  echo "⚠️ Ya existe el directorio $REPO_DIR, actualizando..."
  cd "$REPO_DIR" && git pull
}

# ===== COPIAR ARCHIVOS =====
echo "📂 Copiando archivos principales al home..."
cp "$REPO_DIR/$PANEL_SCRIPT" "$HOME/"
cp "$REPO_DIR/$CUSTOMIZER" "$HOME/"
chmod +x "$HOME/$PANEL_SCRIPT" "$HOME/$CUSTOMIZER"

# ===== .DESKTOP INSTALL =====
echo "🖼️ Instalando lanzador al menú de aplicaciones..."
mkdir -p "$LOCAL_APPS"
cp "$REPO_DIR/$DESKTOP_FILE" "$LOCAL_APPS/"
chmod +x "$LOCAL_APPS/$DESKTOP_FILE"

# ===== FINAL =====
echo -e "\n✅ Instalación completa. Puedes ahora:"
echo "  ➤ Ejecutar: bash ~/kali_customize_auto.sh"
echo "  ➤ Usar desde menú: Personalizar Panel XFCE"
echo -e "\n✨ ¡Disfruta tu entorno Kali personalizado!"
