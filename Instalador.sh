#!/bin/bash
# Script de instalación automática

echo "Copiando script al sistema..."
sudo cp actualizaciones-full.sh /usr/local/bin/actualizaciones
sudo chmod +x /usr/local/bin/actualizaciones

echo "Agregando al cron (ejecución semanal, sábados 2 AM)..."
(crontab -l 2>/dev/null; echo "0 2 * * 6 /usr/local/bin/actualizaciones") | crontab -

echo "✅ Instalación completa. El script se ejecutará automáticamente cada sábado."