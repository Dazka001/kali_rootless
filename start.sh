#!/bin/bash
# Elimina el servidor VNC si una sesión anterior quedó activa
vncserver -kill :1 &> /dev/null || true

# Inicia el servidor VNC. El archivo xstartup se encargará de lanzar XFCE.
echo "🚀 Iniciando servidor VNC en la pantalla :1"
vncserver :1 -geometry 1280x720 -depth 24

# MEJORA: Muestra los logs de VNC para depuración y para mantener el contenedor activo
echo "🎯 Entorno XFCE disponible en localhost:5901 (Contraseña: kali)"
tail -f /home/kali/.vnc/*.log