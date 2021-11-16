#!/bin/bash

if [ ! -d /home/wodby ]
then
    docker-compose exec php bash scripts/generate-new-site-uuid.sh
  exit
fi
uuid=$(drush ev '$uuid_service=\Drupal::service("uuid");$uuid=$uuid_service->generate();echo "$uuid\n";')
drush -y cset system.site uuid ${uuid}
drush -y cex
