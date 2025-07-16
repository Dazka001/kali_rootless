#!/usr/bin/env bash
set -e

# ===== VARIABLES =====
BK_DIR="$HOME/.config/xfce4/backup_$(date +%Y%m%d_%H%M%S)"
PANEL_CONF="$HOME/.config/xfce4/panel"
DESKTOP_DIR="/usr/share/applications"
LOCAL_DESKTOP_DIR="$HOME/.local/share/applications"
LAST_BACKUP_FILE="$HOME/.config/xfce4/last_panel_backup_path.txt"

# ===== VALIDACIÓN INICIAL =====
command -v xfconf-query >/dev/null 2>&1 || {
    echo "❌ xfconf-query no está instalado. No se puede continuar."
    exit 1
}

# ===== LANZADORES DE HACKING/OSINT =====
declare -A hacking_launchers=(
    ["Aircrack-ng"]="aircrack-ng.desktop"
    ["APTSim"]="aptsim.desktop"
    ["Armory-ng"]="armory-ng.desktop"
    ["BLE HackKit"]="ble_hackkit.desktop"
    ["Burp Suite"]="burpsuite.desktop"
    ["Car Hack Tools"]="car-hack-tools.desktop"
    ["Cutter"]="cutter.desktop"
    ["Ghidra"]="ghidra.desktop"
    ["John the Ripper"]="john.desktop"
    ["KeepNote"]="keepnote.desktop"
    ["Maltego"]="maltego.desktop"
    ["Metasploit"]="metasploit.desktop"
    ["OpenVAS"]="openvas.desktop"
    ["SEToolkit"]="setoolkit.desktop"
    ["sqlmap"]="sqlmap.desktop"
    ["Wireshark"]="wireshark.desktop"
    ["Zenmap"]="zenmap.desktop"
)

# ===== FUNCIONES =====

find_desktop_file() {
    local file="$1"
    for path in "$DESKTOP_DIR" "$LOCAL_DESKTOP_DIR"; do
        if [ -f "$path/$file" ]; then
            echo "$path/$file"
            return 0
        fi
    done
    return 1
}

backup_panel() {
    if [ -d "$PANEL_CONF" ]; then
        mkdir -p "$BK_DIR"
        cp -r "$PANEL_CONF" "$BK_DIR"
        echo "$BK_DIR" > "$LAST_BACKUP_FILE"
        echo "📦  Backup hecho en $BK_DIR"
    else
        echo "ℹ️  No existe configuración previa de panel, omitido backup."
    fi
}

restore_panel() {
    xfce4-panel --quit || true
    sleep 1
    backup_panel
    rm -rf "$PANEL_CONF"
    xfce4-panel --restart &
    sleep 2
    echo "✅ Panel restaurado a configuración por defecto."
}

restore_backup() {
    local dir
    if [ -f "$LAST_BACKUP_FILE" ]; then
        echo "Último backup registrado:"
        cat "$LAST_BACKUP_FILE"
        echo -n "¿Usar ese backup? (s/n): "
        read -r respuesta
        if [[ "$respuesta" == "s" ]]; then
            dir=$(cat "$LAST_BACKUP_FILE")
        fi
    fi
    if [ -z "$dir" ]; then
        echo "Introduce la ruta del backup a restaurar:"
        read -r dir
    fi
    if [ -d "$dir" ]; then
        rm -rf "$PANEL_CONF"
        cp -r "$dir" "$PANEL_CONF"
        xfce4-panel --restart &
        echo "🔄 Panel restaurado desde $dir"
    else
        echo "❌  Backup no encontrado."
    fi
}

get_panel_id() {
    local pid
    pid=$(xfconf-query -c xfce4-panel -p /panels -lv | grep 'position.*top' | awk -F'[-/]' '{print $3}' | head -n1)
    [ -z "$pid" ] && pid=1
    echo "$pid"
}

add_launcher() {
    local desktop_file="$1"
    local panel_id plugin_id
    panel_id=$(get_panel_id)
    [ ! -f "$desktop_file" ] && echo "❌  Lanzador no encontrado: $desktop_file" && return
    plugin_id=$(xfconf-query -c xfce4-panel -p /plugins -t string -s launcher -a | tail -n1 | awk -F'-' '{print $3}')
    xfconf-query -c xfce4-panel -p "/plugins/plugin-$plugin_id" -t string -s "$desktop_file"
    xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -s "$plugin_id" -t int -a
    echo "➕  Lanzador agregado: $desktop_file"
}

add_plugin() {
    local plugin="$1"
    local panel_id
    panel_id=$(get_panel_id)
    xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -t int -s "$plugin" -a
}

add_basic_launchers() {
    add_launcher "$(find_desktop_file org.xfce.terminal.desktop)"
    add_launcher "$(find_desktop_file firefox-esr.desktop)"
    add_launcher "$(find_desktop_file thunar.desktop)"
}

add_all_hacking_launchers() {
    echo "Agregando todos los lanzadores hacking/OSINT detectados..."
    for name in "${!hacking_launchers[@]}"; do
        local path
        path=$(find_desktop_file "${hacking_launchers[$name]}")
        [ -n "$path" ] && add_launcher "$path"
    done
}

detect_hacking_launchers() {
    echo -e "\nLanzadores hacking/OSINT detectados:"
    local idx=1
    for name in "${!hacking_launchers[@]}"; do
        local path
        path=$(find_desktop_file "${hacking_launchers[$name]}")
        if [ -n "$path" ]; then
            echo "  $idx. $name"
            ((idx++))
        fi
    done
    echo ""
}

submenu_hacking_launchers() {
    local -a detected_names detected_files
    local idx=1
    IFS=$'\n' sorted_keys=($(printf "%s\n" "${!hacking_launchers[@]}" | sort))
    unset IFS
    for name in "${sorted_keys[@]}"; do
        local path
        path=$(find_desktop_file "${hacking_launchers[$name]}")
        if [ -n "$path" ]; then
            detected_names+=("$name")
            detected_files+=("$path")
        fi
    done
    if [ ${#detected_names[@]} -eq 0 ]; then
        echo "No hay lanzadores hacking/OSINT detectados."
        return 1
    fi
    echo "Selecciona los lanzadores que quieres agregar al panel:"
    for i in "${!detected_names[@]}"; do
        echo "  $((i+1)). ${detected_names[$i]}"
    done
    echo "  0. Salir"
    echo "Introduce los números separados por espacio (ej: 1 3 5) o 0 para salir:"
    read -ra seleccion
    for i in "${seleccion[@]}"; do
        if [[ "$i" == "0" ]]; then
            return 0
        elif [[ "$i" =~ ^[0-9]+$ ]] && [ "$i" -ge 1 ] && [ "$i" -le "${#detected_files[@]}" ]; then
            add_launcher "${detected_files[$((i-1))]}"
        fi
    done
}

panel_customize() {
    local panel_id
    panel_id=$(get_panel_id)
    xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/size" -s 28
    echo "🎨 Panel personalizado: tamaño 28"
}

add_extra_plugins() {
    add_plugin 6   # reloj
    add_plugin 8   # bandeja del sistema
    add_plugin 2   # separador
}

export_launchers_list() {
    echo "Exportando lista de lanzadores de hacking/OSINT detectados a ~/hack_osint_launchers.txt..."
    printf "## Lanzadores detectados:\n" > ~/hack_osint_launchers.txt
    for name in "${!hacking_launchers[@]}"; do
        local path
        path=$(find_desktop_file "${hacking_launchers[$name]}")
        if [ -n "$path" ]; then
            printf "%s\t%s\n" "$name" "$path" >> ~/hack_osint_launchers.txt
        fi
    done
    echo "Archivo generado: ~/hack_osint_launchers.txt"
}

# ===== MENÚ PRINCIPAL =====
while true; do
    echo ""
    echo "========= Menú XFCE Panel Kali (Restauración, hacking, OSINT) ========="
    echo "1. Restaurar panel por defecto"
    echo "2. Agregar lanzadores básicos (Terminal, Firefox, Thunar)"
    echo "3. Detectar y mostrar lanzadores hacking/OSINT instalados"
    echo "4. Submenú para elegir lanzadores hacking/OSINT y agregarlos"
    echo "5. Restaurar backup anterior"
    echo "6. Personalizar panel (tamaño, plugins extra)"
    echo "7. Exportar lista de lanzadores hacking/OSINT detectados a archivo"
    echo "8. Agregar todos los lanzadores hacking/OSINT (modo experto)"
    echo "9. Salir"
    echo "======================================================================="
    echo -n "Elige una opción [1-9]: "
    read -r opcion

    case $opcion in
        1) restore_panel ;;
        2) add_basic_launchers ;;
        3) detect_hacking_launchers ;;
        4) submenu_hacking_launchers ;;
        5) restore_backup ;;
        6) panel_customize; add_extra_plugins ;;
        7) export_launchers_list ;;
        8) add_all_hacking_launchers ;;
        9) echo "👋 Saliendo..."; break ;;
        *) echo "Opción no válida." ;;
    esac
done
