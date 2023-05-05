#!/bin/sh

echo "##################################"
echo "#  Executing project onboarding  #"
echo "##################################"
echo "Please, answer the following questions to get you up and running"
echo "----------------------------------"

### Onboarding
while true; do
  printf "Choose your host OS ([linux], wsl, windows, macos): "
  read -r PROJECT_OS
  PROJECT_OS=${PROJECT_OS:-linux}
  case $PROJECT_OS in
  linux* | wsl*)
    cp ./scaffold/templates/docker/docker-compose.linux.yml ./docker-compose.override.yml
    break
    ;;
  windows*)
    cp ./scaffold/templates/docker/docker-compose.windows.yml ./docker-compose.override.yml
    break
    ;;
  macos*)
    cp ./scaffold/templates/docker/docker-compose.macos.yml ./docker-compose.override.yml
    break
    ;;
  *) echo "Invalid answer, try again." ;;
  esac
done

cp -f ./.env.dist ./.env &&
  echo "  > .env.dist copied to .env"

. ./.env
if [ "${WEB_SERVER}" = "nginx" ]; then
  sed -i '24,26 s/^#//' ./docker-compose.override.yml
else
  sed -i '28,30 s/^#//' ./docker-compose.override.yml
fi && echo "  > enabled $WEB_SERVER server"

printf "Enter your IDE ([phpstorm] or vscode): "
read -r IDE
IDE=${IDE:-phpstorm}
sed -i "14,14 s/$/${IDE}/" ./.env &&
  sed -i "15,15 s/$/${IDE}/" ./.env &&
  echo "  > $IDE IDE selected"

### Set proper PHP image for macOS users
if [ "$PROJECT_OS" = "macos" ]; then
  echo "  * setting proper PHP image for macOS users"
  sed -i '98,98 s/^/#/' ./.env
  sed -i '104,104 s/^#//' ./.env
fi

echo "=================================="
echo "Onboarding completed!"
echo "##################################"
