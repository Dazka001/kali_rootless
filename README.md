![Captura del escritorio XFCE personalizado](activos/xfce_custom_panel.png)
# ⚔️ Kali NetHunter Rootless Automatizado con XFCE + KeX (by @Dazka001)

Este repositorio contiene una **instalación 100 % automatizada** y mejorada de **Kali NetHunter Rootless**, adaptada especialmente para Termux en Android. Incluye soporte completo para escritorio XFCE, cliente gráfico KeX, postinstalación personalizada y herramientas de personalización del panel XFCE con lanzadores de herramientas OSINT y de pentesting.

---

## 🚀 ¿Qué incluye?

✅ Instalación FULL de Kali NetHunter (v2024.3)  
✅ Escritorio XFCE completo + TigerVNC  
✅ Cliente gráfico KeX listo para usar  
✅ Script de postinstalación personalizable  
✅ Comando `nh` creado automáticamente  
✅ Alias y ajustes añadidos al `.bashrc`  
✅ Personalizador de panel con lanzadores hacking/OSINT  
✅ Verificación SHA512 del rootfs  
✅ Descarga rápida con `axel`  
✅ Evita errores de repositorio y menús rotos (parche incluido)

---

## 📦 Archivos principales

| Archivo | Función |
|--------|--------|
| `install_kali_rootless_auto.sh` | Script principal de instalación (versión extendida) |
| `kali_postinstall.sh` | Postinstalación automática desde dentro de Kali |
| `reset_xfce_panel.sh` | Script interactivo para restaurar o personalizar el panel XFCE |
| `kali_customize.sh` *(opcional)* | Personalización extra: neofetch, alias, herramientas ofensivas y defensivas |
| `kali-panel-xfce-custom-iso/` | Archivos `.desktop` para integración con menú gráfico |

---

## 📲 Instalación paso a paso

### 1. Instala Termux (desde F-Droid, no Google Play)

- [F-Droid Termux](https://f-droid.org/packages/com.termux/)
- O [GitHub Releases oficial](https://github.com/termux/termux-app/releases)

### 2. Clona este repositorio

```bash
cd ~
git clone https://github.com/Dazka001/kali_rootless.git
cd kali_rootless
