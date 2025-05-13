#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Iniciando exportación de la configuración...${NC}"

# Crear directorio para la exportación
EXPORT_DIR="mis-bases-datos-export"
mkdir -p $EXPORT_DIR

# Copiar archivos de configuración
echo -e "${GREEN}Copiando archivos de configuración...${NC}"
cp docker-compose.yml $EXPORT_DIR/
cp README.md $EXPORT_DIR/
cp setup.sh $EXPORT_DIR/

# Crear directorio para respaldos
mkdir -p $EXPORT_DIR/backups

# Exportar datos de PostgreSQL
echo -e "${GREEN}Exportando datos de PostgreSQL...${NC}"
docker run --rm -v postgres_data:/source -v $(pwd)/$EXPORT_DIR/backups:/backup alpine tar -czf /backup/postgres_backup.tar.gz -C /source .

# Exportar datos de MySQL
echo -e "${GREEN}Exportando datos de MySQL...${NC}"
docker run --rm -v mysql_data:/source -v $(pwd)/$EXPORT_DIR/backups:/backup alpine tar -czf /backup/mysql_backup.tar.gz -C /source .

# Exportar datos de SQL Server
echo -e "${GREEN}Exportando datos de SQL Server...${NC}"
docker run --rm -v sqlserver_data:/source -v $(pwd)/$EXPORT_DIR/backups:/backup alpine tar -czf /backup/sqlserver_backup.tar.gz -C /source .

# Crear archivo ZIP
echo -e "${GREEN}Creando archivo ZIP...${NC}"
zip -r mis-bases-datos.zip $EXPORT_DIR

# Limpiar directorio temporal
rm -rf $EXPORT_DIR

echo -e "${GREEN}¡Exportación completada!${NC}"
echo -e "Se ha creado el archivo 'mis-bases-datos.zip'"
echo -e "Para usar en otra PC:"
echo -e "1. Copia el archivo ZIP a la nueva PC"
echo -e "2. Descomprime el archivo"
echo -e "3. Ejecuta ./setup.sh" 