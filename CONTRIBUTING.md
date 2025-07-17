# Guía para Contribuir a Kali Rootless Installer

¡Gracias por tu interés en contribuir! Toda ayuda es bienvenida, desde la corrección de errores hasta la propuesta de nuevas funcionalidades. Para mantener el proyecto organizado, por favor sigue estas pautas.

## Cómo Contribuir

1.  **Haz un Fork:** Crea una copia ("fork") de este repositorio en tu propia cuenta de GitHub.
2.  **Clona tu Fork:** Clona el repositorio a tu máquina local.
    ```bash
    git clone [https://github.com/TU_USUARIO/kali_rootless.git](https://github.com/TU_USUARIO/kali_rootless.git)
    ```
3.  **Crea una Rama:** Crea una rama descriptiva para tus cambios.
    ```bash
    # Para una nueva funcionalidad
    git checkout -b feature/nombre-funcionalidad

    # Para una corrección de error
    git checkout -b fix/descripcion-bug
    ```
4.  **Realiza tus Cambios:** Edita el código y asegúrate de probarlo thoroughly.
5.  **Haz Commit de tus Cambios:** Escribe un mensaje de commit claro y conciso.
    ```bash
    git commit -m "feat: Añade soporte para arquitectura armhf"
    ```
6.  **Sube tus Cambios:** Sube la rama a tu fork en GitHub.
    ```bash
    git push origin feature/nombre-funcionalidad
    ```
7.  **Abre un Pull Request:** Ve al repositorio original y abre un "Pull Request" desde tu rama. Rellena la plantilla con la información solicitada.

## Formato de Commits

Utilizamos un estilo basado en [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Esto nos ayuda a generar el `CHANGELOG.md` automáticamente. El formato es:

`<tipo>(<ámbito opcional>): <descripción>`

-   **Tipos comunes:**
    -   `feat`: Una nueva funcionalidad.
    -   `fix`: Una corrección de un error.
    -   `docs`: Cambios en la documentación.
    -   `style`: Cambios de formato (espacios, comas, etc.).
    -   `refactor`: Refactorización de código que no altera la funcionalidad.
    -   `test`: Añadir o corregir pruebas.
    -   `chore`: Mantenimiento del repositorio (actualizar dependencias, etc.).

**Ejemplos:**
-   `feat: Añade script para desinstalar el entorno`
-   `fix: Corrige la URL de descarga de la imagen de Kali`
-   `docs: Mejora la sección de troubleshooting en el README`

## Estilo de Código

-   **Scripts de Shell (`.sh`):**
    -   Usa `shellcheck` para verificar tu código y corregir errores comunes.
    -   Comenta las partes complejas del código.
    -   Usa nombres de variables descriptivos (e.g., `KALI_ROOTFS_DIR` en lugar de `kfs`).

## Recursos Útiles

-   [Guía oficial de GitHub para contribuir a proyectos](https://docs.github.com/es/get-started/quickstart/contributing-to-projects)
-   [Aprende sobre Pull Requests](https://docs.github.com/es/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)

¡Gracias de nuevo por tu ayuda!
