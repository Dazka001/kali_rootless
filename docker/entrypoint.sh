#!/bin/bash
set -e

# Iniciar el servidor VNC en la pantalla :1
# Asegúrate de que el directorio .vnc exista
mkdir -p /home/kali/.vnc

# Establece una contraseña por defecto si no se ha proporcionado una
export VNC_PASSWORD=${VNC_PASSWORD:-"kali"}
echo "$VNC_PASSWORD" | vncpasswd -f > /home/kali/.vnc/passwd
chmod 600 /home/kali/.vnc/passwd

# Iniciar el servidor VNC con una geometría de pantalla estándar
vncserver :1 -geometry 1280x800 -depth 24

# Iniciar el entorno de escritorio XFCE
startxfce4 &

# Mantener el contenedor en ejecución mostrando los logs de VNC
tail -f /home/kali/.vnc/*.log
