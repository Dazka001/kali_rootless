# ✅ CONTRIBUYENDO A Nexus Kali: Your Portable Hacking Lab

¡Gracias por tu interés en contribuir! Toda colaboración es bienvenida: desde reportes de errores hasta nuevas funcionalidades.

## 🧭 Cómo Contribuir

1. **Haz un Fork**  
   Crea una copia de este repositorio en tu cuenta.

2. **Clona tu Fork**  
   Descarga tu fork localmente:
   ```bash
   git clone https://github.com/TU_USUARIO/kali_rootless.git
   cd kali_rootless
   ```

3. **Crea una Rama**  
   Usa una rama descriptiva para tu aporte:
   ```bash
   # Para una nueva funcionalidad
   git checkout -b feat/soporte-armhf

   # Para corrección de bug
   git checkout -b fix/url-descarga
   ```

4. **Haz los Cambios y Pruebas**  
   Asegúrate de que tu contribución funcione correctamente y no rompa scripts existentes.

5. **Commit**  
   Sigue el formato de commits convencionales:
   ```bash
   git commit -m "feat: agrega script de desinstalación"
   ```

6. **Push y Pull Request**  
   Sube tu rama:
   ```bash
   git push origin feat/soporte-armhf
   ```
   Luego abre un Pull Request hacia `main` y completa la plantilla correspondiente.

---

## 📐 Estilo de Commit (Conventional Commits)

Formato:

```
feat(rootless): añade soporte para instalación automática
fix(uninstall): corrige error al eliminar carpeta inexistente
docs(readme): actualiza pasos de uso con nueva imagen
style(panel): corrige identado y variables no usadas
chore(repo): reorganiza estructura y limpia scripts viejos
```

**Tipos comunes:**

- `feat`: Nueva funcionalidad
- `fix`: Corrección de errores
- `docs`: Documentación
- `style`: Estética/código no funcional
- `refactor`: Refactorización sin cambio de comportamiento
- `test`: Añadir/corregir pruebas
- `chore`: Tareas de mantenimiento

**Ejemplos:**

- `feat: añade soporte para entorno offline`
- `fix: corrige validación de checksum`
- `docs: aclara uso de aliases en README`

---

## 🧪 Estilo de Código

- Scripts `bash` compatibles con `#!/bin/bash` o `#!/usr/bin/env bash`.
- Utiliza `shellcheck` para detectar errores.
- Nombra variables de forma clara y consistente (`KALI_ROOTFS_URL`, `INSTALL_DIR`, etc.).
- Comenta secciones importantes o no triviales.

---

## 📎 Recursos Útiles

- [Guía oficial de GitHub para contribuir](https://docs.github.com/es/get-started/quickstart/contributing-to-projects)
- [Convenciones de Commit](https://www.conventionalcommits.org/)
- [ShellCheck para scripts bash](https://www.shellcheck.net/)

---

¿Listo para contribuir? 🚀 ¡Esperamos tu pull request!
