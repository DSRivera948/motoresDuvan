#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Iniciando configuración de bases de datos...${NC}"

# Función para verificar si un puerto está en uso
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo -e "${RED}El puerto $1 está en uso. Por favor, detén el servicio que lo está usando.${NC}"
        exit 1
    fi
}

# Verificar puertos
echo -e "${GREEN}Verificando puertos...${NC}"
check_port 5432
check_port 3306
check_port 1433

# Detener y eliminar contenedores existentes
echo -e "${GREEN}Limpiando contenedores existentes...${NC}"
docker-compose down -v --remove-orphans

# Eliminar redes no utilizadas
echo -e "${GREEN}Limpiando redes no utilizadas...${NC}"
docker network prune -f

# Iniciar contenedores
echo -e "${GREEN}Iniciando contenedores...${NC}"
docker-compose up -d

# Esperar a que los contenedores estén listos
echo -e "${GREEN}Esperando a que los contenedores estén listos...${NC}"
sleep 15

# Verificar estado de los contenedores
echo -e "${GREEN}Verificando estado de los contenedores...${NC}"
docker ps

# Verificar logs si hay errores
if [ $? -ne 0 ]; then
    echo -e "${RED}Hubo un error al iniciar los contenedores. Revisando logs...${NC}"
    docker-compose logs
    exit 1
fi

echo -e "\n${GREEN}¡Configuración completada!${NC}"
echo -e "\nCredenciales de conexión:"
echo -e "\nPostgreSQL:"
echo -e "Host: localhost"
echo -e "Puerto: 5432"
echo -e "Usuario: duvan"
echo -e "Contraseña: 12345678"
echo -e "Base de datos: testdb"
echo -e "\nMySQL:"
echo -e "Host: localhost"
echo -e "Puerto: 3306"
echo -e "Usuario: duvan"
echo -e "Contraseña: 12345678"
echo -e "Base de datos: testdb"
echo -e "\nSQL Server:"
echo -e "Host: localhost"
echo -e "Puerto: 1433"
echo -e "Usuario: sa"
echo -e "Contraseña: Duvan123" 