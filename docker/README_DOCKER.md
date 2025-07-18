---

# 🐳 Kali Rootless XFCE vía Docker

Versión dockerizada de Kali Linux con entorno gráfico XFCE, herramientas OSINT y servidor VNC preconfigurado. Diseñado para entornos de hacking ético, análisis forense o pruebas de seguridad de forma portátil y aislada.

---

## 📦 Requisitos

- Docker
- Docker Compose (opcional pero recomendado)
- Cliente VNC (ej: TigerVNC, Remmina, RealVNC)
- Git (para clonar el repositorio)

---

## 🚀 Instalación rápida

```bash
git clone https://github.com/Dazka001/kali_rootless.git
cd kali_rootless/docker
docker-compose build
docker-compose up -d
```

✅ La primera ejecución instalará XFCE, configurará el servidor VNC y desplegará lanzadores útiles.


---

🖥️ Acceso al entorno gráfico (XFCE)

1. Abre tu cliente VNC y conéctate a:

   localhost: `5901`


2. Contraseña predeterminada:
  
   `kali`

   





> 💡 Puedes modificar resolución y profundidad de color editando start.sh.




---

🛠️ Scripts incluidos

start.sh: Inicializa XFCE + VNC con resolución definida

reset_xfce_panel.sh: Restaura el panel con accesos rápidos (Terminal, Firefox, Burp, etc.)

kali_postinstall.sh: Automatiza instalación de herramientas de hacking y OSINT

uninstall.sh: Limpia contenedor y volúmenes



---

# 📁 Estructura del Proyecto

```text
kali_rootless/
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── start.sh
│   ├── kali_postinstall.sh
│   ├── reset_xfce_panel.sh
│   └── uninstall.sh
├── assets/
│   └── xfce_custom_panel.png
├── CHANGELOG.md
├── CONTRIBUTING.md
├── README.md
├── README_DOCKER.md
└── FAQ.md
```

---

# 🔧 Personalización del panel XFCE

Una vez conectado al escritorio, ejecuta:

./reset_xfce_panel.sh

Este script:

Restaura el panel superior

Agrega iconos personalizados

Detecta y muestra herramientas instaladas (Firefox, Thunar, Burp Suite, etc.)

Aplica configuración visual



---

# 🧹 Desinstalación completa

Para detener y eliminar todo:

`docker-compose down --volumes --remove-orphans`

Esto borra el contenedor, los volúmenes persistentes y limpia la red virtual creada.


---

# 🧰 Solución de Problemas

Consulta FAQ.md para:

 • Conexión VNC rechazada

 • Pantalla gris en XFCE

 • Problemas de permisos

 • Soluciones Docker/Linux comunes



---

📄 Licencia

MIT © Dazka001

---
