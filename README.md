![version](https://img.shields.io/badge/version-1.0.0-green)
![license](https://img.shields.io/badge/license-MIT-blue)

# Kali Rootless Installer

![XFCE Desktop](assets/xfce_custom_panel.png)

Instalador automatizado de Kali Linux con escritorio XFCE, compatible tanto con Android/Termux (rootless) como con Docker para PC y servidores. Permite personalización avanzada del escritorio y automatiza el despliegue de herramientas OSINT/hacking.

---

## Tabla de contenidos
- [Instalación en Termux (Android)](#instalación-en-termux-android)
- [Instalación con Docker (PC/Servidor)](#instalación-con-docker-pcservidor)
- [Personalización de escritorio](#personalización-de-escritorio)
- [Persistencia y backups](#persistencia-y-backups)
- [Problemas comunes (Troubleshooting)](#problemas-comunes-troubleshooting)
- [FAQ](#faq)
- [Licencia](#licencia)

---


## Instalación en Termux (Android)

Antes de empezar, asegúrate de tener lo siguiente:

- **Termux:** Una versión actualizada desde [F-Droid](https://f-droid.org/en/packages/com.termux/). Las versiones de la Play Store están obsoletas y no funcionarán.
- **Almacenamiento:** Al menos 5 GB de espacio libre en el almacenamiento interno.
- **Dependencias:** Los siguientes paquetes deben estar instalados en Termux. El script de instalación intentará instalarlos automáticamente.
  - `wget`
  - `proot`
  - `tar`
  - `pulseaudio`

---


## 🚀 Instalación y Uso

### 1. Clonar el Repositorio
Abre Termux y ejecuta los siguientes comandos:

```bash
# Actualiza los paquetes de Termux
pkg update && pkg upgrade -y

# Instala git para clonar el repositorio
pkg install git -y

# Clona este repositorio
git clone [https://github.com/Dazka001/kali_rootless.git](https://github.com/Dazka001/kali_rootless.git)

# Entra en el directorio
cd kali_rootless
```


### 2. Ejecutar el Script de Instalación
Dale permisos de ejecución al script `install.sh` y lánzalo:

```bash
chmod +x install.sh
./install.sh
```
El script descargará la imagen de Kali (~1.5 GB) y la descomprimirá. Este proceso puede tardar varios minutos dependiendo de tu conexión a internet.

---


### 3. Iniciar Kali Linux
Una vez terminada la instalación, puedes iniciar sesión en tu nuevo entorno Kali en cualquier momento con:

```bash
./kali.sh
```
¡Y listo! Estarás dentro de la terminal de Kali Linux.

---



### 🧹 Desinstalación

Si deseas eliminar el entorno de Kali Linux, puedes usar el script de desinstalación. Este comando borrará la carpeta `kali-fs` con todo su contenido.

**Importante:** Esta acción es irreversible y borrará todos los datos dentro de tu instancia de Kali.

Para ejecutarlo, usa:

```bash
chmod +x uninstall.sh
./uninstall.sh

```


## Detalles de los Scripts

- `install.sh`: Realiza la instalación principal. Descarga la imagen `kali-linux-arm64-rootfs.tar.gz`, la extrae y configura los directorios necesarios.
- `kali.sh`: Es el lanzador principal. Utiliza `proot` para iniciar una sesión de shell dentro del entorno de Kali, montando los directorios vitales del sistema (`/dev`, `/proc`, etc.) y configurando el servidor de sonido `pulseaudio`


---

## Instalación con Docker (PC/Servidor)

El entorno Dockerizado está en la carpeta `/docker`.  
Consulta [docker/README_DOCKER.md](./docker/README_DOCKER.md) para instrucciones detalladas.

**Resumen rápido:**

```bash
cd docker
docker-compose build
docker-compose up -d
```

Conéctate por VNC a localhost:5901 (password: kali).

---

Personalización de escritorio

Puedes ejecutar reset_xfce_panel.sh tanto en Termux como en Docker para restaurar y personalizar el panel XFCE.


---

Persistencia y Backups

El volumen de Docker permite conservar archivos y configuraciones entre reinicios. Haz backup de la carpeta kali_home para conservar tu entorno.


---

## 🛠️ Solución a Problemas Comunes

Aquí tienes soluciones a los problemas más frecuentes que podrías encontrar:

---

### 1. No me puedo conectar por VNC (“Connection Refused”)

**Causa probable:** 

El contenedor de Docker no está corriendo o se detuvo por un error.

**Solución:**

- Abre una terminal y revisa el estado del contenedor:
  ```bash
  docker ps -a

Busca el contenedor kali_xfce_vnc.
Si su estado es Exited (y no Up), significa que hubo un error.

Revisa los logs para ver el error específico:

docker logs kali_xfce_vnc



---

### 2. Pantalla gris vacía al conectar por VNC

Causa probable: XFCE no se inició correctamente.

Solución:

Verifica los logs del contenedor (como arriba).

El log de VNC te dirá si hubo un error con startxfce4.

Asegúrate de usar la versión actualizada de tu Dockerfile y start.sh.



---

### 3. Firefox, Burp Suite u otras apps gráficas se cierran inesperadamente

Causa probable: El contenedor no tiene suficiente memoria compartida (/dev/shm).

Solución:

Asegúrate de que tu docker-compose.yml incluya:

shm_size: '2gb'

Si la agregas, detén y reinicia el contenedor:

docker-compose down
docker-compose up -d



---

### 4. “Permiso denegado” al ejecutar ./reset_xfce_panel.sh

Causa probable: El script no tiene permisos de ejecución.

Solución:

chmod +x ./reset_xfce_panel.sh
./reset_xfce_panel.sh


---

### 5. “Permiso denegado” al usar docker en Linux

Causa probable: Tu usuario no pertenece al grupo docker.

Solución:

sudo usermod -aG docker $USER
newgrp docker

> Luego, reinicia la sesión o el sistema.



---

⚡ Tips avanzados y extras

¿Quieres ver los logs en tiempo real?

docker-compose logs -f

¿Reseteaste el panel XFCE y quieres restaurar un backup anterior?
Busca en ~/.config/xfce4/backup_*/ dentro de tu contenedor o volumen persistente.

¿Problemas con los iconos?
Instala paquetes de iconos extra con:

sudo apt install kali-desktop-xfce adwaita-icon-theme hicolor-icon-theme



---

# ❓ Preguntas Frecuentes (FAQ) – Kali XFCE Docker

---

### **¿Qué es este proyecto?**
Es un entorno Kali Linux con XFCE y VNC que puedes ejecutar de forma rápida y segura en cualquier sistema con Docker. Incluye herramientas de hacking, scripts de personalización y lanzadores automáticos.

---

### **¿Cómo me conecto al escritorio?**
1. Inicia el contenedor con Docker Compose.
2. Usa un cliente VNC (como VNC Viewer, Remmina o similar).
3. Conéctate a `localhost:5901` (contraseña: `kali`).

---

### **¿Se guardan mis archivos y configuraciones después de reiniciar el contenedor?**
Sí. Todo lo que guardes en `/home/kali` se almacena en la carpeta `kali_home` en tu máquina host (por el volumen persistente del Compose).

---

### **¿Puedo instalar herramientas adicionales?**
¡Sí! Abre una terminal en el entorno XFCE y usa `sudo apt install nombre_paquete`.

---

### **¿Cómo restauro el panel XFCE a la versión personalizada?**
Ejecuta en la terminal de XFCE:
```bash
./reset_xfce_panel.sh
```

Podrás elegir qué lanzadores agregar mediante un menú interactivo.


---

¿Qué hago si olvido la contraseña VNC?

La contraseña por defecto es kali. Si cambiaste y olvidaste la contraseña, borra el volumen persistente y recrea el contenedor:

docker-compose down -v
docker-compose up -d --build


---

¿Puedo usar este entorno en Windows/Mac/Linux?

Sí, siempre que tengas Docker y Docker Compose instalados.


---

¿Hay forma de ampliar la resolución o cambiar la geometría del escritorio?

Edita el archivo start.sh y cambia el valor en la línea de vncserver:

vncserver :1 -geometry 1920x1080 -depth 24


---

¿Qué hago si alguna aplicación gráfica falla o no se inicia?

Revisa que tengas suficiente memoria compartida en tu archivo docker-compose.yml (shm_size: '2gb').


---

¿Cómo elimino todo el entorno y mis archivos?

Ejecuta:

docker-compose down -v --remove-orphans

---

Licencia

MIT © Dazka001
