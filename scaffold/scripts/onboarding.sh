#!/bin/sh

echo "##################################";
echo "#  Executing project onboarding  #";
echo "##################################";
echo "Please, answer the following questions to get you up and running";
echo "----------------------------------";

### Onboarding
while true; do
    printf "Choose your host OS ([linux], windows, macos, wsl): "
    read -r PROJECT_OS;
    PROJECT_OS=${PROJECT_OS:-linux}
    case $PROJECT_OS in
        linux*|wsl* ) cp ./scaffold/templates/docker/docker-compose.linux.yml ./docker-compose.override.yml; break;;
        windows* ) cp ./scaffold/templates/docker/docker-compose.windows.yml ./docker-compose.override.yml; break;;
        macos* ) cp ./scaffold/templates/docker/docker-compose.macos.yml ./docker-compose.override.yml; break;;
        * ) echo "Invalid answer, try again.";;
    esac
done

cp -f ./.env.dist ./.env;
# IN=$(sed '20q;d' ./.env);
# arrIN=${IN//=/ };

. ./.env
if [ "${WEB_SERVER}" = "nginx" ]; then
    sed -i '24,26 s/^#//' ./docker-compose.override.yml
else
    sed -i '28,30 s/^#//' ./docker-compose.override.yml
fi

printf "Enter your IDE ([phpstorm] or vscode): ";
read -r IDE;
IDE=${IDE:-phpstorm} ;
sed -i "14,14 s/$/${IDE}/" ./.env
sed -i "15,15 s/$/${IDE}/" ./.env

### Set proper PHP image for macOS users
if [ "$PROJECT_OS" = "macos" ]; then
	sed -i '98,98 s/^/#/' ./.env
	sed -i '104,104 s/^#//' ./.env
fi

echo "==================================";
echo "Onboarding completed!";
echo "##################################";
