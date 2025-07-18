# Dockerfile para Kali Rootless XFCE (Optimizado para Persistencia)
# Fecha de actualización: 17 de julio de 2025
FROM kalilinux/kali-rolling

LABEL maintainer="Dazka001"
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar dependencias, entorno gráfico y herramientas de seguridad
# Se omite 'apt upgrade' para acelerar la construcción de la imagen.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Entorno de escritorio y utilidades
    xfce4 xfce4-goodies tightvncserver sudo wget curl git dbus-x11 nano \
    firefox-esr thunar neofetch htop fonts-firacode x11-utils \
    # Herramientas de seguridad
    nmap metasploit-framework wireshark john aircrack-ng hydra burpsuite \
    nikto maltego setoolkit sqlmap wpscan responder && \
    # Limpieza para reducir el tamaño de la imagen
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Crear usuario 'kali' y configurar el entorno VNC
RUN useradd -m -s /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    adduser kali sudo && \
    mkdir -p /home/kali/.vnc && \
    echo "kali" | vncpasswd -f > /home/kali/.vnc/passwd && \
    chmod 600 /home/kali/.vnc/passwd && \
    # CRÍTICO: Este archivo inicia XFCE cuando se conecta por VNC. Se añade XDG_CONFIG_DIRS para mayor compatibilidad.
    echo "#!/bin/bash\nexport XDG_CONFIG_DIRS=/etc/xdg\nstartxfce4 &" > /home/kali/.vnc/xstartup && \
    chmod +x /home/kali/.vnc/xstartup && \
    # Establecer propietario para el directorio home completo
    chown -R kali:kali /home/kali

# 3. Copiar scripts a una ruta del sistema (/usr/local/bin)
# MEJORA: Se copian aquí para evitar conflictos con el volumen persistente en /home/kali
COPY docker/start.sh /usr/local/bin/start.sh
COPY docker/reset_xfce_panel.sh /usr/local/bin/reset_xfce_panel.sh
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/reset_xfce_panel.sh

# 4. Configuración final de la imagen
USER kali
WORKDIR /home/kali

EXPOSE 5901

# El CMD ahora llama al script desde su nueva ubicación en el PATH del sistema
CMD ["start.sh"]
