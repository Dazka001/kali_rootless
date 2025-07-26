#!/bin/bash

# ---
# Nexus Kali: Suite de Entorno de Escritorio vFinal
# Creado por Dazka001.
# Este script proporciona una interfaz gráfica para personalizar el entorno de escritorio XFCE en Kali.
# ---

# --- Variables Globales y Colores ---
PANEL_TITLE="Nexus Kali - Suite de Personalización"
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
DESKTOP_DIRS=("/usr/share/applications" "$HOME/.local/share/applications")
declare -A APPS=(
  ["Terminal"]="org.xfce.terminal.desktop" ["Firefox"]="firefox-esr.desktop" ["Thunar"]="thunar.desktop"
  ["Aircrack-ng"]="aircrack-ng.desktop" ["Burp Suite"]="burpsuite.desktop" ["Cutter"]="cutter.desktop"
  ["Ettercap"]="ettercap-graphical.desktop" ["Ghidra"]="ghidra.desktop" ["Hydra GTK"]="hydra-gtk.desktop"
  ["John the Ripper"]="john.desktop" ["Maltego"]="maltego.desktop" ["Metasploit"]="metasploit-framework.desktop"
  ["Nmap (Zenmap)"]="zenmap.desktop" ["OWASP ZAP"]="zaproxy.desktop" ["Radare2"]="radare2.desktop"
  ["Recon-ng"]="recon-ng.desktop" ["sqlmap"]="sqlmap.desktop" ["Wireshark"]="wireshark.desktop"
  ["SpiderFoot"]="spiderfoot.desktop" ["Autopsy"]="autopsy.desktop" ["Hashcat"]="hashcat.desktop"
)

# --- FUNCIONES DE LA SUITE ---

check_deps() {
    for cmd in zenity notify-send xfce4-panel xfconf-query wget sudo apt git curl zsh tor proxychains-ng lm-sensors xbindkeys; do
        if ! command -v "$cmd" >/dev/null; then
            zenity --error --text="Dependencia faltante para una o más funciones: '$cmd' no está instalado."
            return 1
        fi
    done
    return 0
}

backup_panel() {
    if zenity --question --title="Copia de Seguridad" --text="¿Deseas hacer una copia de seguridad de la configuración actual de tu panel?"; then
        backup_dir=$(zenity --file-selection --directory --title="Selecciona un directorio para la copia")
        if [ -n "$backup_dir" ]; then
            timestamp=$(date +%Y%m%d_%H%M%S)
            cp -r ~/.config/xfce4/panel "$backup_dir/xfce4_panel_backup_$timestamp"
            notify-send "$PANEL_TITLE" "Copia de seguridad guardada."
        fi
    fi
}

find_desktop_file() {
    for dir in "${DESKTOP_DIRS[@]}"; do
        if [[ -f "$dir/$1" ]]; then echo "$dir/$1"; return 0; fi
    done
    return 1
}

add_launcher() {
    local desktop_file_path="$1"
    [[ -z "$desktop_file_path" ]] && return
    local panel_id=1
    local plugin_id
    plugin_id=$(xfconf-query -c xfce4-panel -p /plugins -t string -s launcher -n | awk -F- '{print $NF}')
    xfconf-query -c xfce4-panel -p "/plugins/plugin-$plugin_id/desktop-files" -t string -s "$desktop_file_path" -a
    xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -t int -s "$plugin_id" -a
}

personalizar_lanzadores() {
    if ! zenity --question --title="Confirmación" --text="Esta acción restaurará tu panel a la configuración por defecto antes de añadir los nuevos lanzadores.\n\n¿Deseas continuar?"; then
        return
    fi
    backup_panel
    notify-send "$PANEL_TITLE" "Restaurando panel..."
    xfce4-panel --quit || true
    rm -rf ~/.config/xfce4/panel ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
    sleep 1; xfce4-panel --restart & sleep 2
    zenity_options=()
    for name in "${!APPS[@]}"; do
        if find_desktop_file "${APPS[$name]}" > /dev/null; then zenity_options+=(FALSE "$name"); fi
    done
    selected=$(zenity --list --checklist --title="Personalizar Lanzadores" --text="Selecciona los lanzadores a agregar al panel:" --column="Añadir" --column="Herramienta/Acción" "${zenity_options[@]}" --width=500 --height=600)
    [[ -z "$selected" ]] && return
    while read -d'|' choice; do
        if [[ "$choice" != "" ]]; then add_launcher "$(find_desktop_file "${APPS[$choice]}")"; fi
    done <<< "$selected|"
    xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -t int -s 6 -a # Reloj
    xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -t int -s 8 -a # Bandeja del sistema
    zenity --info --title="Finalizado" --text="Lanzadores del panel actualizados."
}

estilizar_escritorio() {
    notify-send "$PANEL_TITLE" "Instalando temas, iconos y plugins..."
    sudo apt update -y && sudo apt install -y arc-theme papirus-icon-theme xfce4-goodies
    notify-send "$PANEL_TITLE" "Aplicando tema 'Arc-Dark' e iconos 'Papirus-Dark'..."
    xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"; xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
    notify-send "$PANEL_TITLE" "Aplicando estilo CSS personalizado..."
    mkdir -p "$HOME/.config/gtk-3.0"
    cat > "$HOME/.config/gtk-3.0/gtk.css" << EOF
.xfce4-panel { background-color: rgba(30,30,30,0.85); border-radius: 12px; padding: 2px; font-weight: bold; }
EOF
    xfce4-panel --restart; zenity --info --title="Finalizado" --text="¡Temas y estilos aplicados!"
}

instalar_terminal_definitiva() {
    notify-send "$PANEL_TITLE" "Instalando Zsh y Oh My Zsh..."
    sudo apt update -y && sudo apt install -y zsh git curl
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    notify-send "$PANEL_TITLE" "Instalando plugins para Zsh..."
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
    sudo chsh -s "$(which zsh)" "$USER"
    zenity --info --title="Finalizado" --text="¡Terminal Definitiva instalada!\n\nPara ver los cambios, cierra sesión en Kali y vuelve a entrar."
}

configurar_anonimato() {
    notify-send "$PANEL_TITLE" "Instalando Tor y Proxychains..."
    sudo apt update -y && sudo apt install -y tor proxychains-ng
    notify-send "$PANEL_TITLE" "Configurando Proxychains para usar Tor..."
    sudo sed -i 's/^socks4/#socks4/' /etc/proxychains4.conf
    sudo sed -i '/#socks5.*9050/s/^#//' /etc/proxychains4.conf
    echo -e '\n# Alias para Proxychains con Tor\nalias p-nmap="proxychains4 nmap"\nalias p-curl="proxychains4 curl"' >> "$HOME/.bashrc"
    if [ -f "$HOME/.zshrc" ]; then
        echo -e '\n# Alias para Proxychains con Tor\nalias p-nmap="proxychains4 nmap"\nalias p-curl="proxychains4 curl"' >> "$HOME/.zshrc"
    fi
    zenity --info --title="Finalizado" --text="¡Configuración de Anonimato completada!\n\nAntes de usar los alias (ej. 'p-nmap'), inicia el servicio de Tor con:\nsudo service tor start"
}

add_genmon_widget(){
  local panel_id=1
  local cmd="$1"
  local widget_id
  widget_id=$(xfconf-query -c xfce4-panel -p /plugins -t string -n -a -s genmon | awk -F- '{print $NF}')
  xfconf-query -c xfce4-panel -p "/plugins/plugin-$widget_id/command" -s "$cmd"
  xfconf-query -c xfce4-panel -p "/plugins/plugin-$widget_id/use-markup" -s true
  xfconf-query -c xfce4-panel -p "/plugins/plugin-$widget_id/update-period" -s 5000
  xfconf-query -c xfce4-panel -p "/panels/panel-$panel_id/plugin-ids" -t int -a -s "$widget_id"
}

añadir_widgets_sistema() {
    notify-send "$PANEL_TITLE" "Instalando plugins de monitorización..."
    sudo apt update -y && sudo apt install -y lm-sensors xfce4-sensors-plugin xfce4-genmon-plugin xfce4-netload-plugin
    sudo sensors-detect --auto || true
    notify-send "$PANEL_TITLE" "Añadiendo widgets al panel..."
    add_genmon_widget "sensors | awk '/^Core 0/ {print \"🌡️ \" \$3}'"
    add_genmon_widget "uptime | awk -F'load average: ' '{print \"💻 \" \$2}'"
    add_genmon_widget "free -h | awk '/^Mem:/ {print \"🧠 \" \$3 \"/\" \$2}'"
    add_genmon_widget "TZ='America/Mexico_City' date '+🇲🇽 %H:%M'"
    xfce4-panel --restart
    zenity --info --title="Finalizado" --text="Widgets de sistema (Temp, CPU, RAM, Hora) añadidos al panel."
}

toggle_theme_script(){
  cat > "$HOME/toggle_theme.sh" <<'EOM'
#!/bin/bash
current_theme=$(xfconf-query -c xsettings -p /Net/ThemeName)
if [[ "$current_theme" == *"-Dark" ]]; then
  new_theme="${current_theme%-Dark}"
else
  new_theme="${current_theme}-Dark"
fi
xfconf-query -c xsettings -p /Net/ThemeName -s "$new_theme"
EOM
  chmod +x "$HOME/toggle_theme.sh"
}

crear_accesos_directos() {
    notify-send "$PANEL_TITLE" "Creando accesos directos..."
    toggle_theme_script
    mkdir -p "$HOME/Desktop"
    cat > "$HOME/Desktop/apagar.desktop" <<EOM
[Desktop Entry]
Type=Application
Name=Apagar Sistema
Exec=xfce4-session-logout --halt
Icon=system-shutdown
Terminal=false
EOM
    cat > "$HOME/Desktop/modo-oscuro.desktop" <<EOM
[Desktop Entry]
Type=Application
Name=Cambiar Tema (Claro/Oscuro)
Exec=$HOME/toggle_theme.sh
Icon=preferences-desktop-theme
Terminal=false
EOM
    cat > "$HOME/Desktop/chatgpt.desktop" <<EOM
[Desktop Entry]
Type=Application
Name=ChatGPT Web
Exec=firefox https://chat.openai.com
Icon=web-browser
Terminal=false
EOM
    chmod +x "$HOME/Desktop"/*.desktop
    zenity --info --title="Finalizado" --text="Se crearon accesos directos en tu escritorio."
}

configurar_atajos_teclado() {
    notify-send "$PANEL_TITLE" "Configurando atajos de teclado..."
    sudo apt update -y && sudo apt install -y xbindkeys
    if [ ! -f "$HOME/toggle_theme.sh" ]; then toggle_theme_script; fi
    cat > "$HOME/.xbindkeysrc" << EOF
"xfce4-session-logout --halt"
  Control+Alt+Delete
"bash $HOME/toggle_theme.sh"
  Control+Alt+T
EOF
    killall xbindkeys 2>/dev/null
    xbindkeys
    zenity --info --title="Finalizado" --text="Atajos configurados:\n\n• Ctrl+Alt+Supr → Apagar\n• Ctrl+Alt+T → Cambiar Tema"
}

diagnosticar_y_reparar() {
    notify-send "$PANEL_TITLE" "Iniciando diagnóstico..."
    (
        echo "25"; echo "# Verificando permisos de hddtemp..."
        if [ -e /usr/sbin/hddtemp ]; then sudo chmod u+s /usr/sbin/hddtemp; fi
        sleep 1
        echo "50"; echo "# Refrescando todos los widgets GenMon..."
        panel_items=$(xfconf-query -c xfce4-panel -p /plugins | grep genmon | awk -F- '{print $NF}')
        for widget_id in $panel_items; do
            xfce4-panel --plugin-event="genmon-$widget_id":refresh:bool:true
        done
        sleep 1
        echo "100"; echo "# ¡Diagnóstico completado!"
    ) | zenity --progress --title="Diagnóstico" --auto-close --width=400
    zenity --info --title="Finalizado" --text="Se aplicaron las correcciones y se refrescaron los widgets."
}

realizar_mantenimiento() {
    (
        echo "10"; echo "# Actualizando lista de paquetes..."
        sudo apt update -y
        echo "50"; echo "# Actualizando todos los paquetes instalados..."
        sudo apt full-upgrade -y
        echo "90"; echo "# Limpiando paquetes innecesarios..."
        sudo apt autoremove --purge -y
        echo "100"; echo "# ¡Mantenimiento completado!"
    ) | zenity --progress --title="Mantenimiento del Sistema" --text="Iniciando..." --auto-close --width=400
    zenity --info --title="Finalizado" --text="El sistema ha sido actualizado y limpiado."
}

# --- EJECUCIÓN PRINCIPAL ---
main() {
    check_deps || exit 1
    
    opciones=(
        "Personalizar Lanzadores" "Añade/quita lanzadores de Hacking."
        "Aplicar Estilo Visual" "Instala temas, iconos y transparencia."
        "✨ Instalar Terminal Definitiva (Zsh)" "Mejora tu terminal con autocompletado."
        "🔒 Configurar Anonimato (Tor)" "Permite enrutar herramientas por la red Tor."
        "📊 Añadir Widgets de Sistema" "Añade monitores de Temp, CPU y RAM."
        "🔧 Realizar Mantenimiento" "Actualiza y limpia todos los paquetes."
        "💡 Crear Accesos Directos Útiles" "Crea atajos para Apagar, ChatGPT y más."
        "⌨️ Configurar Atajos de Teclado" "Usa Ctrl+Alt+Supr para apagar, etc."
        "🩺 Diagnosticar y Reparar Panel" "Soluciona problemas comunes de los plugins."
    )

    choice=$(zenity --list --title="$PANEL_TITLE" \
        --text="Bienvenido a la Suite de Entorno de Escritorio de Nexus Kali.\nElige una acción:" \
        --radiolist --column="" --column="Opción" --column="Descripción" \
        TRUE "${opciones[0]}" "${opciones[1]}"   FALSE "${opciones[2]}" "${opciones[3]}" \
        FALSE "${opciones[4]}" "${opciones[5]}"   FALSE "${opciones[6]}" "${opciones[7]}" \
        FALSE "${opciones[8]}" "${opciones[9]}"   FALSE "${opciones[10]}" "${opciones[11]}" \
        FALSE "${opciones[12]}" "${opciones[13]}" FALSE "${opciones[14]}" "${opciones[15]}" \
        FALSE "${opciones[16]}" "${opciones[17]}" \
        --width=700 --height=550)

    case "$choice" in
        "Personalizar Lanzadores") personalizar_lanzadores ;;
        "Aplicar Estilo Visual") estilizar_escritorio ;;
        "✨ Instalar Terminal Definitiva (Zsh)") instalar_terminal_definitiva ;;
        "🔒 Configurar Anonimato (Tor)") configurar_anonimato ;;
        "📊 Añadir Widgets de Sistema") añadir_widgets_sistema ;;
        "🔧 Realizar Mantenimiento") realizar_mantenimiento ;;
        "💡 Crear Accesos Directos Útiles") crear_accesos_directos ;;
        "⌨️ Configurar Atajos de Teclado") configurar_atajos_teclado ;;
        "🩺 Diagnosticar y Reparar Panel") diagnosticar_y_reparar ;;
    esac
}

main
