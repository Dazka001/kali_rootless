---
# 🐳 Guía de Uso: Nexus Kali con Docker

Este documento contiene las instrucciones detalladas para desplegar y gestionar el entorno **Nexus Kali** usando Docker y Docker Compose.

> **Nota:** Para la guía de instalación en Termux o para ver la visión general del proyecto, por favor, consulta el **[README.md principal](../README.md)**.

---

### ✅ Requisitos

* [Docker](https://www.docker.com/get-started)
* [Docker Compose](https://docs.docker.com/compose/install/) (Recomendado)
* Un cliente VNC (Ej: [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/), [Remmina](https://remmina.org/))
* `git` para clonar el repositorio.

---

### 🚀 Instalación Rápida

1.  **Clona el repositorio y entra en la carpeta `docker`:**
    ```bash
    git clone https://github.com/Dazka001/kali_rootless.git
    cd kali_rootless/docker
    ```

2.  **Construye la imagen e inicia el contenedor:**
    El siguiente comando descargará las dependencias, construirá la imagen de Docker, y lanzará el contenedor en segundo plano (`-d`).
    ```bash
    docker-compose build
    docker-compose up -d
    ```

---

### 🖥️ Acceso al Entorno Gráfico (XFCE)

1.  Abre tu cliente VNC.
2.  Conéctate a la dirección: `localhost:5901`
3.  Cuando te solicite una contraseña, usa la que viene por defecto:
    `kali`

> 💡 **Tip:** Puedes modificar la resolución del escritorio editando el archivo `start.sh` antes de construir la imagen.

---

### 🛠️ Personalización del Panel

Una vez dentro del escritorio XFCE, puedes ejecutar el script de personalización para agregar lanzadores de tus herramientas favoritas.

* Abre una terminal (`xfce4-terminal`).
* Ejecuta el comando: `reset_xfce_panel.sh`
* Sigue las instrucciones del menú interactivo.

---

### 🧹 Desinstalación Completa

Para detener y eliminar el contenedor, la red virtual y **el volumen persistente con todos tus datos**, ejecuta el siguiente comando desde la carpeta `docker/`:

```bash
docker-compose down -v
```
---

📄 Licencia
MIT © Dazka001

