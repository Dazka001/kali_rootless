#!/bin/bash
# Script para desinstalar el entorno Kali Rootless

echo "⚠️  Este script eliminará permanentemente tu entorno de Kali Linux."
read -p "¿Estás seguro de que quieres continuar? (s/n): " confirm

if [[ "$confirm" != "s" ]]; then
    echo "Desinstalación cancelada."
    exit 1
fi

echo "Eliminando el directorio de Kali (kali-fs)..."
rm -rf kali-fs

echo "✅ Desinstalación completada."
echo "Los scripts (install.sh, kali.sh, uninstall.sh) no han sido eliminados."
