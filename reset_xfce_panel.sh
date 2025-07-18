#!/bin/bash
set -e

# --- CONFIGURACIÓN ---
# Define las aplicaciones y sus archivos .desktop correspondientes
declare -A APPS=(
  ["Terminal"]="org.xfce.terminal.desktop"
  ["Firefox"]="firefox-esr.desktop"
  ["Thunar"]="thunar.desktop"
  ["Nmap"]="zenmap.desktop" # Nmap usa Zenmap para su lanzador gráfico
  ["Metasploit"]="metasploit-framework.desktop"
  ["Wireshark"]="wireshark.desktop"
  ["BurpSuite"]="burpsuite.desktop"
  ["Maltego"]="maltego.desktop"
  ["Hydra"]="hydra-gtk.desktop"
)
DESKTOP_DIRS=("/usr/share/applications" "$HOME/.local/share/applications")

# --- FUNCIONES ---

# Busca el archivo .desktop en las rutas estándar
find_desktop_file() {
  for dir in "${DESKTOP_DIRS[@]}"; do
    if [[ -f "$dir/$1" ]]; then
      echo "$dir/$1"
      return 0
    fi
  done
  return 1
}

# Añade un lanzador al panel usando el método oficial
add_launcher() {
  local desktop_file_path="$1"
  local panel_id=1 # Asumimos el panel principal

  # Crea un nuevo plugin de tipo 'launcher'
  local new_plugin_id=$(xfconf-query -c xfce4-panel -p /plugins -t string -s launcher -n | awk -F- '{print $NF}')

  # Asigna el archivo .desktop al nuevo plugin
  xfconf-query -c xfce4-panel -p "/plugins/plugin-$new_plugin_id/desktop-files" -t string -s "$desktop_file_path" -a

  # Añade el ID del nuevo plugin a la lista de plugins del panel
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
rm -rf ~/.config/xfce4/panel
rm -rf ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sleep 1
xfce4-panel --restart &
sleep 2

# Detectar herramientas disponibles
detected_tools=()
for name in "${!APPS[@]}"; do
  if find_desktop_file "${APPS[$name]}" >/dev/null; then
    detected_tools+=("$name")
  fi
done

if [ ${#detected_tools[@]} -eq 0 ]; then
  echo "No se detectaron herramientas para agregar."
  exit 0
fi

# MEJORA: Usar 'select' para un menú interactivo y robusto
echo -e "\n--- Elige los lanzadores que deseas agregar al panel ---"
PS3="Introduce un número (o presiona Enter para finalizar): "
select tool_name in "${detected_tools[@]}"; do
  if [[ -n "$tool_name" ]]; then
    desktop_file=$(find_desktop_file "${APPS[$tool_name]}")
    add_launcher "$desktop_file"
  else
    # Si la entrada es vacía (Enter), se sale del bucle
    break
  fi
done

echo -e "\n🎉 Proceso de personalización finalizado."
