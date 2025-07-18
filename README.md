# 🐉 Nexus Kali

![Nexus Kali – entorno de hacking con escritorio gráfico XFCE](assets/nexus_kali_banner.png)

## 📚 Contenido

- [🚀 Introducción](#-introducción)
- [🧰 Herramientas Incluidas](#-herramientas-incluidas)
- [📦 Requisitos Previos](#-requisitos-previos)
- [📁 Estructura del Proyecto](#-estructura-del-proyecto)
- [⚙️ Instalación en Termux (Android)](#️-instalación-en-termux-android)
- [🐳 Uso con Docker (Linux/PC)](#-uso-con-docker-linuxpc)
- [🧹 Desinstalación](#-desinstalación)
- [🛠️ Troubleshooting y FAQ](#️-troubleshooting-y-faq)
- [📄 Licencia](#-licencia)

---

## 🚀 Introducción

Convierte tu dispositivo Android o tu PC en una estación de hacking lista para usar con XFCE, herramientas OSINT y scripts automatizados. Nexus Kali ofrece una instalación completa para entornos móviles (Termux) o Docker (PC).

---

## 🧰 Herramientas Incluidas

- OSINT & Pentesting:
  - Nmap
  - Metasploit
  - Burp Suite
  - Maltego
  - WhatWeb
  - Recon-ng

- Análisis Forense / Ciberseguridad:
  - Autopsy
  - Volatility
  - Wireshark
  - Ghidra

- Navegación y Utilidades:
  - Firefox
  - Thunar
  - xfce4-terminal

---

## 📦 Requisitos Previos

- **Android (Termux)**: Android 7.0 o superior
- **PC (Docker)**:
  - Docker + Docker Compose
  - Cliente VNC (ej. Remmina, VNC Viewer)

---

## 📁 Estructura del Proyecto

```
kali_rootless/
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── start.sh
│   ├── kali_postinstall.sh
│   ├── reset_xfce_panel.sh
│   └── uninstall.sh
├── assets/
│   └── nexus_kali_banner.png
├── CHANGELOG.md
├── CONTRIBUTING.md
├── README.md
├── README_DOCKER.md
└── FAQ.md
```

[🔝 Volver al inicio](#contenido)

---

## ⚙️ Instalación en Termux (Android)

### 1. Actualiza los paquetes e instala git

```bash
pkg update && pkg upgrade
pkg install git
```

### 2. Clona el repositorio

```bash
git clone https://github.com/Dazka001/kali_rootless.git
cd kali_rootless
```

### 3. Ejecuta el instalador

```bash
chmod +x install_kali_rootless_auto.sh
./install_kali_rootless_auto.sh
```

---

## 🐳 Uso con Docker (Linux/PC)

Desde un entorno Linux con Docker instalado:

### 1. Entra en el directorio

```bash
cd docker
```

### 2. Construye e inicia

```bash
docker-compose build
docker-compose up -d
```

### 3. Accede vía VNC

- Dirección: `localhost:5901`
- Contraseña: `kali`

[🔝 Volver al inicio](#contenido)

---

## 🧹 Desinstalación

### Termux

```bash
./uninstall.sh
```

### Docker

```bash
docker-compose down -v --remove-orphans
```

---

## 🛠️ Troubleshooting y FAQ

Consulta el archivo [FAQ.md](FAQ.md) para respuestas a los errores más comunes como:

- Pantalla gris en VNC
- Errores de permisos
- Lanzadores XFCE que no aparecen
- Problemas con audio o memoria compartida

[🔝 Volver al inicio](#contenido)

---

## 📄 Licencia

Distribuido bajo la Licencia MIT © [Dazka001](https://github.com/Dazka001)