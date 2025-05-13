#!/bin/bash

# Colores para salida
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Verificando conexiones a todas las bases de datos...${NC}\n"

# Función para mostrar resultados
test_connection() {
  if [ $? -eq 0 ]; then
    echo -e "  ${GREEN}✓ Conexión exitosa a $1${NC}"
  else
    echo -e "  ${RED}✗ No se pudo conectar a $1${NC}"
  fi
}

# Verificar que los contenedores estén funcionando
echo -e "${YELLOW}Verificando estado de los contenedores:${NC}"
docker ps | grep -E '(postgres|mysql|sqlserver|oracle-xe)'
echo ""

# Probar PostgreSQL
echo -e "${YELLOW}PostgreSQL:${NC}"
docker exec postgres pg_isready -h localhost -U duvan > /dev/null 2>&1
test_connection "PostgreSQL"

# Comprobar si podemos ejecutar una consulta en PostgreSQL
echo -n "  Ejecutando consulta: "
if docker exec postgres psql -U duvan -d testdb -c "SELECT 1 as test;" > /dev/null 2>&1; then
  echo -e "${GREEN}OK${NC}"
else
  echo -e "${RED}Falló${NC}"
fi

# Probar MySQL
echo -e "\n${YELLOW}MySQL:${NC}"
docker exec mysql mysqladmin ping -h localhost -u duvan -p12345678 --silent > /dev/null 2>&1
test_connection "MySQL"

# Comprobar si podemos ejecutar una consulta en MySQL
echo -n "  Ejecutando consulta: "
if docker exec mysql mysql -u duvan -p12345678 rapido_ya -e "SELECT 1 as test;" > /dev/null 2>&1; then
  echo -e "${GREEN}OK${NC}"
else
  echo -e "${RED}Falló${NC}"
fi

# Probar SQL Server
echo -e "\n${YELLOW}SQL Server:${NC}"
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Duvan123" -Q "SELECT 1" > /dev/null 2>&1
test_connection "SQL Server"

# Probar Oracle
echo -e "\n${YELLOW}Oracle:${NC}"
docker exec oracle-xe bash -c "echo 'SELECT 1 FROM DUAL;' | sqlplus -s system/Oracle123@//localhost:1521/XEPDB1" > /dev/null 2>&1
test_connection "Oracle (system)"

# Probar usuario de aplicación de Oracle
docker exec oracle-xe bash -c "echo 'SELECT 1 FROM DUAL;' | sqlplus -s duvan/12345678@//localhost:1521/XEPDB1" > /dev/null 2>&1
test_connection "Oracle (duvan)"

echo -e "\n${YELLOW}Información de conexión para clientes externos:${NC}"
echo -e "${GREEN}PostgreSQL:${NC} localhost:5432 - duvan/12345678 - Base de datos: testdb"
echo -e "${GREEN}MySQL:${NC} localhost:3306 - duvan/12345678 - Base de datos: rapido_ya"
echo -e "${GREEN}SQL Server:${NC} localhost:1433 - sa/Duvan123"
echo -e "${GREEN}Oracle:${NC} localhost:1521 - system/Oracle123 - Servicio: XEPDB1"
echo -e "           localhost:1521 - duvan/12345678 - Servicio: XEPDB1" 