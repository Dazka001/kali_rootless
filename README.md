![version](https://img.shields.io/badge/version-1.0.0-green)
![license](https://img.shields.io/badge/license-MIT-blue)

# Nexus Kali: Your Portable Hacking Lab

![XFCE Desktop](assets/xfce_custom_panel.png)



Instalador automatizado de Kali Linux con escritorio XFCE, compatible tanto con Android/Termux (rootless) como con Docker para PC y servidores. Permite personalización avanzada del escritorio y automatiza el despliegue de herramientas OSINT/hacking.

---

✨ Características Principales
 
 * Multi-Plataforma: Despliégalo en cualquier PC (Windows, macOS, Linux) con Docker, o llévalo en tu bolsillo con Termux en Android.
 
 * Entorno Persistente: Guarda tus archivos y configuraciones gracias a los volúmenes de Docker. Tu trabajo no se pierde.
 
 * Personalización Avanzada: Usa el script reset_xfce_panel.sh para configurar tu escritorio y lanzadores a tu gusto.

 * Caja de Herramientas Incluida: Viene con una amplia gama de herramientas de seguridad preinstaladas.

---


🧰 Caja de Herramientas Preinstalada
Este entorno viene con una selección curada de herramientas esenciales de seguridad y OSINT, listas para usar.

 * Análisis Web y de Redes
   * Nmap (Zenmap)
   * Burp Suite
   * OWASP ZAP
   * Wireshark
   * Nikto
   * sqlmap
   * wpscan

 * Explotación y Spoofing
   * Metasploit Framework
   * SEToolkit (SET)
   * Responder
   * Ettercap

 * Ataques de Contraseñas y Wireless
   * John the Ripper
   * Hydra
   * Aircrack-ng
   * Hashcat

 * Análisis Forense y OSINT
   * Maltego
   * Autopsy
   * Recon-ng
   * SpiderFoot

 * Ingeniería Inversa
   * Ghidra
   * Cutter
   * Radare2

---

📜 Tabla de contenidos
 * Características Principales
 * Instalación en Termux (Android)
 * Instalación con Docker (PC/Servidor)
 * Personalización de Escritorio
 * Persistencia y Backups
 * Solución a Problemas y FAQ
 * Licencia

---

🚀 Instalación en Termux (Android)

Este método instala una versión de Kali Linux directamente en tu dispositivo Android usando Termux y Proot.

Requisitos:

 * Termux: Versión actualizada desde F-Droid. La versión de la Play Store está obsoleta.
 
 * Almacenamiento: Al menos 8 GB de espacio libre.

 * Dependencias: git, wget, proot. El script intentará instalarlas.
Pasos de Instalación
 
 * Clonar el Repositorio:
   # Actualiza los paquetes de Termux y instala git
`pkg update && pkg upgrade -y && pkg install git -y`

# Clona el repositorio
`git clone https://github.com/Dazka001/kali_rootless.git`

# Entra en el directorio

`cd kali_rootless`

 * Ejecutar el Instalador:
   Dale permisos de ejecución al script y lánzalo.
   chmod +x install_kali_rootless_auto.sh
./install_kali_rootless_auto.sh

 * Iniciar Kali Linux:
   Una vez instalado, puedes entrar a la terminal de Kali con:
   ./start-kali.sh

Desinstalación en Termux
Para eliminar completamente la instancia de Kali, ejecuta:
chmod +x uninstall.sh
./uninstall.sh

---

🐳 Instalación con Docker (PC/Servidor)

Este es el método recomendado para cualquier PC o servidor. El entorno está en la carpeta /docker. Consulta docker/README_DOCKER.md para instrucciones más detalladas.

Resumen Rápido

`cd docker`

`docker-compose build`

`docker-compose up -d`

Conéctate por VNC a localhost:5901 (password: kali).

---

🎨 Personalización de Escritorio

Tanto en Termux como en Docker, puedes usar el script reset_xfce_panel.sh para configurar tu panel.

 * Abre una terminal dentro de tu entorno Kali.

 * Ejecuta el script: reset_xfce_panel.sh

 * Aparecerá un menú interactivo para que elijas qué lanzadores agregar.

---

💾 Persistencia y Backups
 * Termux: Tus archivos se guardan en la carpeta kali-fs. Haz un backup de esa carpeta para resguardar tu entorno.
 
 * Docker: Todo lo que guardes en /home/kali se almacena en la carpeta kali_home en tu computadora. Simplemente haz un backup de esta carpeta.

---

🛠️ Solución a Problemas y FAQ

1. No me puedo conectar por VNC (“Connection Refused”)
 * Causa: El contenedor de Docker no está corriendo.
 * Solución: Revisa su estado con docker ps -a. Si está detenido (Exited), revisa los logs con docker logs kali_xfce_vnc.

2. Veo una pantalla gris vacía al conectar por VNC
 * Causa: El escritorio XFCE no se inició correctamente.
 * Solución: Revisa los logs del contenedor (docker logs kali_xfce_vnc). Asegúrate de usar las versiones actualizadas de los archivos de Docker.

3. Las aplicaciones gráficas se cierran inesperadamente (Docker)
 * Causa: El contenedor no tiene suficiente memoria compartida.
 * Solución: Asegúrate de que tu docker-compose.yml incluya shm_size: '2gb'. Si lo agregas, reinicia con docker-compose down && docker-compose up -d.

4. “Permiso denegado” al ejecutar un script
 * Causa: El script no tiene permisos de ejecución.
 * Solución: Dale permisos con chmod +x nombre_del_script.sh.

5. ¿Se guardan mis archivos si reinicio el contenedor?
 * Sí. Gracias al volumen kali_home, todo tu directorio de usuario es persistente.

6. ¿Cómo instalo más herramientas?
 * Dentro del entorno Kali, usa sudo apt install nombre_paquete.

7. ¿Cómo elimino por completo el entorno Docker?
 * Este comando eliminará el contenedor y el volumen con tus datos:
   docker-compose down -v

---

📄 Licencia
Distribuido bajo la Licencia MIT. © Dazka001

