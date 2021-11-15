#!/bin/bash

if [ ! -d /home/wodby ]
then
  if [[ ${1} == '-v' ]]; then
    docker-compose exec php bash htools/scripts/run-behat-test.sh -v
  else
    docker-compose exec php bash htools/scripts/run-behat-test.sh
  fi

  exit
fi

if [ ! -f vendor/bin/behat ]; then
  composer require --dev behat/behat dmore/behat-chrome-extension drupal/drupal-extension
else
  bash htools/scripts/generate-users-per-role.sh -c
  vendor/bin/behat --config htools/behat_tests/behat.yml --init

  if [ ! -f htools/behat_tests/existing_options_es.txt ];then
    echo htools/behat_tests/existing_options_es* >> .gitignore
    vendor/bin/behat --config htools/behat_tests/behat.yml -dl --lang es >> htools/behat_tests/existing_options_es.txt
  fi

  if [ ! -f htools/behat_tests/existing_options_en.txt ];then
    echo htools/behat_tests/existing_options_en* >> .gitignore
    vendor/bin/behat --config htools/behat_tests/behat.yml -dl --lang en >> htools/behat_tests/existing_options_en.txt
  fi

  if [[ ${1} == '-v' ]]; then
    vendor/bin/behat --config htools/behat_tests/behat.yml
  else
    vendor/bin/behat --config htools/behat_tests/behat.yml -f progress
  fi

  # vendor/bin/behat --config htools/behat_tests/behat.yml --help
  bash htools/scripts/generate-users-per-role.sh -d
fi


echo "run 'bash htools/scripts/run-behat-test.sh -v' to see verbose"
