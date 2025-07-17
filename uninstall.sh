#!/data/data/com.termux/files/usr/bin/bash
# Script avanzado para desinstalar Kali NetHunter Rootless y limpiar configuración

echo -e "\n⚠️  Este script eliminará permanentemente tu entorno de Kali Linux."
read -p "¿Deseas continuar con la desinstalación? (s/n): " confirm
[[ "$confirm" != [sS] ]] && echo "❌ Desinstalación cancelada." && exit 1

# 1. Eliminar entorno de Kali
if [ -d "$HOME/kali-fs" ]; then
    echo "🧹 Eliminando entorno: $HOME/kali-fs"
    rm -rf "$HOME/kali-fs"
else
    echo "ℹ️  No se encontró el entorno en $HOME/kali-fs"
fi

# 2. Eliminar postinstall (opcional)
if [ -f "$HOME/kali_postinstall.sh" ]; then
    read -p "¿Eliminar el script de postinstalación (kali_postinstall.sh)? (s/n): " postdel
    [[ "$postdel" == [sS] ]] && rm "$HOME/kali_postinstall.sh" && echo "✅ Script eliminado."
fi

# 3. Eliminar alias `nh` del .bashrc
if grep -q "alias nh=" "$HOME/.bashrc"; then
    echo "🧽 Limpiando alias 'nh' del archivo .bashrc"
    sed -i '/alias nh=/d' "$HOME/.bashrc"
fi

# 4. Eliminar lanzador `nh` del PATH
if [ -f "$PREFIX/bin/nh" ]; then
    echo "🗑️  Eliminando lanzador ejecutable nh en $PREFIX/bin/"
    rm "$PREFIX/bin/nh"
fi

# 5. Limpieza opcional de scripts de instalación
echo -e "\nArchivos que podrían quedar:"
ls -1 "$HOME"/{install*,uninstall*,kali.sh} 2>/dev/null
read -p "¿Deseas eliminar también estos scripts de instalación? (s/n): " clean
if [[ "$clean" == [sS] ]]; then
    rm -f "$HOME"/install* "$HOME"/uninstall* "$HOME"/kali.sh
    echo "🧹 Scripts eliminados."
fi

echo -e "\n✅ Desinstalación completa y limpieza finalizada."
echo "ℹ️  Puedes reiniciar Termux para aplicar cambios a tu shell."
