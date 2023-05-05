#!/bin/sh

echo "WARNING! Docker containers, volumes and scaffolded files and directories will be DESTROYED"
while true; do
  printf "Do you wish to continue? "
  read -r yn
  # yn=${yn:-y}
  case $yn in
  [Yy]*)
    [ ! -f ./docker-compose.yml ] && cp $PWD/scaffold/templates/docker/docker-compose.yml ./docker-compose.yml
    [ ! -f ./.env ] && cp $PWD/scaffold/templates/docker/.env.dist ./.env && echo "PROJECT_NAME=PROJECT_NAME" >>.env
    make -f "$PWD/scaffold/make/setup.mk" _clean
    break
    ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
done
