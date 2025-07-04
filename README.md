# 🔐 Actualización Automática de Sistemas Linux 🔐

**Versión mantenida por [Esteban Nuñez](https://www.linkedin.com/in/esteban111221/)**  
Un script robusto y profesional para automatizar el proceso de actualización, auditoría y control de cambios en servidores Linux.

---

## ✨ Características principales

- 🔍 Detecta automáticamente la distribución Linux (Debian, Ubuntu, CentOS, RHEL, Fedora, Arch).
- 🔄 Ejecuta actualizaciones del sistema sin intervención manual.
- 🧾 Genera informes diarios con:
  - Fecha y hora
  - Cambios detectados en `/etc` (últimas 24h)
  - Paquetes instalados y actualizados
- ♻️ Mantiene automáticamente solo los últimos 10 informes.
- ✅ Compatible con ejecución vía `cron` semanal.

---

## 📦 Distribuciones soportadas

| Distribución  | Compatibilidad | Gestor de paquetes |
|---------------|----------------|---------------------|
| Debian        | ✅              | `apt`              |
| Ubuntu        | ✅              | `apt`              |
| CentOS 7 / RHEL 7 | ✅          | `yum`              |
| CentOS 8 / RHEL 8+ / Fedora | ✅| `dnf`              |
| Arch Linux    | ✅              | `pacman`           |

---

## ⚙️ Instalación y uso

1. Clonar el repositorio:
   ```bash
   git clone  https://github.com/esteban11121/UpdateServerLinux
   cd linux-updates-auditor

2. Dar permisos de ejecución:
    ```bash
    chmod +x ActualizacionesServer.sh
3. Ejecutar el script manualmente como root para verificar:
    ```bash
    sudo ./ActualizacionesServer.sh
4. (Opcional) Copiar al sistema para uso global:
    ```bash
    sudo cp ActualizacionesServer.sh /usr/local/bin/actualizaciones
5. Agregar al crontab para que se ejecute todos los sábados a las 2 AM:
    ```bash
    sudo crontab -e

    Agregar esto en la ultima linea. 
    0 2 * * 6 /usr/local/bin/actualizaciones
