#!/bin/bash

# Creamos los archivos .env y docker-compose.override.yml
if [[ $1 = '--dev' ]]
then
  echo "BORRANDO!!!"
  docker-compose down --remove-orphans
  sudo rm -fr .salt htools/.salt
  sudo rm -fr vendor composer.lock .env docker-compose.override.yml .salt htools/.salt
  ln -fs htools/environments/local/docker-compose.override.yml.dist docker-compose.override.yml
  ln -fs htools/examples/.env.example .env
else
  if [ ! -f docker-compose.override.yml ]
  then
    cp htools/environments/local/docker-compose.override.yml.dist docker-compose.override.yml
  fi
  if [ ! -f .env ]
  then
    foldername=${PWD##*/}
    cp htools/examples/.env.example .env
    sed -i "s/hdrupal/$foldername/" ./.env
  fi
fi

if [ -f docker-compose.override.yml ] && [ -f .env ]
then
  # levantamos docker
  docker stop $(docker ps -a -q) > /dev/null
  docker-compose build --parallel
  docker-compose up -d --remove-orphans
  sleep 3
  # composer install
  docker-compose exec php composer install
  docker-compose exec php composer install -q
  docker-compose exec php composer install -q
  sleep 1
  # generamos nuevo salt si no existe
  if [ ! -f .salt ]
  then
    docker-compose exec php scripts/generate-salt.sh
  fi
  sleep 1
  # levantamos docker
  docker-compose exec php drush si --existing-config -y
  sleep 1
  # generamos nuevo site uuid
  bash scripts/generate-new-site-uuid.sh
  # generamos enlace de inicio de sesión
  docker-compose exec php drush uli
  sleep 3
  # comprobamos la instalacion
  bash scripts/run-behat-test.sh
fi
