# Changelog

Todos los cambios importantes en este proyecto se documentarán en este archivo.

Este proyecto sigue el formato de [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y adopta la versión semántica [SemVer](https://semver.org/lang/es/).

## [Unreleased]
_Futuros cambios para la versión 2.0.1 o 3.0.0..._

## [2.0.0] - 2025-07-18

### Añadido
- **Soporte completo para Docker:** Ahora el proyecto se puede desplegar en cualquier sistema operativo usando `Dockerfile` y `docker-compose.yml`.
- **Persistencia de Datos en Docker:** Se añadió un volumen para guardar el directorio `/home/kali` entre sesiones.
- **Documentación Mejorada:** `README.md` principal reescrito para actuar como guía central, con una sección detallada de "Caja de Herramientas" y "Solución a Problemas".
- **Documentación Específica para Docker:** Se creó `docker/README_DOCKER.md`.
- **Plantillas de Contribución:** Se añadieron plantillas para `Issues` y `Pull Requests` en `.github/`.

### Cambiado
- **Nombre del Proyecto:** Actualizado a "Nexus Kali: Your Portable Hacking Lab".
- **Estructura del Repositorio:** Reorganización completa para separar los entornos de Termux y Docker en una carpeta `/docker` dedicada.
- **Script de Personalización:** `reset_xfce_panel.sh` ahora es un script unificado y robusto que funciona en ambos entornos.

### Eliminado
- **Scripts Redundantes:** Se eliminaron `instalador_kali_personalizado.sh`, `kali_customize_auto.sh`, `kali_postinstall.sh`, y `entrypoint.sh` para simplificar el proyecto.
- **Archivos Temporales:** Se eliminó `panel-xfce-kali.desktop.txt`.

## [1.0.0] - 2025-06-05

### Añadido
- Script `install_kali_rootless_auto.sh` para instalación automatizada en Termux.
- Script `start-kali.sh` para iniciar el entorno con `proot`.
- Script `uninstall.sh` para desinstalación limpia del entorno.
  
