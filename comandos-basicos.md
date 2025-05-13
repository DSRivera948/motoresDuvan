# Comandos Básicos para Bases de Datos

Este documento contiene comandos básicos para trabajar con las diferentes bases de datos configuradas.

## PostgreSQL

### Conectarse
```bash
# Desde la línea de comandos
docker exec -it postgres psql -U duvan -d testdb

# Desde un cliente: 
# Host: localhost, Puerto: 5432, Usuario: duvan, Contraseña: 12345678, BD: testdb
```

### Comandos Útiles
```sql
-- Listar bases de datos
\l

-- Listar tablas
\dt

-- Crear una tabla
CREATE TABLE personas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

-- Insertar datos
INSERT INTO personas (nombre, correo) VALUES ('Juan', 'juan@ejemplo.com');

-- Consultar datos
SELECT * FROM personas;

-- Salir
\q
```

## MySQL

### Conectarse
```bash
# Desde la línea de comandos
docker exec -it mysql mysql -u duvan -p12345678 rapido_ya

# Desde un cliente: 
# Host: localhost, Puerto: 3306, Usuario: duvan, Contraseña: 12345678, BD: rapido_ya
```

### Comandos Útiles
```sql
-- Listar bases de datos
SHOW DATABASES;

-- Usar una base de datos
USE rapido_ya;

-- Listar tablas
SHOW TABLES;

-- Crear una tabla
CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

-- Insertar datos
INSERT INTO clientes (nombre, correo) VALUES ('María', 'maria@ejemplo.com');

-- Consultar datos
SELECT * FROM clientes;

-- Salir
EXIT;
```

## SQL Server

### Conectarse
```bash
# Desde la línea de comandos
docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Duvan123"

# Desde un cliente: 
# Host: localhost, Puerto: 1433, Usuario: sa, Contraseña: Duvan123
```

### Comandos Útiles
```sql
-- Listar bases de datos
SELECT name FROM sys.databases;
GO

-- Crear una base de datos
CREATE DATABASE miproyecto;
GO

-- Usar una base de datos
USE miproyecto;
GO

-- Crear una tabla
CREATE TABLE empleados (
  id INT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100),
  correo NVARCHAR(100)
);
GO

-- Insertar datos
INSERT INTO empleados (nombre, correo) VALUES ('Carlos', 'carlos@ejemplo.com');
GO

-- Consultar datos
SELECT * FROM empleados;
GO

-- Salir
EXIT
```

## Oracle

### Conectarse
```bash
# Desde la línea de comandos (como system)
docker exec -it oracle-xe sqlplus system/Oracle123@//localhost:1521/XEPDB1

# Desde la línea de comandos (como duvan)
docker exec -it oracle-xe sqlplus duvan/12345678@//localhost:1521/XEPDB1

# Desde un cliente: 
# Host: localhost, Puerto: 1521, Servicio: XEPDB1
# Usuario: system, Contraseña: Oracle123
# o
# Usuario: duvan, Contraseña: 12345678
```

### Comandos Útiles
```sql
-- Ver usuario actual
SELECT USER FROM DUAL;

-- Crear una tabla (como usuario duvan)
CREATE TABLE productos (
  id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR2(100),
  precio NUMBER(10,2)
);

-- Insertar datos
INSERT INTO productos (nombre, precio) VALUES ('Laptop', 1200.50);

-- Consultar datos
SELECT * FROM productos;

-- Ver todas las tablas del usuario actual
SELECT table_name FROM user_tables;

-- Salir
EXIT;
```

## Respaldo y Restauración

### PostgreSQL
```bash
# Respaldo
docker exec -t postgres pg_dump -U duvan testdb > backup_postgres.sql

# Restauración
cat backup_postgres.sql | docker exec -i postgres psql -U duvan -d testdb
```

### MySQL
```bash
# Respaldo
docker exec -t mysql mysqldump -u duvan -p12345678 rapido_ya > backup_mysql.sql

# Restauración
cat backup_mysql.sql | docker exec -i mysql mysql -u duvan -p12345678 rapido_ya
```

### SQL Server
```bash
# Respaldo (desde dentro del contenedor)
docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "Duvan123" -Q "BACKUP DATABASE [miproyecto] TO DISK = N'/var/opt/mssql/backup/miproyecto.bak' WITH NOFORMAT, NOINIT, NAME = 'miproyecto-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

# Restauración requiere pasos adicionales y se recomienda usar herramientas como SQL Server Management Studio
```

### Oracle
```bash
# Oracle proporciona herramientas como expdp/impdp o exp/imp para respaldos
# Para un respaldo simple de una tabla:
docker exec -it oracle-xe bash -c "echo 'CREATE DIRECTORY exp_dir AS '"'"'/tmp'"'"';' | sqlplus system/Oracle123@//localhost:1521/XEPDB1"

docker exec -it oracle-xe bash -c "expdp system/Oracle123@//localhost:1521/XEPDB1 tables=duvan.productos directory=exp_dir dumpfile=productos.dmp logfile=productos.log"

# La restauración requiere pasos similares con impdp
``` 