#!/bin-bash
set -e

# --- CONFIGURACIÓN ---
declare -A APPS=(
  ["Terminal"]="org.xfce.terminal.desktop"
  ["Firefox"]="firefox-esr.desktop"
  ["Thunar"]="thunar.desktop"
  ["Aircrack-ng"]="aircrack-ng.desktop"
  ["Burp Suite"]="burpsuite.desktop"
  ["Cutter"]="cutter.desktop"
  ["Ettercap"]="ettercap-graphical.desktop"
  ["Ghidra"]="ghidra.desktop"
  ["Hydra GTK"]="hydra-gtk.desktop"
  ["John the Ripper"]="john.desktop"
  ["Maltego"]="maltego.desktop"
  ["Metasploit"]="metasploit-framework.desktop"
  ["Nmap (Zenmap)"]="zenmap.desktop"
  ["OWASP ZAP"]="zaproxy.desktop"
  ["Radare2"]="radare2.desktop"
  ["Recon-ng"]="recon-ng.desktop"
  ["sqlmap"]="sqlmap.desktop"
  ["Wireshark"]="wireshark.desktop"
  ["SpiderFoot"]="spiderfoot.desktop"
  ["Autopsy"]="autopsy.desktop"
  ["Hashcat"]="hashcat.desktop"
)
DESKTOP_DIRS=("/usr/share/applications" "$HOME/.local/share/applications")

# --- FUNCIONES ---
crear_lanzador_ia() {
    local desktop_file_path="/root/Desktop/Asistente-IA.desktop"
    local icon_dir="/root/.local/share/icons/nexus_kali"
    local icon_name="nexus_ai_logo.png"
    local icon_path="${icon_dir}/${icon_name}"
    local icon_url="https://raw.githubusercontent.com/Dazka001/kali_rootless/main/assets/logo_deepsite.svg"

    echo "Creando lanzador para el Asistente de IA en el escritorio..."
    mkdir -p "$icon_dir"
    echo "-> Descargando icono personalizado..."
    wget -q -O "$icon_path" "$icon_url"

    cat > "$desktop_file_path" <<- EOM
[Desktop Entry]
Version=1.0
Type=Application
Name=Asistente de IA
Comment=Accede a herramientas de IA en la web
Exec=firefox https://huggingface.co/spaces/enzostvs/deepsite
Icon=${icon_path}
Terminal=false
Categories=Network;WebBrowser;
EOM

    chmod +x "$desktop_file_path"
    echo "✔ ¡Lanzador 'Asistente de IA' creado con tu icono personalizado!"
}

find_desktop_file() {
  for dir in "${DESKTOP_DIRS[@]}"; do
    if [[ -f "$dir/$1" ]]; then
      echo "$dir/$1"
      return 0
    fi
  done
  return 1
}

add_launcher() {
  local desktop_file_path="$1"
  local panel_id=1
  local new_plugin_id=$(xfconf-query -c xfce4-panel -p /plugins -t string -s launcher -n | awk -F- '{print $NF}')
  xfconf-query -c xfce4-panel -p "/plugins/plugin-$new_plugin_id/desktop-files" -t string -s "$desktop_file_path" -a
  local plugin_ids=$(xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" | tail -n +3)
  xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -r
  for id in $plugin_ids; do
    xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -t int -s "$id" -a
  done
  xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -t int -s "$new_plugin_id" -a
  echo "✔ Lanzador agregado: $(basename "$desktop_file_path")"
}

# --- EJECUCIÓN PRINCIPAL ---
echo "Restaurando el panel de XFCE a su configuración por defecto..."
xfce4-panel --quit || true
rm -rf ~/.config/xfce4/panel ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sleep 1
xfce4-panel --restart &
sleep 2

# 1. Detectar herramientas disponibles
detected_tools=()
for name in "${!APPS[@]}"; do
  if find_desktop_file "${APPS[$name]}" >/dev/null; then
    detected_tools+=("$name")
  fi
done

# 2. Añadir opciones estáticas a la lista
detected_tools+=("---") # Separador visual
detected_tools+=("✨ Asistente de IA (Escritorio)")
detected_tools+=("Salir")

# 3. Mostrar el menú completo
echo -e "\n--- Elige los lanzadores que deseas agregar ---"
PS3="Introduce un número: "

select tool_name in "${detected_tools[@]}"; do
  case "$tool_name" in
    "✨ Asistente de IA (Escritorio)")
      crear_lanzador_ia
      ;;
    "Salir")
      break
      ;;
    "---")
      # No hacer nada
      ;;
    *)
      if [[ -n "$tool_name" ]]; then
        desktop_file=$(find_desktop_file "${APPS[$tool_name]}")
        add_launcher "$desktop_file"
      else
        echo "Opción no válida."
      fi
      ;;
  esac
done

echo -e "\n🎉 Proceso de personalización finalizado."
