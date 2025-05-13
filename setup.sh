#!/bin/bash

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Configurando entorno de bases de datos...${NC}\n"

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker no está instalado. Por favor, instala Docker y Docker Compose primero.${NC}"
    echo "Puedes seguir las instrucciones en: https://docs.docker.com/engine/install/"
    exit 1
fi

# Verificar que Docker Compose esté instalado
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose no está instalado. Por favor, instala Docker Compose primero.${NC}"
    echo "Puedes seguir las instrucciones en: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}Docker y Docker Compose están instalados correctamente.${NC}"

# Detener y eliminar contenedores existentes (si existen)
echo -e "\n${YELLOW}Deteniendo y eliminando contenedores existentes si existen...${NC}"
docker-compose down 2>/dev/null

# Iniciar los contenedores
echo -e "\n${YELLOW}Iniciando los contenedores...${NC}"
docker-compose up -d

# Esperar a que los contenedores estén listos
echo -e "\n${YELLOW}Esperando a que los contenedores estén listos...${NC}"
echo "Este proceso puede tardar varios minutos (especialmente para Oracle)."
echo "Por favor, espera..."

# Contador para mostrar progreso
counter=0
while [ $counter -lt 60 ]; do
    counter=$((counter+1))
    echo -n "."
    sleep 1
done
echo ""

# Verificar el estado de los contenedores
echo -e "\n${YELLOW}Verificando el estado de los contenedores:${NC}"
docker ps | grep -E '(postgres|mysql|sqlserver|oracle-xe)'

# Establecer contraseña para Oracle (por si acaso)
echo -e "\n${YELLOW}Configurando contraseña de Oracle...${NC}"
docker exec oracle-xe resetPassword Oracle123 || true

# Crear usuario duvan en Oracle si no existe
echo -e "\n${YELLOW}Creando usuario duvan en Oracle...${NC}"
docker exec oracle-xe createAppUser duvan 12345678 XEPDB1 || true

echo -e "\n${GREEN}¡Configuración completada!${NC}"
echo -e "Puedes verificar las conexiones ejecutando: ./test-connections.sh"
echo -e "Para información sobre cómo conectarte a las bases de datos, consulta el archivo README.md" 