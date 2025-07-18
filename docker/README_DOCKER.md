# 🐳 Kali Rootless XFCE via Docker

Versión dockerizada de Kali Linux con entorno gráfico XFCE y servidor VNC listo para usar. Incluye personalizaciones como:

- Escritorio XFCE preconfigurado
- Lanzadores personalizados para herramientas de hacking
- Scripts automatizados de post-instalación
- Servidor VNC expuesto en el puerto `5901`
- Usuario no root (`kali`) sin contraseña

---

## 📦 Requisitos

- Docker
- Docker Compose (opcional pero recomendado)
- Cliente VNC (ej. VNC Viewer o Remmina)

---


## 🚀 Instrucciones rápidas

```bash
# Clona el repositorio
git clone https://github.com/Dazka001/kali_rootless.git
cd kali_rootless/docker

# Construye la imagen
docker-compose build

# Inicia el contenedor en segundo plano
docker-compose up -d
```

---

## 🖥️ Acceso al entorno gráfico


Conéctate a `localhost:5901` con un cliente VNC. La contraseña por defecto es:
 `kali`
 
---------


> 💡 Puedes modificar el tamaño de pantalla desde `start.sh`.

---

## 🧩 Estructura del Proyecto

```
kali_rootless/
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── start.sh
│   ├── kali_postinstall.sh
│   └── reset_xfce_panel.sh
├── assets/
│   └── xfce_custom_panel.png
├── uninstall.sh
├── CONTRIBUTING.md
├── CHANGELOG.md
└── README.md
```

---

## 🔧 Personalización del escritorio

Al iniciar sesión por VNC, puedes ejecutar:

```bash
./reset_xfce_panel.sh
```

Este script:

- Restaura el panel superior
- Agrega lanzadores (Firefox, Terminal, Thunar)
- Detecta y ofrece herramientas OSINT instaladas
- Personaliza tamaño y apariencia

---

## 🧹 Desinstalación

```bash
docker-compose down --volumes --remove-orphans
```

Esto detendrá y eliminará el contenedor y los volúmenes asociados.

---

## 📄 Licencia

MIT © [Dazka001](https://github.com/Dazka001)
