## Preparación
### Alternativa 1
1. Ejecuta el archivo desde el terminal:
````bash
bash scripts/start.sh
````

### Alternativa 2
1. Copia el archivo ``htools/examples/.env.example`` a ``.env``
   1. Edita el archivo ``.env`` a tu gusto
2. Copia el archivo
``htools/environments/local/docker-compose.override.yml.dist`` a
``docker-compose.override.yml``

## Docker e instalación del proyecto
- Para arrancar los contenedores en tu equipo ejecuta:
``docker-compose up -d --build``
- Entramos en el contenedor usando ``docker-compose exec webapp bash``:
    - Ejecuta ``composer install`` para instalar todas las dependencias (por
    defecto
se ejecuta con ``--dev`` instalando también las dependencias de desarrollo)
    - Importa la base de datos: ``drush sql-cli < bd.sql`` o realiza una nueva
    instalación con la configuración existente:
    ``drush si --existing-config -y``
    - Actualiza la base de datos e importa la configuración: ``drush deploy``
    - En algunas ocasiones puede ser necesario repetir la importación de la
    configuración varias veces con ``drush cim``
- Accede a
 [mysitename.docker.localhost:8000](http://mysitename.docker.localhost:8000)
