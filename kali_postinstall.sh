#!/bin/bash

# ==============================================================================
#  AVISO: Este script ha sido reemplazado por el Dockerfile.
# ==============================================================================
#
# El entorno Docker se construye con todas las herramientas y configuraciones
# ya preinstaladas en la imagen. No es necesario ejecutar este script de
# post-instalación.
#
# Si deseas agregar nuevas herramientas, debes modificar el 'Dockerfile' y
# reconstruir la imagen con:
#
#   docker-compose build
#

echo "ℹ️  Aviso: El script 'kali_postinstall.sh' es obsoleto en el entorno Docker."
echo "   La instalación de paquetes ahora se gestiona directamente en el Dockerfile."

exit 0
