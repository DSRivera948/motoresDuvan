# Entorno de Bases de Datos para Desarrollo

Este proyecto configura un entorno completo con múltiples bases de datos para desarrollo y pruebas.

## Bases de Datos Incluidas

- PostgreSQL 15
- MySQL 8.0
- SQL Server 2019 Express
- Oracle Database 21c Express Edition

## Requisitos

- Docker y Docker Compose instalados
- Al menos 8GB de RAM disponible
- Al menos 20GB de espacio libre en disco

## Instrucciones de Uso

### Iniciar los Servicios

```bash
# Clonar el repositorio (si es necesario)
git clone https://github.com/tu-usuario/mis-bases-datos.git
cd mis-bases-datos

# Iniciar todos los servicios
docker-compose up -d
```

### Detener los Servicios

```bash
docker-compose down
```

### Estado de los Servicios

```bash
docker-compose ps
```

## Información de Conexión

### PostgreSQL

- **Host**: localhost
- **Puerto**: 5432
- **Usuario**: duvan
- **Contraseña**: 12345678
- **Base de datos**: testdb

### MySQL

- **Host**: localhost
- **Puerto**: 3306
- **Usuario**: duvan
- **Contraseña**: 12345678
- **Base de datos**: rapido_ya
- **Usuario Root**: root
- **Contraseña Root**: 12345678

### SQL Server

- **Host**: localhost
- **Puerto**: 1433
- **Usuario**: sa
- **Contraseña**: Duvan123
- **Edición**: Express

### Oracle

- **Host**: localhost
- **Puerto**: 1521
- **Servicio**: XEPDB1 (¡importante usar Service Name, no SID!)
- **Usuario Administrador**: system
- **Contraseña Administrador**: Oracle123
- **Usuario Aplicación**: duvan
- **Contraseña Aplicación**: 12345678

## Solución de Problemas

### Oracle

Si al conectarse a Oracle aparece el error "ORA-12505" o "SID no registrado con el listener", asegúrate de:

1. Usar "XEPDB1" como Service Name (no como SID)
2. Asegúrate de que el contenedor esté completamente iniciado (puede tardar hasta 2 minutos)

Si aparece el error "ORA-01017: invalid username/password", puedes restablecer la contraseña con:

```bash
docker exec oracle-xe resetPassword Oracle123
```

### SQL Server

Si hay problemas con la autenticación en SQL Server, asegúrate de:

1. Usar autenticación SQL Server (no Windows)
2. Verificar que la contraseña cumple con los requisitos de complejidad

### Persistencia de Datos

Los datos de todas las bases de datos se guardan en volúmenes Docker con los siguientes nombres:

- PostgreSQL: mis_bases_postgres_data
- MySQL: mis_bases_mysql_data
- SQL Server: mis_bases_sqlserver_data
- Oracle: mis_bases_oracle_data

Estos volúmenes persisten incluso cuando los contenedores se detienen.

## Uso en Otra Máquina

Para usar esta configuración en otra máquina:

1. Copia el archivo `docker-compose.yml` a la nueva máquina
2. Copia el archivo `README.md` para referencia
3. Ejecuta `docker-compose up -d` en la nueva máquina

Si quieres mover los datos existentes, tendrás que exportarlos desde cada base de datos y luego importarlos en la nueva instalación. # motoresDuvan
