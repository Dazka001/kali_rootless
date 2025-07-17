
# ⚔️ Kali NetHunter Rootless Automatizado con XFCE + KeX (by @Dazka001)

Este repositorio contiene una **instalación 100 % automatizada** y mejorada de **Kali NetHunter Rootless**, adaptada especialmente para Termux en Android. Incluye soporte completo para escritorio XFCE, cliente gráfico KeX, postinstalación personalizada y herramientas de personalización del panel XFCE con lanzadores de herramientas OSINT y de pentesting.

![Captura del escritorio XFCE personalizado](assents/file_00000000ff5061f89cb68632c15d719e.png)
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

## 📲 Requisitos 

### 1. Instala Termux (desde F-Droid, no Google Play)

- [F-Droid Termux] [actualizados](https://f-droid.org/packages/com.termux/)
- O [GitHub Releases oficial](https://github.com/termux/termux-app/releases)

``
## Cómo usar

Para instalar Kali NetHunter Rootless con entorno XFCE y soporte KeX completamente personalizado, sigue los pasos a continuación:

1. Clona este repositorio y accede a la carpeta del proyecto:

```bash
git clone https://github.com/Dazka001/kali_rootless.git
cd kali_rootless
```

2. Ejecuta el script automatizado principal:

```bash
bash install_kali_rootless_auto.sh
```

Este script:
- Descarga el rootfs completo de Kali NetHunter.
- Verifica el checksum SHA512.
- Aplica el parche del error 404.
- Instala XFCE, VNC y deja listo KeX.
- Crea el comando `nh` como acceso directo.

3. Accede a Kali:

```bash
nh
```

4. Dentro de Kali, ejecuta el script de postinstalación para configurar el entorno gráfico:

```bash
~/kali_postinstall.sh
```

5. Inicia KeX y abre la app “NetHunter KeX”:

```bash
nethunter kex &
```

- Host: `localhost`
- Port: `5901`
- Password: `toor`

6. (Opcional) Personaliza el panel XFCE con tu script:

```bash
bash restablecer_xfce_panel.sh
```
